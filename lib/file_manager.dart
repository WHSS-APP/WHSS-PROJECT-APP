import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_whss_app/model/damge.dart';
import 'package:project_whss_app/model/user.dart';

class FileManager {
  static FileManager _instance = FileManager.internal();

  FileManager.internal() {
    _instance = this;
  }

  factory FileManager() => _instance;

  Future<String> get _dicrectoryPath async {
    Directory? directory = await getExternalStorageDirectory();

    print(directory);

    return directory?.path ?? '';
  }

  Future<File> get _localFile async {
    final path = await _dicrectoryPath;
    return File('$path/whss.txt');
  }

  Future<File> get _jsonFile async {
    final path = await _dicrectoryPath;
    return File('$path/tempData.json');
  }

  Future<String> readTextFile() async {
    String fileContent = 'WHSS APP';

    File file = await _localFile;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
      } catch (e) {
        print(e);
      }
    }

    return fileContent;
  }

  Future<String> writeTextFile() async {
    String text = DateFormat('h:mm:ss').format(DateTime.now());

    File file = await _localFile;
    await file.writeAsString(text);

    return text;
  }

  Future<Map<String, dynamic>> readJsonFile() async {
    String fileContent = '';

    File file = await _jsonFile;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return json.decode(fileContent);
      } catch (e) {
        print(e);
      }
    }

    return {};
  }

  Future<User> writeJsonFile() async {
    final User user = User();

    File file = await _jsonFile;
    await file.writeAsString(json.encode(user));
    return user;
  }

  Future<List<Damage>> loadDamageData() async {
    // Load the JSON file from the assets
    String jsonString =
        await rootBundle.loadString('assets/data/dmg_code.json');

    // Parse the JSON data
    List<dynamic> jsonData = json.decode(jsonString);

    // Convert the JSON data into a list of Damage objects
    List<Damage> damageList =
        jsonData.map((item) => Damage.fromJson(item)).toList();

    return damageList;
  }
}
