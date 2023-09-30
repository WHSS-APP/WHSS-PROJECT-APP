import 'package:flutter/material.dart';
import 'package:project_whss_app/controller/file_controller.dart';
import 'package:project_whss_app/screens/equipment_check.dart';
import 'package:provider/provider.dart';


class EquipmentInspectionRecord extends StatefulWidget {
  const EquipmentInspectionRecord({Key? key});


//   @override
//   State<EquipmentInspectionRecord> createState() =>
//       _EquipmentInspectionRecordState();
// }

class EquipmentInspectionRecord extends StatelessWidget {
  const EquipmentInspectionRecord({Key? key}) : super(key: key);

class ItemData {
  final String itemName;
  final Map location;
  final Map damge;
  final String level;
  final String block;
  final String direction;
  final String status;
  ItemData(this.itemName, this.location, this.damge, this.level, this.block,
      this.direction, this.status);

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(json['itemName'], json['location'], json['damge'],
        json['level'], json['block'], json['direction'], json['status']);
  }
}

class _EquipmentInspectionRecordState extends State<EquipmentInspectionRecord> {
  List<ItemData> filteredData = [];
  List<ItemData> result_data = [
    {
      "itemName": "K201600",
      "location": {"strc": "A", "loct": "1"},
      "damge": {"damge": "F", "code": "D", "description": "เป็นสนิม"},
      "level": "0",
      "block": "1",
      "direction": "9",
      "status": "ซ่อม",
      "picturePath": "/"
    },
    {
      "itemName": "K201600",
      "location": {"strc": "B", "loct": "2"},
      "damge": {"damge": "", "code": "", "description": ""},
      "level": "",
      "block": "1",
      "direction": "9",
      "status": "",
      "picturePath": "/"
    },
    {
      "itemName": "K201600",
      "location": {"strc": "", "loct": ""},
      "damge": {"damge": "", "code": ""},
      "level": "",
      "block": "1",
      "direction": "2",
      "status": "",
      "picturePath": "/"
    },
    {
      "itemName": "K201600",
      "location": {"strc": "", "loct": ""},
      "damge": {"damge": "", "code": "", "description": ""},
      "level": "",
      "block": "1",
      "direction": "",
      "status": "",
      "picturePath": "/"
    }
  ].map((item) => ItemData.fromJson(item)).toList();

  @override
  void initState() {
    super.initState();
    filteredData = result_data.toList();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch job data from FileController
    context.read<FileController>().readJobs();
    // context.read<FileController>().readDmg();
    // print(context.watch<FileController>().job?.length);
    // print(context.watch<FileController>().job?[1].location.loct);

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
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFffffff),
                  boxShadow: [
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
                              (item.location["strc"] != null &&
                                  item.location["strc"].contains(query)) ||
                              (item.location["loct"] != null &&
                                  item.location["loct"].contains(query)) ||
                              (item.status != null &&
                                  item.status.contains(query)) ||
                              (item.damge["description"] != null &&
                                  item.damge["description"].contains(query)))
                          .toList();
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: filteredData.map((data) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFffffff),
                        boxShadow: [
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
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Image.network(
                                  'https://picsum.photos/250?image=9',
                                  width: 130,
                                  height: 130,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
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
                                  width:
                                      MediaQuery.of(context).size.width - 180,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ภาพที่",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(255, 153, 0, 1),
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
                                  width:
                                      MediaQuery.of(context).size.width - 180,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(21, 29, 40, 1),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  data.location != null &&
                                                          data.location[
                                                                  "strc"] !=
                                                              null
                                                      ? data.location["strc"]
                                                      : "-",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  data.location != null &&
                                                          data.location[
                                                                  "loct"] !=
                                                              null
                                                      ? data.location["loct"]
                                                      : "-",
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
                                              MainAxisAlignment.spaceBetween,
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
                                                  data.level != null
                                                      ? data.level
                                                      : "-",
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
                                                  data.block != null
                                                      ? data.block
                                                      : "-",
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
                                                  data.direction != null
                                                      ? data.direction
                                                      : "-",
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "ความเสียหาย",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              data.damge != null &&
                                                      data.damge[
                                                              "description"] !=
                                                          null
                                                  ? data.damge["description"]
                                                  : "-",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
