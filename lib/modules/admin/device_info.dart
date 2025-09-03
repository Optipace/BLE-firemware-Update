import 'package:flutter/material.dart';

class deviceInfo extends StatefulWidget {
  const deviceInfo({super.key});

  @override
  State<deviceInfo> createState() => _deviceInfoState();
}

class _deviceInfoState extends State<deviceInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Info"),
      ),
    );
  }
}
