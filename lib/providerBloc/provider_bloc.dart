import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sg_motorcycle_parking/screens/homeScreen/GetParking.dart';
import 'package:sg_motorcycle_parking/screens/homeScreen/NearestParking.dart';
import 'package:url_launcher/url_launcher.dart';

import 'geolocator.dart';

class providerBloc with ChangeNotifier {
  final geolocator = geoLocatorService();
  Position? getCurrentPosition;
  bool isBottomOpen=false;

  BitmapDescriptor customIcon=BitmapDescriptor.defaultMarker;

  NearestParkingElement nearestParkingElementObj=NearestParkingElement(id: "", complexName: "", address: "", price: "", lat: 0.0, lng: 0.0, v: 2);

  ifBottomOPen(s)
  {
    isBottomOpen=s;
  }
  Map<MarkerId, Marker> markers = {};

  getLocation()
  {
    return getCurrentPosition;
  }

  providerBloc() {
    setCurrentLocation();


// make sure to initialize before map loading

  }

  setCurrentLocation() async {
    getCurrentPosition = await geolocator.getCurrentPosition();
    notifyListeners();
  }

  Future<void> addMarkerOnScreen(List<NearestParkingElement>  l) async {
   await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/images/parking.png')
        .then((d) {
      customIcon = d;
    });

    print(" dada ${customIcon.toJson().toString()}");
    for(int i=0;i<l.length;i++)
    {
            _addMarker(
        LatLng(l[i].lat, l[i].lng),
              l[i].id,
                BitmapDescriptor.defaultMarkerWithHue(60                  ),l[i].lat, l[i].lng,l[i]
      );

    }
    notifyListeners();


  }
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor,lat,lng, NearestParkingElement l) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position,onTap: ()
    {

      nearestParkingElementObj=l;

      ifBottomOPen(true);
      notifyListeners();

      //openMap(lat,lng);
    }

    );
    markers[markerId] = marker;

  }


}
