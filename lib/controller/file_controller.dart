import 'package:flutter/foundation.dart';
import 'package:project_whss_app/file_manager.dart';
import 'package:project_whss_app/model/job.dart';
import 'package:project_whss_app/model/user.dart';

class FileController extends ChangeNotifier {
  String _text = '';
  User? _user;
  List<Job>? _job = [];

  String get text => _text;
  User? get user => _user;
  List<Job>? get job => _job;

  readText() async {
    _text = await FileManager().readTextFile();
    notifyListeners();
  }

  writeTextFile() async {
    _text = await FileManager().writeTextFile();
    notifyListeners();
  }

  readJobs() async {
    dynamic result = await FileManager().readJsonFile();
    if (result != null) {
      List<dynamic> jsonList = result;
      List<Job> jobs = jsonList.map((json) => Job.fromJson(json)).toList();
      _job = jobs;
    }

    notifyListeners();
  }

  writeUser() async {
    _user = await FileManager().writeJsonFile();
    notifyListeners();
  }
}
