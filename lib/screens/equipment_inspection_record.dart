import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_whss_app/controller/file_controller.dart';
import 'package:project_whss_app/model/job.dart';
import 'package:project_whss_app/screens/equipment_check.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EquipmentInspectionRecord extends StatefulWidget {
  const EquipmentInspectionRecord({Key? key});

  @override
  State<EquipmentInspectionRecord> createState() =>
      _EquipmentInspectionRecordState();
}

class _EquipmentInspectionRecordState extends State<EquipmentInspectionRecord> {
  late List<Job> filteredData = [];
  // ignore: non_constant_identifier_names
  late List<Job> result_data = context.read<FileController>().job!;
  Future<void> refreshData() async {
    setState(() {
      filteredData = result_data.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    filteredData = result_data.toList();
    refreshData();
  }

  void requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      await Permission.storage.request();

    }

    var statusCamera = await Permission.camera.status;
    if (statusCamera.isGranted) {
      await Permission.camera.request();
    }

    var statusManageExternalStorage = await Permission.manageExternalStorage.status;
    if (statusManageExternalStorage.isGranted) {
      await Permission.manageExternalStorage.request();
    }

  }

  // Example function to request external storage permission
  Future<void> requestExternalStoragePermission() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      print("Permission granted");
      // Permission granted, you can now access external storage.
      // You can perform file I/O operations here.
    } else if (status.isDenied) {
      // Permission denied.
      // You might want to inform the user and provide guidance on how to enable the permission.
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied.
      // You might want to open the app settings to allow the user to enable the permission manually.
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    requestExternalStoragePermission();
    context.read<FileController>().readJobs();
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Equipment Inspection Record"),
        backgroundColor: Color(0xFF151D28),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EquipmentCheck(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFffffff),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0,
                        spreadRadius: 5.0,
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                      decoration: InputDecoration(
                        hintText: '',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText:
                            'ค้นหาด้วย เลขภาพ, ตำแหน่ง, ความเสียหาย, การแก้ไข...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: (query) {
                        setState(() {
                          filteredData = result_data
                              .where((item) =>
                                  item.itemName.contains(query) ||
                                  (item.location.strc + item.location.loct)
                                      .contains(query) ||
                                  (item.location.loct.contains(query)) ||
                                  (item.status.contains(query)) ||
                                  (item.damage.damge.contains(query)) ||
                                  (item.damage.code.contains(query)))
                              .toList();
                        });
                      }),
                ),
                SizedBox(height: 10),
                Column(
                  children: filteredData.map((data) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFffffff),
                          border: Border.all(
                            color: Color.fromARGB(255, 185, 185, 185),
                            width: 0.85,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 219, 219, 219),
                              blurRadius: 15.0,
                              spreadRadius: 5.0,
                              offset: Offset(
                                5.0,
                                5.0,
                              ),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EquipmentCheck(
                                    keyValue: data.itemName,
                                    strcValue: data.location.strc,
                                    loctValue: data.location.loct,
                                    damgValue: data.damage.damge,
                                    codeValue: data.damage.code,
                                    descriptionValue: data.damage.description,
                                    blockValue: data.block,
                                    levelValue: data.level,
                                    directionValue: data.direction,
                                    statusValue: data.status,
                                    picturePathValue: data.picturePath,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    // call file from data.pathPicture
                                    data.picturePath != ''
                                        ? Image.file(
                                            File(data.picturePath),
                                            width: 130,
                                            height: 130,
                                          )
                                        : Container(
                                            width: 130,
                                            height: 130,
                                            color: Colors.grey,
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(21, 29, 40, 1),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      width: MediaQuery.of(context).size.width -
                                          190,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "ภาพที่",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 153, 0, 1),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              data.itemName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          190,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(21, 29, 40, 1),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "ตำแหน่ง",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      data.location.strc,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.location.loct,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "ชั้นที่",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      data.level,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      "(BLK",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.block,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      ",DRT",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.direction,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      ")",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "ความเสียหาย",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  data.damage.damge +
                                                      data.damage.code,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "การแก้ไข",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                                  data.status != null
                                                      ? data.status
                                                      : "-",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
