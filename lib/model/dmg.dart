// To parse this JSON data, do
//
//     final damgeAsset = damgeAssetFromJson(jsonString);

import 'dart:convert';

List<DamgeAsset> damgeAssetFromJson(String str) => List<DamgeAsset>.from(json.decode(str).map((x) => DamgeAsset.fromJson(x)));

String damgeAssetToJson(List<DamgeAsset> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DamgeAsset {
    String? damge;
    List<Code>? code;

    DamgeAsset({
        this.damge,
        this.code,
    });

    factory DamgeAsset.fromJson(Map<String, dynamic> json) => DamgeAsset(
        damge: json["damge"],
        code: json["code"] == null ? [] : List<Code>.from(json["code"]!.map((x) => Code.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "damge": damge,
        "code": code == null ? [] : List<dynamic>.from(code!.map((x) => x.toJson())),
    };
}

class Code {
    String? id;
    String? description;

    Code({
        this.id,
        this.description,
    });

    factory Code.fromJson(Map<String, dynamic> json) => Code(
        id: json["id"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
    };
}
