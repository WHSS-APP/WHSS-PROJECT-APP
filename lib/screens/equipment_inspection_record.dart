// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:project_whss_app/controller/file_controller.dart';
import 'package:project_whss_app/screens/equipment_check.dart';
import 'package:provider/provider.dart';

// class EquipmentInspectionRecord extends StatefulWidget {
//   const EquipmentInspectionRecord({super.key});

//   @override
//   State<EquipmentInspectionRecord> createState() =>
//       _EquipmentInspectionRecordState();
// }

class EquipmentInspectionRecord extends StatelessWidget {
  const EquipmentInspectionRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch job data from FileController
    final jobs = context.select((FileController controller) => controller.job);

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
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'ค้นหาหมายเลขภาพ, ตำแหน่ง...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: jobs?.length ?? 0,
                itemBuilder: (context, index) {
                  final job = jobs;
                  return InkWell(
                    onTap: () {
                      // Handle job item click
                    },
                    child: Card(
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
                              job.picturePath,
                            ),
                          ),
                          title: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(21, 29, 40, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "ภาพที่ " + job.itemName,
                                        style: TextStyle(
                                          fontFamily: 'Prompt',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color.fromRGBO(255, 153, 0, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                      ),
                                      Text(
                                        job.itemName,
                                        style: TextStyle(
                                          fontFamily: 'Prompt',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(21, 29, 40, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ตำแหน่ง",
                                            style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                          Text(
                                            "ชั้นที่",
                                            style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                          Text(
                                            "ความเสียหาย",
                                            style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                          Text(
                                            "การแก้ไข",
                                            style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job.location.strc,
                                            style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 16,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                          Text(
                                            job.location.loct,
                                            style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 16,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                          Text(
                                            job.damage.description,
                                            style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 16,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                          Text(
                                            "การแก้ไข",
                                            style: TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 16,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
