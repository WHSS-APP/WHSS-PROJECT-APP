// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_whss_app/controller/file_controller.dart';
import 'package:project_whss_app/file_manager.dart';
import 'package:project_whss_app/model/job.dart';
import 'package:project_whss_app/model/dmg.dart';
import 'package:project_whss_app/model/location.dart';
import 'package:project_whss_app/screens/equipment_inspection_record.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EquipmentCheck extends StatefulWidget {
  const EquipmentCheck({Key? key});

  @override
  State<EquipmentCheck> createState() => _EquipmentCheckState();
}

class _EquipmentCheckState extends State<EquipmentCheck> {
  File? _selectedImage;
  String? _itemName;
  String? _filePath;
  late List<DamgeAsset> damageCode = context.read<FileController>().damage;
  late List<LocationAsset> strcLoctCode =
      context.read<FileController>().strcLoct;

  Widget _buildButton(double width, double height, VoidCallback onPressed,
      String label, Color backgroundColor, double fontsize, Color fontColor) {
    return Container(
      width: width, // กำหนดความกว้างของ Container ที่คุณต้องการ
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          fixedSize: Size(width, height),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontsize,
              color: fontColor),
        ),
      ),
    );
  }

  Color buttonWarning = Color.fromRGBO(176, 34, 42, 1);
  Color buttonRepair = Color.fromRGBO(214, 129, 29, 1);
  Color buttonSupplement = Color.fromRGBO(55, 167, 93, 1);
  Color buttonChange = Color.fromRGBO(89, 96, 91, 1);

  void _changeButtonColor(
    Color warningColor,
    Color repairColor,
    Color supplementColor,
    Color changeColor,
  ) {
    setState(() {
      buttonWarning = warningColor;
      buttonRepair = repairColor;
      buttonSupplement = supplementColor;
      buttonChange = changeColor;
    });
  }

  Color BLKbtn1 = Color.fromRGBO(89, 96, 91, 1);
  Color BLKbtn2 = Color.fromRGBO(89, 96, 91, 1);
  Color BLKbtn3 = Color.fromRGBO(89, 96, 91, 1);
  Color BLKbtn4 = Color.fromRGBO(89, 96, 91, 1);
  Color BLKbtnAdd = Color.fromRGBO(89, 96, 91, 1);

  void _changeButtonBLKColor(
      Color btn1, Color btn2, Color btn3, Color btn4, Color btnAdd) {
    setState(() {
      BLKbtn1 = btn1;
      BLKbtn2 = btn2;
      BLKbtn3 = btn3;
      BLKbtn4 = btn4;
      BLKbtnAdd = btnAdd;
    });
  }

  Color LVLbtn1 = Color.fromRGBO(146, 136, 125, 1);
  Color LVLbtn2 = Color.fromRGBO(146, 136, 125, 1);
  Color LVLbtn3 = Color.fromRGBO(146, 136, 125, 1);
  Color LVLbtn4 = Color.fromRGBO(146, 136, 125, 1);
  Color LVLbtnAdd = Color.fromRGBO(146, 136, 125, 1);

  void _changeButtonLVLColor(
      Color btn1, Color btn2, Color btn3, Color btn4, Color btnAdd) {
    setState(() {
      LVLbtn1 = btn1;
      LVLbtn2 = btn2;
      LVLbtn3 = btn3;
      LVLbtn4 = btn4;
      LVLbtnAdd = btnAdd;
    });
  }

  Color Numbtn1 = Color.fromRGBO(3, 98, 166, 1);
  Color Numbtn2 = Color.fromRGBO(249, 152, 36, 1);
  Color Numbtn3 = Color.fromRGBO(3, 98, 166, 1);
  Color Numbtn4 = Color.fromRGBO(4, 192, 240, 1);
  Color Numbtn5 = Color.fromRGBO(218, 24, 116, 1);
  Color Numbtn6 = Color.fromRGBO(4, 192, 240, 1);
  Color Numbtn7 = Color.fromRGBO(3, 98, 166, 1);
  Color Numbtn8 = Color.fromRGBO(249, 152, 36, 1);
  Color Numbtn9 = Color.fromRGBO(3, 98, 166, 1);

  void _changeButtonNumColor(
    Color btn1,
    Color btn2,
    Color btn3,
    Color btn4,
    Color btn5,
    Color btn6,
    Color btn7,
    Color btn8,
    Color btn9,
  ) {
    setState(() {
      Numbtn1 = btn1;
      Numbtn2 = btn2;
      Numbtn3 = btn3;
      Numbtn4 = btn4;
      Numbtn5 = btn5;
      Numbtn6 = btn6;
      Numbtn7 = btn7;
      Numbtn8 = btn8;
      Numbtn9 = btn9;
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);

    final originalImage =
        img.decodeImage(File(returnedImage.path).readAsBytesSync());
    if (originalImage != null) {
      final appDocumentsDir = await getExternalStorageDirectory();
      final imagesDir = Directory('${appDocumentsDir?.path}/Images');

      if (!imagesDir.existsSync()) {
        imagesDir.createSync(recursive: true);
      }

      final newImagePath = '${imagesDir.path}/K$formattedDate.png';
      final resizedImage =
          img.copyResize(originalImage, width: 400, height: 400);
      File(newImagePath).writeAsBytesSync(img.encodePng(resizedImage));

      setState(() {
        _filePath = newImagePath;
        _selectedImage = File(newImagePath);
        _itemName = 'K$formattedDate';
      });
    }
  }

  String selectedSTRC = '';
  String selectedLOCT = '';
  String selectedDAMG = '';
  String selectedCODE = '';

  List<String> optionsSTRC = [];
  List<String> optionsLOCT = [];
  List<String> optionsDAMG = [];
  List<String> optionsCODE = [];


  @override
  void initState() {
    super.initState();
    optionsSTRC = strcLoctCode.map((e) => e.strc!).toList();
    // map all strcLoctCode only Loct

    // select only strc = 'B'
    optionsLOCT = strcLoctCode.where((e) => e.strc == 'B').map((e) => e.loct!).expand((x) => x).toList();


    // optionsLOCT = strcLoctCode.map((e) => e.loct!).toList();
    optionsDAMG = damageCode.map((e) => e.damge!).toList();

    // select only damage = 'F' and show id code
    optionsCODE = damageCode
      .where((e) => e.damge == 'A')
      .map((e) => e.code!)
      .toList()
      .expand((x) => x)
      .map((e) => e.id!)
      .toList();

    // optionsCODE = damageCode.map((e) => e.code!).toList();
  }
  

  // final List<String> optionsLOCT = ['1', '2', '3', '4'];
  // final List<String> optionsDAMG = ['F', 'U', 'B'];
  // final List<String> optionsCODE = ['D', 'A', 'N', 'C'];

  @override
  Widget build(BuildContext context) {
    context.read<FileController>().readStrLoct();
    context.read<FileController>().readDmg();

    print(optionsSTRC);

    double screenFontSize = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print(
        "---------------------------screenWidth-----------------------------");
    print(screenWidth);
    print(
        "---------------------------screenHeight-----------------------------");
    print(screenHeight);
    print(optionsSTRC.length);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Equipment Check"),
        backgroundColor: Color(0xFF151D28),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EquipmentInspectionRecord(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight >= 1000
                  ? screenHeight * 0.04
                  : screenHeight * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.35,
                        fit: BoxFit.contain,
                      )
                    : const Text("No picture"),
                SizedBox(
                    height: screenHeight >= 1000
                        ? screenHeight / 3
                        : screenHeight / 3),
              ],
            ),
            SizedBox(
              height: screenHeight >= 1000
                  ? screenHeight * 0.04
                  : screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth >= 480
                              ? screenWidth / 1.8
                              : screenWidth / 1.8,
                          height: screenHeight >= 1000
                              ? screenHeight / 20
                              : screenHeight / 18,
                          child: MaterialButton(
                            color: Color.fromRGBO(214, 129, 29, 1),
                            child: const Text(
                              "Take Photo",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              _pickImageFromCamera();
                            },
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        SizedBox(
                            width: screenWidth >= 480
                                ? screenWidth / 3.4
                                : screenWidth / 3.5,
                            height: screenHeight >= 1000
                                ? screenHeight / 20
                                : screenHeight / 18,
                            child: MaterialButton(
                              color: Color.fromRGBO(146, 136, 125, 1),
                              child: const Text(
                                "Refresh",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                            )),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 8
                                : screenWidth / 8,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28,
                            () {},
                            "BLK",
                            Color.fromRGBO(89, 96, 91, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 8
                                : screenWidth / 8,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28,
                            () {},
                            "LVL",
                            Color.fromRGBO(146, 136, 125, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('STRC'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: optionsSTRC.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(optionsSTRC[index]),
                                        onTap: () {
                                          setState(() {
                                            selectedSTRC = optionsSTRC[index];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                            "STRC",
                            Color.fromRGBO(176, 34, 42, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('LOCT'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: optionsLOCT.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(optionsLOCT[index]),
                                        onTap: () {
                                          setState(() {
                                            selectedLOCT = optionsLOCT[index];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                            "LOCT",
                            Color.fromRGBO(249, 152, 36, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 6.7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('DAMG'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: optionsDAMG.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(optionsDAMG[index]),
                                        onTap: () {
                                          setState(() {
                                            selectedDAMG = optionsDAMG[index];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                            "DAMG",
                            Color.fromRGBO(55, 167, 93, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('CODE'),
                                content: Container(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: optionsCODE.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(optionsCODE[index]),
                                        onTap: () {
                                          setState(() {
                                            selectedCODE = optionsCODE[index];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                            "CODE",
                            Color.fromRGBO(89, 96, 91, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight >= 1000
                          ? screenHeight * 0.005
                          : screenHeight * 0.00010,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 8
                                : screenWidth / 8,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          _changeButtonBLKColor(
                            Color.fromRGBO(187, 189, 188, 1),
                            Color.fromRGBO(187, 189, 188, 1),
                            Color.fromRGBO(187, 189, 188, 1),
                            Color.fromRGBO(89, 96, 91, 1),
                            Color.fromRGBO(187, 189, 188, 1),
                          );
                        },
                            "4",
                            BLKbtn4,
                            screenFontSize >= 480
                                ? screenFontSize * 0.03
                                : screenFontSize * 0.03,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 8
                                : screenWidth / 8,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          _changeButtonLVLColor(
                            Color.fromRGBO(204, 191, 178, 1),
                            Color.fromRGBO(204, 191, 178, 1),
                            Color.fromRGBO(204, 191, 178, 1),
                            Color.fromRGBO(146, 136, 125, 1),
                            Color.fromRGBO(204, 191, 178, 1),
                          );
                        },
                            "4",
                            LVLbtn4,
                            screenFontSize >= 480
                                ? screenFontSize * 0.03
                                : screenFontSize * 0.03,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28,
                            () {},
                            selectedSTRC,
                            // '${selectedSTRC != null ? selectedSTRC : "ไม่มี"}',
                            Color.fromRGBO(176, 34, 42, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.03
                                : screenFontSize * 0.03,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28,
                            () {},
                            selectedLOCT,
                            Color.fromRGBO(249, 152, 36, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.03
                                : screenFontSize * 0.03,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28,
                            () {},
                            selectedDAMG,
                            Color.fromRGBO(55, 167, 93, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.03
                                : screenFontSize * 0.03,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28,
                            () {},
                            selectedCODE,
                            Color.fromRGBO(89, 96, 91, 1),
                            screenFontSize >= 480
                                ? screenFontSize * 0.03
                                : screenFontSize * 0.03,
                            Colors.white),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight >= 1000
                          ? screenHeight * 0.005
                          : screenHeight * 0.00010,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 8
                                : screenWidth / 8,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          _changeButtonBLKColor(
                            Color.fromRGBO(187, 189, 188, 1),
                            Color.fromRGBO(187, 189, 188, 1),
                            Color.fromRGBO(89, 96, 91, 1),
                            Color.fromRGBO(187, 189, 188, 1),
                            Color.fromRGBO(187, 189, 188, 1),
                          );
                        },
                            "3",
                            BLKbtn3,
                            screenFontSize >= 480
                                ? screenFontSize * 0.03
                                : screenFontSize * 0.03,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 8
                                : screenWidth / 8,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          _changeButtonLVLColor(
                            Color.fromRGBO(204, 191, 178, 1),
                            Color.fromRGBO(204, 191, 178, 1),
                            Color.fromRGBO(146, 136, 125, 1),
                            Color.fromRGBO(204, 191, 178, 1),
                            Color.fromRGBO(204, 191, 178, 1),
                          );
                        },
                            "3",
                            LVLbtn3,
                            screenFontSize >= 480
                                ? screenFontSize * 0.03
                                : screenFontSize * 0.03,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          _changeButtonColor(
                            Color.fromRGBO(176, 34, 42, 1),
                            Color.fromRGBO(221, 200, 177, 1),
                            Color.fromRGBO(168, 217, 184, 1),
                            Color.fromRGBO(167, 171, 168, 1),
                          );
                        },
                            "เตือน",
                            buttonWarning,
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          _changeButtonColor(
                            Color.fromRGBO(238, 167, 171, 1),
                            Color.fromRGBO(214, 129, 29, 1),
                            Color.fromRGBO(168, 217, 184, 1),
                            Color.fromRGBO(167, 171, 168, 1),
                          );
                        },
                            "ซ่อม",
                            buttonRepair,
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          _changeButtonColor(
                            Color.fromRGBO(238, 167, 171, 1),
                            Color.fromRGBO(221, 200, 177, 1),
                            Color.fromRGBO(55, 167, 93, 1),
                            Color.fromRGBO(167, 171, 168, 1),
                          );
                        },
                            "เสริม",
                            buttonSupplement,
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                        SizedBox(width: screenWidth * 0.008),
                        _buildButton(
                            screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 6.6,
                            screenHeight >= 1000
                                ? screenHeight / 22
                                : screenHeight / 28, () {
                          _changeButtonColor(
                            Color.fromRGBO(238, 167, 171, 1),
                            Color.fromRGBO(221, 200, 177, 1),
                            Color.fromRGBO(168, 217, 184, 1),
                            Color.fromRGBO(89, 96, 91, 1),
                          );
                        },
                            "เปลี่ยน",
                            buttonChange,
                            screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.023,
                            Colors.white),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight >= 1000
                          ? screenHeight * 0.005
                          : screenHeight * 0.00010,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 8
                                        : screenWidth / 8,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonBLKColor(
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(89, 96, 91, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                  );
                                },
                                    "2",
                                    BLKbtn2,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 8
                                        : screenWidth / 8,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonLVLColor(
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(146, 136, 125, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                  );
                                },
                                    "2",
                                    LVLbtn2,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(255, 216, 234, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(3, 98, 166, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                  );
                                },
                                    "7",
                                    Numbtn7,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(255, 216, 234, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(249, 152, 36, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                  );
                                },
                                    "8",
                                    Numbtn8,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.black),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(255, 216, 234, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(3, 98, 166, 1),
                                  );
                                },
                                    "9",
                                    Numbtn9,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight >= 1000
                                  ? screenHeight * 0.005
                                  : screenHeight * 0.00010,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 8
                                        : screenWidth / 8,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonBLKColor(
                                    Color.fromRGBO(89, 96, 91, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                  );
                                },
                                    "1",
                                    BLKbtn1,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 8
                                        : screenWidth / 8,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonLVLColor(
                                    Color.fromRGBO(146, 136, 125, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                  );
                                },
                                    "1",
                                    LVLbtn1,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(4, 192, 240, 1),
                                    Color.fromRGBO(255, 216, 234, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                  );
                                },
                                    "4",
                                    Numbtn4,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.black),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(218, 24, 116, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                  );
                                },
                                    "5",
                                    Numbtn5,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(255, 216, 234, 1),
                                    Color.fromRGBO(4, 192, 240, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                  );
                                },
                                    "6",
                                    Numbtn6,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.black),
                                SizedBox(width: screenWidth * 0.01),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight >= 1000
                                  ? screenHeight * 0.005
                                  : screenHeight * 0.00010,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 8
                                        : screenWidth / 8,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonBLKColor(
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(187, 189, 188, 1),
                                    Color.fromRGBO(89, 96, 91, 1),
                                  );
                                },
                                    "T",
                                    BLKbtnAdd,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 8
                                        : screenWidth / 8,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonLVLColor(
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(204, 191, 178, 1),
                                    Color.fromRGBO(146, 136, 125, 1),
                                  );
                                },
                                    "T",
                                    LVLbtnAdd,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.023,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(3, 98, 166, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(255, 216, 234, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                  );
                                },
                                    "1",
                                    Numbtn1,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(249, 152, 36, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(255, 216, 234, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                  );
                                },
                                    "2",
                                    Numbtn2,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.black),
                                SizedBox(width: screenWidth * 0.01),
                                _buildButton(
                                    screenWidth >= 480
                                        ? screenWidth / 7
                                        : screenWidth / 7,
                                    screenHeight >= 1000
                                        ? screenHeight / 22
                                        : screenHeight / 28, () {
                                  _changeButtonNumColor(
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(3, 98, 166, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(255, 216, 234, 1),
                                    Color.fromRGBO(224, 242, 246, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                    Color.fromRGBO(245, 230, 211, 1),
                                    Color.fromRGBO(218, 234, 246, 1),
                                  );
                                },
                                    "3",
                                    Numbtn3,
                                    screenFontSize >= 480
                                        ? screenFontSize * 0.03
                                        : screenFontSize * 0.03,
                                    Colors.white),
                                SizedBox(width: screenWidth * 0.01),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.001),
                        Column(
                            children: [
                            _buildButton(
                              screenWidth >= 480
                                ? screenWidth / 7
                                : screenWidth / 7,
                              screenHeight >= 1000
                                ? screenHeight / 6.6
                                : screenHeight / 6,
                              () async {
                                // Add your onPressed function here
                                // Map<String, dynamic> newData = {
                                //   "itemName" : _itemName ?? "",
                                //   "location" : {"strc": selectedSTRC ?? '', "loct": selectedLOCT ?? ''},
                                //   "damage" : {
                                //     "damage" : selectedDAMG ?? '',
                                //     "code" : selectedCODE ?? '',
                                //     "description" : "", // selectDesscriptionFrom DMG Code
                                //   },
                                //   "level" : "", // LVL
                                //   "block" : "", //BLOCK
                                //   "direction" : "",
                                //   "status" : "", // สถานะ
                                //   "picturePath" : _filePath ?? "",
                                // };

                                Map<String, dynamic> newData  = {
                                  "itemName" : "HELLO",
                                  "location" : {"strc": '1', "loct":  '2'},
                                  "damage" : {
                                    "damge" : 'G',
                                    "code" : 'E',
                                    "description" : "F", // selectDesscriptionFrom DMG Code
                                  },
                                  "level" : "1", // LVL
                                  "block" : "B", //BLOCK
                                  "direction" : "4",
                                  "status" : "Repair", // สถานะ
                                  "picturePath" : "/new_img",
                                };
              
                                FileManager fileManager = FileManager();
                                await fileManager.writeData(newData);
                              },
                              "SAVE",
                              Color.fromRGBO(249, 152, 36, 1),
                              screenFontSize >= 480
                                ? screenFontSize * 0.025
                                : screenFontSize * 0.024,
                              Colors.white),
                            ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
