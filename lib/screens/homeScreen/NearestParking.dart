// To parse this JSON data, do
//
//     final nearestParking = nearestParkingFromJson(jsonString);

import 'dart:convert';

NearestParking nearestParkingFromJson(String str) => NearestParking.fromJson(json.decode(str));

String nearestParkingToJson(NearestParking data) => json.encode(data.toJson());

class NearestParking {
  NearestParking({

   required this.condition,
    required  this.nearestParkings,
  });

  bool condition;
  List<NearestParkingElement> nearestParkings;

  factory NearestParking.fromJson(Map<String, dynamic> json) => NearestParking(
    condition: json["condition"],
    nearestParkings: List<NearestParkingElement>.from(json["nearestParkings"].map((x) => NearestParkingElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "condition": condition,
    "nearestParkings": List<dynamic>.from(nearestParkings.map((x) => x.toJson())),
  };
}

class NearestParkingElement {
  NearestParkingElement({
    required  this.id,
    required this.complexName,
    required this.address,
    required this.price,
    required  this.lat,
    required  this.lng,
    required this.v,
  });

  String id;
  String complexName;
  String address;
  String price;
  double lat;
  double lng;
  int v;

  factory NearestParkingElement.fromJson(Map<String, dynamic> json) => NearestParkingElement(
    id: json["_id"],
    complexName: json["complexName"],
    address: json["address"],
    price: json["price"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "complexName": complexName,
    "address": address,
    "price": price,
    "lat": lat,
    "lng": lng,
    "__v": v,
  };
}
