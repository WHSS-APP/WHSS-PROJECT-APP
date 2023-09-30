import 'package:project_whss_app/model/damage_code.dart';

class Damage {
  final String damg;
  final List<DamageCode> DamageCodeList;

  Damage({required this.damg, required this.DamageCodeList});

  factory Damage.fromJson(Map<String, dynamic> json) {
    List<dynamic> damageCodeData = json['DamageCode'] ?? [];
    List<DamageCode> damageCodeList = damageCodeData.map((item) => DamageCode.fromJson(item)).toList();
    
    return Damage(
      damg: json['damg'],
      DamageCodeList: damageCodeList,
    );
  }
}