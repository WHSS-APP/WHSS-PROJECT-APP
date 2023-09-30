// To parse this JSON data, do
//
//     final locationAsset = locationAssetFromJson(jsonString);

import 'dart:convert';

List<LocationAsset> locationAssetFromJson(String str) => List<LocationAsset>.from(json.decode(str).map((x) => LocationAsset.fromJson(x)));

String locationAssetToJson(List<LocationAsset> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationAsset {
    String? strc;
    List<String>? loct;

    LocationAsset({
        this.strc,
        this.loct,
    });

    factory LocationAsset.fromJson(Map<String, dynamic> json) => LocationAsset(
        strc: json["strc"],
        loct: json["loct"] == null ? [] : List<String>.from(json["loct"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "strc": strc,
        "loct": loct == null ? [] : List<dynamic>.from(loct!.map((x) => x)),
    };
}
