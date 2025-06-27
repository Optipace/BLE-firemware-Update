import 'dart:async';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:nordic_dfu/nordic_dfu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/bluetoothHardWareNumber.dart';

class DfuHomePage extends StatefulWidget {
  const DfuHomePage({super.key, required this.SelectedBatch, required this.allClients});

  final DataController SelectedBatch;
  final Map<String, dynamic> allClients;

  @override
  State<DfuHomePage> createState() => _DfuHomePageState();
}

class _DfuHomePageState extends State<DfuHomePage> {
  StreamSubscription<List<ScanResult>>? scanSub;
  List<ScanResult> results = [];
  bool isScanning = false;
  Map<String, int> progressMap = {};

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
    }
  }

  Future<void> startScan() async {
    await requestPermissions();
    await scanSub?.cancel();
    results.clear();
    isScanning = true;
    setState(() {});

    // ✅ GATT-133 safe scan settings
    await FlutterBluePlus.startScan(
      // androidLegacy: true,
      // androidScanMode: AndroidScanMode.lowLatency,
      // androidUsesFineLocation: true,
      timeout: const Duration(seconds: 20),
      // oneByOne: true,
    );

    scanSub = FlutterBluePlus.scanResults.listen((devices) {
      final filtered = devices.where((d) {
        final name = d.device.platformName.toLowerCase();
        return name.contains("eionic") || name.contains("airbird");
      }).toList();

      setState(() {
        results = filtered;
      });
    });
  }

  Future<void> stopScan() async {
    await scanSub?.cancel();
    scanSub = null;
    await FlutterBluePlus.stopScan();
    isScanning = false;
    setState(() {});
  }

  Future<void> startDfu(ScanResult device, {bool first = true, String oldId = ""}) async {
    await stopScan();
    await Future.delayed(const Duration(milliseconds: 1000)); // ✅ Allow BLE stack to settle
    // await Wakelock.enable();

    String file = widget.SelectedBatch.obj["firmware"]["file"];
    // if (first) {
    //   file = await FilePicker.platform.pickFiles();
    //   if (file == null || file.files.single.path == null) return;
    // } else {
    //   file = oldFile;
    // }
    debugPrint("🔄 SelectedBatch: ${widget.SelectedBatch.obj}");

    final handler = DfuEventHandler(
      onDeviceConnecting: (address) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔄 Connecting to $address")));
      },
      onDeviceConnected: (address) {
        setState(() => progressMap[first ? address : oldId] = -1);

        debugPrint("✅ Connected to device: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Connected to $address")));
      },
      onDfuProcessStarting: (address) {
        debugPrint("🚀 DFU Process Starting: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🚀 DFU Starting for $address")));
      },
      onEnablingDfuMode: (address) async {
        debugPrint("🛠️ Enabling DFU mode on: $address");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("🛠️ Enabling DFU mode on $address")));
        if (first) {
          await Future.delayed(const Duration(milliseconds: 2000)); // ✅ Allow BLE stack to settle
          await NordicDfu().abortDfu(address: address);
          ScanResult dfuDevice = await startScanSecondTime(device);
          // results.clear();
          // results.add(dfuDevice);
          await startDfu(dfuDevice, first: false, oldId: device.device.remoteId.str);

          debugPrint("🛠️ DFU Aborted: $device");
        }
      },
      onFirmwareUploading: (address) {
        debugPrint("📤 Firmware uploading started on: $address");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("📤 Uploading firmware on $address")));
      },
      onFirmwareValidating: (address) {
        debugPrint("🧪 Validating firmware for: $address");
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text("🧪 Validating firmware for $address")));
      },
      onDfuAborted: (address) {
        debugPrint("⚠️ DFU Aborted: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ DFU Aborted for $address")));
      },
      onDeviceDisconnecting: (address) {
        debugPrint("🔌 Disconnecting from device: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔌 Disconnecting from $address")));
      },
      onDeviceDisconnected: (address) {
        debugPrint("🔌 Disconnected from device: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔌 Disconnected from $address")));
      },
      onProgressChanged: (address, percent, speed, avgSpeed, part, total) {
        setState(() => progressMap[first ? address : oldId] = percent);
      },
      onDfuCompleted: (address) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ DFU completed: $address'), duration: Duration(seconds: 10)),
        );
        setState(() => progressMap[first ? address : oldId] = 101);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BluetoothHardwareNumber(
                    SelectedBatch: widget.SelectedBatch,
                    allclients: widget.allClients,
                  )),
        );
      },
      onError: (address, err, type, msg) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('❌ DFU error [$err]: $msg'), duration: Duration(seconds: 10)),
        // );
      },
    );

    try {
      await NordicDfu().startDfu(
        device.device.remoteId.str,
        file, //file.files.single.path!,
        dfuEventHandler: handler,
        forceDfu: true,
        numberOfPackets: 4,
        // enableUnsafeExperimentalButtonlessServiceInSecureDfu:false,
        androidParameters:
            //  const AndroidParameters(rebootTime: 10000),
            const AndroidParameters(
          rebootTime: 2000,
          packetReceiptNotificationsEnabled: true,
          keepBond: false,
          restoreBond: false,
          numberOfRetries: 5,
        ),
        // darwinParameters: const DarwinParameters(
        //   forceScanningForNewAddressInLegacyDfu: true,
        //   packetReceiptNotificationParameter: 4,
        //   dataObjectPreparationDelay: 2500.0,
        // ),
      );
    } finally {
      // await Wakelock.disable();
    }
  }

  void openBatteryOptimizationSettings() {
    var intent = AndroidIntent(
      action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  @override
  void dispose() {
    scanSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Optipace - DFU"),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.pause : Icons.play_arrow),
            onPressed: isScanning ? stopScan : startScan,
          ),
          IconButton(
            icon: const Icon(Icons.battery_alert),
            tooltip: 'Battery Optimization',
            onPressed: openBatteryOptimizationSettings,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (_, i) {
          final device = results[i].device;
          final scanedDevcice = results[i];
          final id = device.remoteId.str;
          final percent = progressMap[id];
          final name = device.platformName.isNotEmpty ? device.platformName : 'Unnamed';

          return ListTile(
            leading: const Icon(Icons.bluetooth),
            title: Text(name),
            subtitle: Text(id),
            trailing: ElevatedButton(
              onPressed: () => startDfu(scanedDevcice),
              child: percent == -1
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(percent == 101
                      ? "Done"
                      : percent != null
                          ? '$percent%'
                          : 'DFU'),
              // Text(percent != null ? '$percent%' :percent == -1 ?"i need a progress circle": 'DFU'),
            ),
          );
        },
      ),
    );
  }

  Future<ScanResult> startScanSecondTime(ScanResult oldDevice) async {
    String oldMac = oldDevice.device.remoteId.str;
    final completer = Completer<ScanResult>();
    late StreamSubscription<List<ScanResult>> subscription;

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    subscription = FlutterBluePlus.scanResults.listen((devices) {
      final dfuCandidates = devices.where((d) {
        final name = d.device.platformName.toLowerCase();
        return name.contains("dfu") || name.contains("targ");
      });

      ScanResult? bestMatchDevice;
      int minDiff = 255;

      for (final d in dfuCandidates) {
        final oldBytes = oldMac.split(':').map((e) => int.tryParse(e, radix: 16) ?? 0).toList();
        final newBytes =
            d.device.remoteId.str.split(':').map((e) => int.tryParse(e, radix: 16) ?? 0).toList();

        if (oldBytes.length == newBytes.length) {
          int diff = 0;
          for (int i = 0; i < oldBytes.length; i++) {
            diff += (oldBytes[i] - newBytes[i]).abs();
          }

          if (diff < minDiff) {
            bestMatchDevice = d;
            minDiff = diff;
          }
        }
      }

      if (bestMatchDevice != null) {
        completer.complete(bestMatchDevice);
        subscription.cancel();
        FlutterBluePlus.stopScan();
      }
    });

    return completer.future.timeout(const Duration(seconds: 10), onTimeout: () {
      subscription.cancel();
      FlutterBluePlus.stopScan();

      return oldDevice; //BluetoothDevice(remoteId: DeviceIdentifier(oldMac)); // fallback: construct from old MAC
    });
  }

  Future<String> startScanSecondTimea(String oldMac) async {
    final completer = Completer<String>();
    late StreamSubscription<List<ScanResult>> subscription;

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    subscription = FlutterBluePlus.scanResults.listen((devices) {
      final dfuCandidates = devices.where((d) {
        final name = d.device.platformName.toLowerCase();
        return name.contains("dfu") || name.contains("targ");
      });

      String? bestMatch;
      int minDiff = 255;

      for (final d in dfuCandidates) {
        final oldBytes = oldMac.split(':').map((e) => int.tryParse(e, radix: 16) ?? 0).toList();
        final newBytes =
            d.device.remoteId.str.split(':').map((e) => int.tryParse(e, radix: 16) ?? 0).toList();

        if (oldBytes.length == newBytes.length) {
          int diff = 0;
          for (int i = 0; i < oldBytes.length; i++) {
            diff += (oldBytes[i] - newBytes[i]).abs();
          }
          if (diff < minDiff) {
            bestMatch = d.device.remoteId.str;
            minDiff = diff;
          }
        }
      }

      if (bestMatch != null) {
        completer.complete(bestMatch);
        subscription.cancel();
        FlutterBluePlus.stopScan();
      }
    });

    return completer.future.timeout(const Duration(seconds: 10), onTimeout: () {
      subscription.cancel();
      FlutterBluePlus.stopScan();
      return oldMac; // fallback to old MAC if nothing found
    });
  }
}
