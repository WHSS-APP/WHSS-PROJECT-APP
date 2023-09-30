import 'package:project_whss_app/model/damge.dart';

class DamageData {
  final List<Damage> damageList;

  DamageData({required this.damageList});

  factory DamageData.fromJson(List<dynamic> json) {
    List<Damage> damageList = json.map((item) => Damage.fromJson(item)).toList();

    return DamageData(damageList: damageList);
  }
}