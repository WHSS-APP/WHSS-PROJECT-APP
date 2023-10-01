// To parse this JSON data, do
//
//     final job = jobFromJson(jsonString);

import 'dart:convert';

List<Job> jobFromJson(String str) =>
    List<Job>.from(json.decode(str).map((x) => Job.fromJson(x)));

String jobToJson(List<Job> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Job {
  String itemName;
  Location location;
  Damage damage;
  String level;
  String block;
  String direction;
  String status;
  String picturePath;

  Job({
    required this.itemName,
    required this.location,
    required this.damage,
    required this.level,
    required this.block,
    required this.direction,
    required this.status,
    required this.picturePath,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        itemName: json["itemName"] ?? "",
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : Location(strc: "", loct: ""),
        damage: json["damage"] != null
            ? Damage.fromJson(json["damage"])
            : Damage(damge: "", code: "", description: ""),
        level: json["level"] ?? "",
        block: json["block"] ?? "",
        direction: json["direction"] ?? "",
        status: json["status"] ?? "",
        picturePath: json["picturePath"] ?? "",
      );

  get length => null;

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "location": location.toJson(),
        "damage": damage.toJson(),
        "level": level,
        "block": block,
        "direction": direction,
        "status": status,
        "picturePath": picturePath,
      };
}

class Damage {
  String damge;
  String code;
  String description;

  Damage({
    required this.damge,
    required this.code,
    required this.description,
  });

  factory Damage.fromJson(Map<String, dynamic> json) => Damage(
        damge: json["damge"],
        code: json["code"],
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "damge": damge,
        "code": code,
        "description": description,
      };
}

class Location {
  String strc;
  String loct;

  Location({
    required this.strc,
    required this.loct,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        strc: json["strc"] ?? [],
        loct: json["loct"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "strc": strc,
        "loct": loct,
      };
}
