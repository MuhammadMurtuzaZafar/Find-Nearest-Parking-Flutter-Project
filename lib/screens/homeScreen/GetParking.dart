// To parse this JSON data, do
//
//     final getParking = getParkingFromJson(jsonString);

import 'dart:convert';

List<GetParking> getParkingFromJson(String str) => List<GetParking>.from(json.decode(str).map((x) => GetParking.fromJson(x)));

String getParkingToJson(List<GetParking> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetParking {
    GetParking({
        required this.id,
        required this.complexName,
        required this.address,
        required this.price,
        required  this.lat,
        required  this.lng,
        required  this.v,
    });

    String id;
    String complexName;
    String address;
    String price;
    double lat;
    double lng;
    int v;

    factory GetParking.fromJson(Map<String, dynamic> json) => GetParking(
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
