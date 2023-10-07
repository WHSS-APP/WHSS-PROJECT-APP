import 'package:flutter/foundation.dart';
import 'package:project_whss_app/file_manager.dart';
import 'package:project_whss_app/model/job.dart';
import 'package:project_whss_app/model/location.dart';
import 'package:project_whss_app/model/user.dart';
import 'package:project_whss_app/model/dmg.dart';

class FileController extends ChangeNotifier {
  String _text = '';
  User? _user;
  List<Job>? _job = [];
  List<DamgeAsset> _damge = [];
  List<LocationAsset> _strcLoct = [];

  String get text => _text;
  User? get user => _user;
  List<Job>? get job => _job;
  List<DamgeAsset> get damage => _damge;
  List<LocationAsset> get strcLoct => _strcLoct;

  readText() async {
    _text = await FileManager().readTextFile();
    notifyListeners();
  }

  writeTextFile() async {
    _text = await FileManager().writeTextFile();
    notifyListeners();
  }

  readJobs() async {
    dynamic result = await FileManager().readJob();
    // print(result);

    if (result != null && result is List<dynamic>) {
      // List<dynamic> jsonList = result;
      List<Job> jobs = result.map((json) => Job.fromJson(json)).toList();
      _job = jobs;
    }

    notifyListeners();
  }

  readJobById(String id) async {
    dynamic result = await FileManager().readJob();
    // print(result);

    if (result != null && result is List<dynamic>) {
      // List<dynamic> jsonList = result;
      List<Job> jobs = result.map((json) => Job.fromJson(json)).toList();
      _job = jobs.where((j) => j.itemName == id).toList();
    }

    notifyListeners();
  }

  updateJob(Job job) async {
    dynamic result = await FileManager().readJob();
    // print(result);

    if (result != null && result is List<dynamic>) {
      // List<dynamic> jsonList = result;
      List<Job> jobs = result.map((json) => Job.fromJson(json)).toList();
      jobs.removeWhere((j) => j.itemName == job.itemName);
      jobs.add(job);
      await FileManager().writeData(jobs as Map<String, dynamic>);
      _job = jobs;
    }

    notifyListeners();
  }

  recheckJob(Job job) async {
    dynamic result = await FileManager().readJob();
    // print(result);

    if (result != null && result is List<dynamic>) {
      // List<dynamic> jsonList = result;
      List<Job> jobs = result.map((json) => Job.fromJson(json)).toList();
      jobs.removeWhere((j) => j.itemName == job.itemName);
      jobs.add(job);
      await FileManager().writeData(jobs as Map<String, dynamic>);
      _job = jobs;
    }

    notifyListeners();
  }

  readDmg() async {
    // get result from dmg_code.json assets/data/dmg_code.json
    dynamic result = await FileManager().readDmg();

    if (result != null && result is List<dynamic>) {
      // List<dynamic> jsonList = result;
      List<DamgeAsset> dmg =
          result.map((json) => DamgeAsset.fromJson(json)).toList();
      _damge = dmg;
    }

    notifyListeners();
  }

  readStrLoct() async {
    dynamic result = await FileManager().readStrcLoct();

    if (result != null && result is List<dynamic>) {
      // List<dynamic> jsonList = result;
      List<LocationAsset> strcLoct =
          result.map((json) => LocationAsset.fromJson(json)).toList();
      _strcLoct = strcLoct;
    }

    notifyListeners();
  }

  writeUser() async {
    _user = await FileManager().writeJsonFile();
    notifyListeners();
  }
}
