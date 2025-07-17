import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/modules/dfuModule/bluetooth_off_screen.dart';
import 'package:tracker_firmware/modules/dfuModule/dfuModule.dart';

class BluetoothMainScreen extends StatefulWidget {
  final DataController SelectedBatch;
  final Map<String, dynamic> allClients;

  const BluetoothMainScreen({super.key, required this.SelectedBatch, required this.allClients,});

  @override
  State<BluetoothMainScreen> createState() => _BluetoothMainScreenState();
}

class _BluetoothMainScreenState extends State<BluetoothMainScreen> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Widget screen  = _adapterState == BluetoothAdapterState.on
    ?  DfuHomePage(SelectedBatch: widget.SelectedBatch, allClients: widget.allClients)
    : BluetoothOffScreen(adapterState: _adapterState,);

    return MaterialApp(
      color: darkBg,
      debugShowCheckedModeBanner: false,
      home: screen,
      // navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/BluetoothHardwareNumber') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
