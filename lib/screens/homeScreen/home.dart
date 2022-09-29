import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sg_motorcycle_parking/globalWidgets/drawer.dart';
import 'package:sg_motorcycle_parking/providerBloc/provider_bloc.dart';
import 'package:sg_motorcycle_parking/screens/homeScreen/NearestParking.dart';
import 'package:sg_motorcycle_parking/screens/profileScreen/profile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'GetParking.dart';
import 'package:http/http.dart' as http;
import 'package:sg_motorcycle_parking/SharedPreferences/SharedUserData.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
// LatLng(24.858480, 67.001884),

// Starting point latitude
double? _originLatitude;
// Starting point longitude
double? _originLongitude;
// Destination latitude
double _destLatitude = 24.858480;
// Destination Longitude
double _destLongitude = 67.001884;
// Markers to show points on the map
Map<MarkerId, Marker> markers = {};

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

GoogleMapController? _googleMapController;

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool isSearching = false;
  bool parkingSpotSearched = false;

  bool serachedLoading = false;
  bool emptySerachbar = true;

  List<GetParking> recentParkingList = [];
  List<GetParking> suggestionParkingList = [];
  TextEditingController searchTextCon = new TextEditingController();
  var header = new Map<String, String>();
  PanelController _pc1 = new PanelController();

  int slidePanelPos = -1;


  // Google Maps controller
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState

    // recentParkingList.add(new GetParking(id: "1", complexName: "complexName", address: "address", price: "price", v: 1));
    // recentParkingList.add(new GetParking(id: "1", complexName: "complexName", address: "address", price: "price", v: 1));
    // recentParkingList.add(new GetParking(id: "1", complexName: "complexName", address: "address", price: "price", v: 1));
    super.initState();

    ShareUserData.fetchRecentData().then((value) {
      print("Eas ${value.length}");
      if (value.length > 0) {
        recentParkingList = value;
      }
    });
    header = new Map<String, String>();
    ShareUserData.fetchData().then((v) {
      print("okkkk ${v}");
      header['Authorization'] = "${v}";
      header['Content-Type'] = "application/json";
    });



   // Provider.of<providerBloc>(context).getCurrLocationproviderBloc();
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  Future<void> _getPolyline(olat, olng, dlat, dlong) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCFiS3J95syNrmbl4JjQpWr8po9vXLzJvw",
      PointLatLng(olat, olng),
      PointLatLng(dlat, dlong),
    
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      print("basha ");

      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("bashasssssss");

      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red, 
    
      points: polylineCoordinates,
      width: 10,
    );
    polylines[id] = polyline;
    // setState(() {});
  }

  Future<void> addMarkerOnScreen(olat, olongitude, dlat, dlong) async {
    if (dlat != "" && dlong != "") {
      _addMarker(
        LatLng(olat, olongitude),
        "origin",
        BitmapDescriptor.defaultMarkerWithHue(90),
      );
      _addMarker(
        //  LatLng(24.858480, 67.001884),
        LatLng(dlat, dlong),
        "destination",
        BitmapDescriptor.defaultMarker,
      );
    } else {
// Add destination marker
      _addMarker(
        LatLng(olat, olongitude),
        "origin", 
        BitmapDescriptor.defaultMarkerWithHue(90),
      );
      // _addMarker(
      //   LatLng(_destLatitude, _destLongitude),
      //   "destination",
      //   BitmapDescriptor.defaultMarkerWithHue(90),
      // );
    }
  }

  Future<LatLng> getDestinationLatLng(q) async {
    List<Location> locations = await locationFromAddress(q);

    print("adddd ${locations.first.longitude}");
    print("adddd ${locations.first.latitude}");

    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  @override
  Widget build(BuildContext context) {
    providerBloc providerBlocData = Provider.of<providerBloc>(context);
    // getAddressData();

    return SafeArea(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await getDestinationLatLng("Saddar Karachi").then((value) {
        //       _destLatitude = value.latitude;
        //       _destLongitude = value.longitude;
        //     });
        //     await _getPolyline(
        //         providerBlocData.getCurrentPosition!.latitude,
        //         providerBlocData.getCurrentPosition!.longitude,
        //         _destLatitude,
        //         _destLongitude);
        //     setState(() {
        //       addMarkerOnScreen(
        //           providerBlocData.getCurrentPosition!.latitude,
        //           providerBlocData.getCurrentPosition!.longitude,
        //           _destLatitude,
        //           _destLongitude);
        //     });
        //   },
        // ),
        drawer: drawer(context),
        appBar: appBar(),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: providerBlocData.getCurrentPosition == null
                      ? Container()
                      : googleMap(providerBlocData)),
              // getParkObject.id == "" || isSearching
              //     ? SizedBox()
              //     : slidingUpPanel(getParkObject,providerBlocData),

              Consumer<providerBloc>(builder: (context, value, child) {
                return value.isBottomOpen?slidingUpPanel(value.nearestParkingElementObj):SizedBox();

              },)
              ,
              !isSearching ? SizedBox() : searchSuggestionsBox(),
              parkingSpotSearched ? SizedBox() : selectAParkingSpotText()
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////
  /////////////////////////////////Widgets//////////////////////////////
  //////////////////////////////////////////////////////////////////////

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: Colors.red.shade600,
      title: TextField(
        controller: searchTextCon,
        onTap: () {
          setState(() {
            isSearching = true;
            parkingSpotSearched = true;
          });
        },
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              print("lenthh");
              serachedLoading = true;

              fetchParking(v.toLowerCase()).then((value) {
                suggestionParkingList = [];
                suggestionParkingList = value;
                setState(() {
                  serachedLoading = false;
                });
              });
            } else {
              serachedLoading = false;
            }
            if (v.length == 0) {
              emptySerachbar = true;
            } else {
              emptySerachbar = false;
            }
          });
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(color: Colors.transparent)),
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
            suffixIcon: isSearching
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearching = false;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.red.shade600,
                      size: 20,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.red.shade600,
                      size: 20,
                    ),
                  ),
            hintText: 'Search parking spots',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////Widgets/////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////

  Widget googleMap(providerBlocData) {
    // return GoogleMap(
    //     // mapType: MapType.normal,
    //     // myLocationEnabled: true,
    //     //
    //
    //
    //
    //     ));

    //_getPolyline(_originLatitude, _destLongitude,24.858480, 67.001884);

    return Consumer<providerBloc>(
      builder: (context, value, child) {
        _originLatitude = value.getCurrentPosition!.latitude;
        _destLongitude = value.getCurrentPosition!.longitude;


        //  addMarkerOnScreen(_originLatitude,_destLongitude,"","");
        return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                zoom: 11,
                target: LatLng(value.getCurrentPosition!.latitude,
                   value.getCurrentPosition!.longitude)),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            polylines: Set<Polyline>.of(polylines.values),
            markers: Set<Marker>.of(value.markers.values),
            onTap: (latLng){
            },
            onMapCreated: (GoogleMapController controller) {
              _googleMapController=controller;
              _controller.complete(controller);
            });
      },
    );
  }


  Widget slidingUpPanel(NearestParkingElement suggestionParkingObj) {
    return SlidingUpPanel(
      maxHeight: 300,
      minHeight: 60,
      controller: _pc1,
      panel:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              color: Colors.black.withOpacity(.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red.shade600,
                        size: 24,
                      ),
                      Text(
                        ' ${suggestionParkingObj.address}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _pc1.close();
                    },
                    child: Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey.shade800,
                          size: 13,
                        )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red.shade600,
                        size: 22,
                      ),
                      Text(
                        ' ${suggestionParkingObj.complexName}',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.money,
                        color: Colors.green,
                        size: 22,
                      ),
                      Text(
                        ' \$ ${suggestionParkingObj.price}',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.speaker,
                        color: Colors.grey.shade800,
                        size: 22,
                      ),
                      Text(
                        ' Parking available at level 5 and level 6',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        //bottom bar
        Container(
          height: 100,
          color: Colors.red.shade600,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                    // providerBloc providerBlocData =  Provider.of<providerBloc>(context);
                    _pc1.close();


                    openMap(suggestionParkingObj.lat,suggestionParkingObj.lng);


                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        Icons.map_outlined,
                        color: Colors.red.shade600,
                        size: 24,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Get Directions',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _onLoading();

                      reportProcess(suggestionParkingObj.id).then((value) {
                        Navigator.pop(context);

                        if (value.condition == true) {
                          toast(value.message);
                        } else {
                          toast("SomeThing Wrong, Try Again!");
                        }
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        Icons.stop_circle_outlined,
                        color: Colors.red.shade600,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Report',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Icon(
                      Icons.share_outlined,
                      color: Colors.red.shade600,
                      size: 24,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Share',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    print("Asassas ${latitude} ");
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }


  Widget searchSuggestionsBox() {
    return Container(
        height: 200,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white.withOpacity(.9)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Recent parking spots',
                  style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
              emptySerachbar
                  ? recenParking()
                  : serachedLoading
                      ? Container(
                          alignment: Alignment.topCenter,
                          width: double.infinity,
                          child: CircularProgressIndicator(),
                        )
                      : suggestionParking()
            ],
          ),
        ));
  }

  toast(msg) {

    Fluttertoast.showToast(
        msg: "${msg}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget selectAParkingSpotText() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 120),
        height: 100,
        padding: EdgeInsets.all(10),
        width: double.infinity,
        color: Colors.white.withOpacity(.7),
        alignment: Alignment.center,
        child: Text(
          'Please select a parking spot from the search menu',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<List<GetParking>> fetchParking(String q) async {
    try {
      var request = http.Request('GET',
          Uri.parse('https://arcane-stream-32449.herokuapp.com/getParking'));
      request.body = json.encode({"parkingname": "${q}"});
      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

//      print("parlist ${response.statusCode}");
      //   print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        final List<GetParking> users =
            getParkingFromJson(await response.stream.bytesToString());
        return users;
      } else {
        return <GetParking>[];
      }
    } catch (e) {
      return <GetParking>[];
    }
  }



  Future<NearestParking> fetchNearestParking(lat,lng) async {
    try {
      var request = http.Request('GET', Uri.parse('https://arcane-stream-32449.herokuapp.com/getNearestParkings'));
      request.body = json.encode({
        "lat": lat,
        "lng": lng
      });
      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      print("parlist ${response.statusCode}");
      //   print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        final NearestParking users = nearestParkingFromJson(await response.stream.bytesToString());
        return users;
      } else {
        return NearestParking(condition: false, nearestParkings: []);
      }
    } catch (e) {
      return NearestParking(condition: false, nearestParkings: []);
    }
  }

  Future<ReportModel> reportProcess(String id) async {
    try {
      var request = http.Request('POST',
          Uri.parse('https://arcane-stream-32449.herokuapp.com/report'));
      request.body = json.encode({"parkingId": "${id}"});
      request.headers.addAll(header);

      http.StreamedResponse response = await request.send();

      print("parReport ${response.statusCode}");
      //print(await response.stream.bytesToString());
      if (200 == response.statusCode) {
        final ReportModel users =
            reportModelFromJson(await response.stream.bytesToString());
        return users;
      } else {
        return ReportModel(condition: false, message: "");
      }
    } catch (e) {
      return ReportModel(condition: false, message: "");
    }
  }


  Widget recenParking() {
    return recentParkingList.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < recentParkingList.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () {
                      _destLatitude = recentParkingList[i].lat;
                      _destLongitude = recentParkingList[i].lng;


                      _onLoading();

                      fetchNearestParking(_destLatitude,_destLongitude).then((value) async{

                        Navigator.pop(context);
                        if(value.condition==true)
                        {
                          print("${value.nearestParkings} cvcvv ");
                          await Provider.of<providerBloc>(context ,listen: false).
                          addMarkerOnScreen(value.nearestParkings);

                        }
                        else
                        {
                          toast("Some thing Wrong Try Again");
                        }



                      });

                      FocusScope.of(context).unfocus();

                      //      Provider.of<providerBloc>(context ,listen: false).addMarkerOnScreen(suggestionParkingList);

                      //       Provider.of<providerBloc>(context ,listen: false).addMarkerOnScreen(suggestionParkingList[3].lat, suggestionParkingList[3].lng,"","");


                      var newPosition = CameraPosition(
                          target: LatLng(_destLatitude, _destLongitude),
                          zoom: 16);
                      CameraUpdate update =CameraUpdate.newCameraPosition(newPosition);

                      _googleMapController!.moveCamera(update);
                      print("getData");


                      setState(() {
                        isSearching = false;
                      });

                    },
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black87),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${recentParkingList[i].address}',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '${recentParkingList[i].complexName}',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
            ],
          )
        : Container(
            alignment: Alignment.center,
            child: Text("No recent Parking"),
          );
  }

  Widget suggestionParking() {
    return suggestionParkingList.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < suggestionParkingList.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () async{

                      _destLatitude = suggestionParkingList[i].lat;
                      _destLongitude = suggestionParkingList[i].lng;


                      _onLoading();

                      fetchNearestParking(_destLatitude,_destLongitude).then((value) async{

                        Navigator.pop(context);
                        if(value.condition==true)
                        {
                          print("${value.nearestParkings} cvcvv ");
                         await Provider.of<providerBloc>(context ,listen: false).
                          addMarkerOnScreen(value.nearestParkings);

                        }
                        else
                          {
                            toast("Some thing Wrong Try Again");
                          }



                      });

                      FocusScope.of(context).unfocus();

                      //      Provider.of<providerBloc>(context ,listen: false).addMarkerOnScreen(suggestionParkingList);

               //       Provider.of<providerBloc>(context ,listen: false).addMarkerOnScreen(suggestionParkingList[3].lat, suggestionParkingList[3].lng,"","");


                      var newPosition = CameraPosition(
                          target: LatLng(_destLatitude, _destLongitude),
                          zoom: 16);
                      CameraUpdate update =CameraUpdate.newCameraPosition(newPosition);

                      _googleMapController!.moveCamera(update);
                      print("getData");

                      var s= recentParkingList.where((element) => element.address==suggestionParkingList[i].address);

                      if(s.length==0)
                      {
                        recentParkingList.add(suggestionParkingList[i]);
                        ShareUserData.saveRecentData(recentParkingList);

                      }

                      setState(() {
                        isSearching = false;
                      });




                      // // await _getPolyline(
                      // //     providerBlocData.getCurrentPosition!.latitude,
                      // //     providerBlocData.getCurrentPosition!.longitude,
                      // //     _destLatitude,
                      // //     _destLongitude);
                      // setState(() {
                      //   parkingSpotSearched=true;
                      //   addMarkerOnScreen(
                      //       _destLatitude,
                      //       _destLongitude,"","");
                      // });

                      //
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black87),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${suggestionParkingList[i].address}',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '${suggestionParkingList[i].complexName}',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                )
            ],
          )
        : Container(
            alignment: Alignment.center,
            child: Text("No Address Found"),
          );
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new SizedBox(
                  width: 10,
                ),
                new Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }
}

//Model Class
ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  ReportModel({
    required this.condition,
    required this.message,
  });

  bool condition;
  String message;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        condition: json["condition"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "condition": condition,
        "message": message,
      };
}

