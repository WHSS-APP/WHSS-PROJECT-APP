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
    ));
  }
}
