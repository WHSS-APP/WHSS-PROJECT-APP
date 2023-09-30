import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_whss_app/model/user.dart';

class FileManager {
  static FileManager _instance = FileManager.internal();

  FileManager.internal() {
    _instance = this;
  }

  factory FileManager() => _instance;

  Future<String> get _dicrectoryPath async {
    Directory? directory = await getExternalStorageDirectory();
    return directory?.path ?? '';
  }

  Future<File> get _localFile async {
    final path = await _dicrectoryPath;
    return File('$path/whss.txt');
  }

  Future<File> get _readJobs async {
    final path = await _dicrectoryPath;
    return File('$path/tempData.json');
  }

  Future<File> get _jsonFile async {
    final path = await _dicrectoryPath;
    return File('$path/whss.json');
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

  Future<Object> readJsonFile() async {
    String fileContent = '';

    // File file = await _jsonFile;
    File file = await _readJobs;
    print(file);

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return List<Map<String, dynamic>>.from(json.decode(fileContent));
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

  //read asset file json
  Future<Object> readJob() async {
    String fileContent = '';

    File file = await _jsonFile;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return List<Map<String, dynamic>>.from(json.decode(fileContent));
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await file.create(recursive: true);
        await file.writeAsString(fileContent);
      } catch (e) {
        print(e);
      }
    }

    return {};
  }

  // write file Job to tempData.json
  Future<void> writeJob(Map<String, dynamic> newData) async {
    File file = await _readJobs;
    // no file create new file
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }

    String fileContent = await file.readAsString();

    List<Map<String, dynamic>> jsonList =
        List<Map<String, dynamic>>.from(json.decode(fileContent));

    jsonList.add(newData);

    String jsonStr = json.encode(jsonList);

    await file.writeAsString(jsonStr);
  }

  Future<Object> readDmg() async {
    String fileContent = '';

    final jsonFile = await rootBundle.loadString('assets/data/dmg_code.json');

    if (jsonFile.isNotEmpty) {
      try {
        fileContent = jsonFile;
        return List<Map<String, dynamic>>.from(json.decode(fileContent));
      } catch (e) {
        print(e);
      }
    }

    return {};
  }

  Future<Object> readStrcLoct() async {
    String fileContent = '';

    final jsonFile = await rootBundle.loadString('assets/data/strc_loct.json');

    if (jsonFile.isNotEmpty) {
      try {
        fileContent = jsonFile;
        return List<Map<String, dynamic>>.from(json.decode(fileContent));
      } catch (e) {
        print(e);
      }
    }

    return {};
  }
}
