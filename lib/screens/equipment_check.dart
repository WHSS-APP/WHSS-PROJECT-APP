import 'package:flutter/material.dart';

class EquipmentCheck extends StatefulWidget {
  const EquipmentCheck({super.key});

  @override
  State<EquipmentCheck> createState() => _EquipmentCheckState();
}

class _EquipmentCheckState extends State<EquipmentCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Hello"),
      ),
    );
  }
}
