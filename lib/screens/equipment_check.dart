import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_whss_app/controller/file_controller.dart';
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
  late List<DamgeAsset> damgeCode = context.read<FileController>().damage;
  late List<LocationAsset> strcLoctCode =
      context.read<FileController>().strcLoct;

  Color buttonWarning = Color.fromRGBO(176, 34, 42, 1);
  Color buttonRepair = Color.fromRGBO(214, 129, 29, 1);
  Color buttonSupplement = Color.fromRGBO(55, 167, 93, 1);
  Color buttonChange = Color.fromRGBO(89, 96, 91, 1);

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
        _selectedImage = File(newImagePath);
        _itemName = 'K$formattedDate';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenFontSize = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print(
        "---------------------------screenWidth-----------------------------");
    print(screenWidth);
    print(
        "---------------------------screenHeight-----------------------------");
    print(screenHeight);

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
                                : screenHeight / 28,
                            () {},
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
                                : screenHeight / 28,
                            () {},
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
                                : screenHeight / 28,
                            () {},
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
                                : screenHeight / 28,
                            () {},
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
                                : screenHeight / 28,
                            () {},
                            "4",
                            Color.fromRGBO(89, 96, 91, 1),
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
                                : screenHeight / 28,
                            () {},
                            "4",
                            Color.fromRGBO(146, 136, 125, 1),
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
                            "A",
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
                            "3",
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
                            "F",
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
                            "D",
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
                                : screenHeight / 28,
                            () {},
                            "3",
                            Color.fromRGBO(89, 96, 91, 1),
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
                                : screenHeight / 28,
                            () {},
                            "3",
                            Color.fromRGBO(146, 136, 125, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "2",
                                    Color.fromRGBO(89, 96, 91, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "2",
                                    Color.fromRGBO(146, 136, 125, 1),
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
                                    "7",
                                    Color.fromRGBO(3, 98, 166, 1),
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
                                    "8",
                                    Color.fromRGBO(249, 152, 36, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "9",
                                    Color.fromRGBO(3, 98, 166, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "1",
                                    Color.fromRGBO(89, 96, 91, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "1",
                                    Color.fromRGBO(146, 136, 125, 1),
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
                                    "4",
                                    Color.fromRGBO(4, 192, 240, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "5",
                                    Color.fromRGBO(218, 24, 116, 1),
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
                                    "6",
                                    Color.fromRGBO(4, 192, 240, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "T",
                                    Color.fromRGBO(89, 96, 91, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "T",
                                    Color.fromRGBO(146, 136, 125, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "1",
                                    Color.fromRGBO(3, 98, 166, 1),
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
                                    "2",
                                    Color.fromRGBO(249, 152, 36, 1),
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
                                        : screenHeight / 28,
                                    () {},
                                    "3",
                                    Color.fromRGBO(3, 98, 166, 1),
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
                                () {},
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
