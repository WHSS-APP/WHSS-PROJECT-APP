import 'package:flutter/material.dart';
import 'package:project_whss_app/screens/equipment_check.dart';

class EquipmentInspectionRecord extends StatefulWidget {
  const EquipmentInspectionRecord({super.key});

  @override
  State<EquipmentInspectionRecord> createState() =>
      _EquipmentInspectionRecordState();
}

class _EquipmentInspectionRecordState extends State<EquipmentInspectionRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Equipment Inspection Recode"),
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
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(
              hintText: '',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              // helperText: 'Keep it short, this is just a demo.',
              labelText: 'ค้นหาหมายเลขภาพ, ตำแหน่ง...',
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              InkWell(
                child: SingleChildScrollView(
                  child: Center(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            leading: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                  maxWidth: 64,
                                  maxHeight: 44,
                                ),
                                child: Image.network(
                                  'https://picsum.photos/250?image=9',
                                  width: 280,
                                )),
                            title: Column(children: const [
                              Row(
                                children: [
                                  Text(
                                    "ภาพที่",
                                    style: TextStyle(
                                        fontFamily: 'Prompt',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromRGBO(57, 137, 123, 1)),
                                  ),
                                  Text(
                                    "K20161027091905",
                                    style: TextStyle(
                                        fontFamily: 'Prompt',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromRGBO(57, 137, 123, 1)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "ตำแหน่ง",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                57, 137, 123, 1)),
                                      ),
                                      Text(
                                        "ชั้นที่",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                57, 137, 123, 1)),
                                      ),
                                      Text(
                                        "ความเสียหาย",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                57, 137, 123, 1)),
                                      ),
                                      Text(
                                        "การแก้ไข",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                57, 137, 123, 1)),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "ตำแหน่ง",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                57, 137, 123, 1)),
                                      ),
                                      Text(
                                        "ชั้นที่",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                57, 137, 123, 1)),
                                      ),
                                      Text(
                                        "ความเสียหาย",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                57, 137, 123, 1)),
                                      ),
                                      Text(
                                        "การแก้ไข",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                57, 137, 123, 1)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              )
            ],
          ))
        ]),
      ),
    );
  }
}
