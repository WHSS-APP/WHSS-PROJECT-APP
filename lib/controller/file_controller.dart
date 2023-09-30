import 'package:flutter/foundation.dart';
import 'package:project_whss_app/file_manager.dart';
import 'package:project_whss_app/model/damage_data.dart';
import 'package:project_whss_app/model/job.dart';
import 'package:project_whss_app/model/user.dart';

class FileController extends ChangeNotifier {
  String _text = '';
  User? _user;
  Job? _job;
  DamageData? _damageData;

  String get text => _text;
  User? get user => _user;
  Job? get job => _job;
  DamageData? get damageData => _damageData;

  readText() async {
    _text = await FileManager().readTextFile();
    notifyListeners();
  }

  writeTextFile() async {
    _text = await FileManager().writeTextFile();
    notifyListeners();
  }

  readUser() async {
    final result = await FileManager().readJsonFile();

    if (result != null) {
      _user = User.fromJson(result);
    }

    notifyListeners();
  }

  writeUser() async {
    _user = await FileManager().writeJsonFile();
    notifyListeners();
  }

  readJob() async {
    final result = await FileManager().readJsonFile();

    if (result != null) {
      _job = Job.fromJson(result);

      print(_job);
    }

    notifyListeners();
  }

  // read damage data
  readDamage() async {
    final result = await FileManager().loadDamageData();

    _damageData = DamageData.fromJson(result);

    print(_damageData);
    notifyListeners();
  }
}
