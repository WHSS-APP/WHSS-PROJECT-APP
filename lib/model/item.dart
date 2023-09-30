import 'package:project_whss_app/model/damge.dart';
import 'package:project_whss_app/model/location.dart';

class Item {
  final String itemName;
  final Location location;
  final Damage? damage;
  final String level;
  final String status;
  final String picturePath;

  Item({
    required this.itemName,
    required this.location,
    this.damage,
    required this.level,
    required this.status,
    required this.picturePath,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['itemName'],
      location: Location.fromJson(json['location']),
      damage: json['damage'] != null ? Damage.fromJson(json['damage']!) : null,
      level: json['level'],
      status: json['status'],
      picturePath: json['picturePath'],
    );
  }
}