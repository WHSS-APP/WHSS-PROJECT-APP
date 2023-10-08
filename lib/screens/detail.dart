import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_whss_app/controller/file_controller.dart';
import 'package:project_whss_app/file_manager.dart';
import 'package:project_whss_app/screens/equipment_check.dart';
import 'package:project_whss_app/screens/equipment_inspection_record.dart';

class Detail extends StatefulWidget {
  const Detail({
    super.key,
    this.strcValue,
    this.loctValue,
    this.damgValue,
    this.codeValue,
    this.keyValue,
    this.descriptionValue,
    this.blockValue,
    this.levelValue,
    this.directionValue,
    this.statusValue,
    this.picturePathValue,
  });
  final String? strcValue;
  final String? loctValue;
  final String? damgValue;
  final String? codeValue;
  final String? keyValue;
  final String? descriptionValue;
  final String? blockValue;
  final String? levelValue;
  final String? directionValue;
  final String? statusValue;
  final String? picturePathValue;
  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  File? _selectedImage;
  String? _itemName;
  String? _filePath;
  String selectBLK = '';
  String selectLVL = '';
  String LVL = '';
  String BLK = '';
  String selectDirection = '';
  String statusValue = '';
  // String selectWarning = '';
  // String selectRepair = '';
  // String selectSupplement = '';
  // String selectChange = '';
  String checkSTRC = '';
  String checkLOCT = '';
  String checkDAMG = '';
  String checkCODE = '';
  String checkDescription = '';

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text(
            "ลบข้อมูล",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          content: Text("ต้องการลบข้อมูลหรือไม่?"),
          actions: [
            TextButton(
              child: Text("ยกเลิก"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("ลบข้อมูล"),
              onPressed: () async {
                // call file controller to delete file
                FileManager fileManager = FileManager();

                await fileManager.deleteJob(widget.keyValue!);
                // delete img file
                // delete img in image
                final appDocumentsDir = await getExternalStorageDirectory();
                final imagesDir = Directory('${appDocumentsDir?.path}/Images');
                final updateImageDir = Directory(
                    '${appDocumentsDir?.path}/recheckImage'); //recheckImage

                if (!imagesDir.existsSync()) {
                  imagesDir.createSync(recursive: true);
                }

                final newImagePath = '${imagesDir.path}/${widget.keyValue}.png';
                final moveImagePath =
                    '${updateImageDir.path}/${_itemName}_delete.png';

                if (File(newImagePath).existsSync()) {
                  File(newImagePath).renameSync(moveImagePath);
                }

                Map<String, dynamic> recheckData = {
                  "itemName": "${widget.keyValue}_delete",
                  "location": {
                    "strc": widget.strcValue,
                    "loct": widget.loctValue
                  },
                  "damage": {
                    "damge": widget.damgValue,
                    "code": widget.codeValue,
                    "description": widget
                        .descriptionValue, // selectDesscriptionFrom DMG Code
                  },
                  "level": widget.levelValue, // LVL
                  "block": widget.blockValue, //BLOCK
                  "direction": widget.directionValue,
                  "status": widget.statusValue,
                  "picturePath": widget.picturePathValue,
                };

                await fileManager.recheckJob(recheckData);

                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EquipmentInspectionRecord(),
                  ),
                  (route) => false,
                );
                showDeleteSuccessDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return AlertDialog(
          title: Text("ลบข้อมูลสำเร็จ"),
          content: Text("ข้อมูลของคุณถูกลบแล้ว"),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _itemName = widget.keyValue ?? '';
    checkSTRC = widget.strcValue ?? '';
    checkLOCT = widget.loctValue ?? '';
    checkDAMG = widget.damgValue ?? '';
    checkCODE = widget.codeValue ?? '';
    checkDescription = widget.descriptionValue ?? '';
    selectBLK = widget.blockValue ?? '';
    selectLVL = widget.levelValue ?? '';
    selectDirection = widget.directionValue ?? '';
    // selectWarning = widget.statusValue ?? '';
    // selectRepair = widget.statusValue ?? '';
    // selectSupplement = widget.statusValue ?? '';
    // selectChange = widget.statusValue ?? '';
    statusValue = widget.statusValue ?? '';
    _filePath = widget.picturePathValue ?? '';
    if (_filePath != '' && _filePath != null) {
      _selectedImage = File(_filePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenFontSize = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Detail",
          style: TextStyle(
            fontSize: screenFontSize >= 480
                ? 18
                : screenFontSize >= 320
                    ? 12
                    : 10,
          ),
        ),
        backgroundColor: Color(0xFF151D28),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
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
            height: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(21, 29, 40, 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: screenWidth >= 480
                    ? screenWidth / 1.4
                    : screenWidth >= 320
                        ? screenWidth / 1.3
                        : screenWidth / 1.2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ภาพที่",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 153, 0, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: screenFontSize >= 480
                              ? screenFontSize * 0.035
                              : screenFontSize >= 320
                                  ? screenFontSize * 0.03
                                  : screenFontSize * 0.028,
                        ),
                      ),
                      Text(
                        _itemName!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenFontSize >= 480
                              ? screenFontSize * 0.035
                              : screenFontSize >= 320
                                  ? screenFontSize * 0.03
                                  : screenFontSize * 0.028,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: screenWidth >= 480
                    ? screenWidth / 1.4
                    : screenWidth >= 320
                        ? screenWidth / 1.3
                        : screenWidth / 1.2,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(21, 29, 40, 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ตำแหน่ง",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenFontSize >= 480
                                  ? screenFontSize * 0.035
                                  : screenFontSize >= 320
                                      ? screenFontSize * 0.03
                                      : screenFontSize * 0.028,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                checkSTRC,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                              Text(
                                checkLOCT,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ชั้นที่",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenFontSize >= 480
                                  ? screenFontSize * 0.035
                                  : screenFontSize >= 320
                                      ? screenFontSize * 0.03
                                      : screenFontSize * 0.028,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                selectLVL,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                              Text(
                                " ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                              Text(
                                "(BLK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                              Text(
                                selectBLK,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                              Text(
                                ",DRT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                              Text(
                                selectDirection,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                              Text(
                                ")",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenFontSize >= 480
                                      ? screenFontSize * 0.035
                                      : screenFontSize >= 320
                                          ? screenFontSize * 0.03
                                          : screenFontSize * 0.028,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ความเสียหาย",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenFontSize >= 480
                                  ? screenFontSize * 0.035
                                  : screenFontSize >= 320
                                      ? screenFontSize * 0.03
                                      : screenFontSize * 0.028,
                            ),
                          ),
                          Text(
                            checkDAMG + checkCODE,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenFontSize >= 480
                                  ? screenFontSize * 0.035
                                  : screenFontSize >= 320
                                      ? screenFontSize * 0.03
                                      : screenFontSize * 0.028,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "การแก้ไข",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenFontSize >= 480
                                  ? screenFontSize * 0.035
                                  : screenFontSize >= 320
                                      ? screenFontSize * 0.03
                                      : screenFontSize * 0.028,
                            ),
                          ),
                          Text(
                            // ignore: prefer_if_null_operators, unnecessary_null_comparison
                            statusValue != null ? statusValue : "-",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenFontSize >= 480
                                  ? screenFontSize * 0.035
                                  : screenFontSize >= 320
                                      ? screenFontSize * 0.03
                                      : screenFontSize * 0.028,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth >= 480
                    ? screenWidth / 1.9
                    : screenWidth >= 320
                        ? screenWidth / 1.32
                        : screenWidth / 1.4,
                height: screenHeight >= 1000
                    ? screenHeight / 20
                    : screenHeight >= 679
                        ? screenHeight / 18
                        : screenHeight / 18,
                child: MaterialButton(
                  color: Color.fromRGBO(113, 105, 97, 1),
                  child: const Text(
                    "แก้ไข",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EquipmentCheck(
                          keyValue: _itemName,
                          strcValue: checkSTRC,
                          loctValue: checkLOCT,
                          damgValue: checkDAMG,
                          codeValue: checkCODE,
                          descriptionValue: checkDescription,
                          blockValue: selectBLK,
                          levelValue: selectLVL,
                          directionValue: selectDirection,
                          statusValue: statusValue,
                          picturePathValue: _filePath,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth >= 480
                    ? screenWidth / 1.9
                    : screenWidth >= 320
                        ? screenWidth / 1.32
                        : screenWidth / 1.4,
                height: screenHeight >= 1000
                    ? screenHeight / 20
                    : screenHeight >= 679
                        ? screenHeight / 18
                        : screenHeight / 18,
                child: MaterialButton(
                  color: Color.fromRGBO(239, 76, 66, 1),
                  child: const Text(
                    "ลบ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    DateTime now = DateTime.now();
                    String formattedDate =
                        DateFormat('yyyyMMddHHmmss').format(now);
                    showDeleteConfirmationDialog(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
