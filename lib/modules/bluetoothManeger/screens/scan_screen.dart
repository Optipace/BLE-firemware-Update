import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/screens/device_screen.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/utils/extra.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/utils/snackbar.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/widgets/scan_result_tile.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/widgets/system_device_tile.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() => _scanResults = results);
      }
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      if (mounted) {
        setState(() => _isScanning = state);
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service
      List<Guid> serviceUuids = [Guid("180f")]; // Or provide specific UUIDs

      _systemDevices = await FlutterBluePlus.systemDevices(serviceUuids);
      // _systemDevices = (await FlutterBluePlus.systemDevices) as List<BluetoothDevice>;
    } catch (e, backtrace) {
      Snackbar.show(ABC.b, prettyException("System Devices Error:", e), success: false);
      print(e);
      print("backtrace: $backtrace");
    }
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        withServices: [
          // Guid("180f"), // battery
          // Guid("180a"), // device info
          // Guid("1800"), // generic access
          // Guid("6e400001-b5a3-f393-e0a9-e50e24dcca9e"), // Nordic UART
        ],
        // webOptionalServices: [
        //   Guid("180f"), // battery
        //   Guid("180a"), // device info
        //   Guid("1800"), // generic access
        //   Guid("6e400001-b5a3-f393-e0a9-e50e24dcca9e"), // Nordic UART
        // ],
      );
    } catch (e, backtrace) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e), success: false);
      print(e);
      print("backtrace: $backtrace");
    }
    if (mounted) {
      setState(() {});
      setState(() {
        printFunc("Print isLoading");
        isLoaded = true;
      });
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e, backtrace) {
      Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e), success: false);
      print(e);
      print("backtrace: $backtrace");
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
    });
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => DeviceScreen(device: device), settings: RouteSettings(name: '/DeviceScreen'));
    Navigator.of(context).push(route);
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton() {
    return Row(children: [
      if (FlutterBluePlus.isScanningNow)
        buildSpinner()
      else
        ElevatedButton(
            onPressed: onScanPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: lightBg,
              foregroundColor: darkBg,
            ),
            child: Text(
              "SCAN",
              style:
                  TextStyle(color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w900, fontSize: 18),
            ))
    ]);
  }

  Widget buildSpinner() {
    return Padding(
        padding: const EdgeInsets.all(14.0),
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            backgroundColor: Colors.black12,
            color: lightBg,
            strokeWidth: 3, // optional: makes the circle thinner/thicker
          ),
        ));
  }

  List<Widget> _buildSystemDeviceTiles() {
    printFunc("Inside _buildSystemDeviceTiles");
    return _systemDevices
        .map(
          (d) => SystemDeviceTile(
            device: d,
            onOpen: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DeviceScreen(device: d),
                settings: RouteSettings(name: '/DeviceScreen'),
              ),
            ),
            onConnect: () => onConnectPressed(d),
          ),
        )
        .toList();
  }

  Iterable<Widget> _buildScanResultTiles() {
    printFunc("Inside _buildScanResultTiles");
    return _scanResults.map((r) => Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            ScanResultTile(
              result: r,
              onTap: () => onConnectPressed(r.device),
            ),
            Divider(
              color: darkBg,
              thickness: 0.2,
            )
          ],
        )));
  }

  bool isLoaded = false;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return Icon(
      Icons.search_outlined,
      size: 200.0,
      color: lightBg.withOpacity(0.9),
      shadows: [Shadow(color: Colors.black, blurRadius: 0.1, offset: Offset(0.4, 0.4))],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      'Nearby devices appear after scanning above.',
      style: TextStyle(color: darkBg, fontWeight: FontWeight.w800, fontSize: 16, fontFamily: baseFont),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyB,
      child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Find Devices',
                style: TextStyle(
                    color: lightBg, fontFamily: baseFont, fontWeight: FontWeight.w600, fontSize: 25),
              ),
            ),
            toolbarHeight: 75,
            backgroundColor: darkBg,
            actions: [buildScanButton(), const SizedBox(width: 15)],
          ),
          body: isLoaded
              ? Container(
                  color: second_lightBg,
                  child: RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView(
                      children: <Widget>[
                        ..._buildSystemDeviceTiles(),
                        ..._buildScanResultTiles(),
                      ],
                    ),
                  ),
                )
              : Container(
                  color: second_lightBg,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildBluetoothOffIcon(context),
                          buildTitle(context),
                        ],
                      ),
                    ),
                  ),
                )
          // floatingActionButton: buildScanButton(context),
          ),
    );
  }
}
