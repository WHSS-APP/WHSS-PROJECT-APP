import 'package:flutter/material.dart';
import 'package:project_whss_app/controller/file_controller.dart';
import 'package:project_whss_app/screens/equipment_check.dart';
import 'package:provider/provider.dart';

void main() {
  var app = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=> FileController())
    ],
    child: MaterialApp(title: "WHSS", home: EquipmentCheck()),
  );
  runApp(app);
}
