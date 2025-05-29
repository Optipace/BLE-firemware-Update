import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/utils/snackbar.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({super.key, this.adapterState});

  final BluetoothAdapterState? adapterState;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: lightBg.withOpacity(0.9),
      shadows: [Shadow(color: Colors.black, blurRadius: 0.1, offset: Offset(0.4, 0.4))],
    );
  }

  Widget buildTitle(BuildContext context) {
    String? state = adapterState?.toString().split(".").last;
    return Text(
      'Bluetooth Adapter is ${state ?? 'not available'}',
      style: TextStyle(color: darkBg, fontWeight: FontWeight.w800, fontSize: 16, fontFamily: baseFont),
    );
  }

  Widget buildTurnOnButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStatePropertyAll(5),
            backgroundColor: MaterialStatePropertyAll(darkBg),
            shadowColor: MaterialStatePropertyAll(Colors.black),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
        child: Text(
          'TURN ON',
          style: TextStyle(color: lightBg, fontFamily: baseFont, fontWeight: FontWeight.w500),
        ),
        onPressed: () async {
          try {
            if (!kIsWeb && Platform.isAndroid) {
              await FlutterBluePlus.turnOn();
            }
          } catch (e, backtrace) {
            Snackbar.show(ABC.a, prettyException("Error Turning On:", e), success: false);
            print("$e");
            print("backtrace: $backtrace");
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: Snackbar.snackBarKeyA,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darkBg, lightBg], // Your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildBluetoothOffIcon(context),
                  buildTitle(context),
                  if (!kIsWeb && Platform.isAndroid) buildTurnOnButton(context),
                ],
              ),
            ),
          ),
        ));
  }
}
