import 'dart:async';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:nordic_dfu/nordic_dfu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/bluetoothHardWareNumber.dart';

import '../admin/log/admin_logs.dart';

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
        if(UserData().designationCode == "3") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BluetoothHardwareNumber(
                      SelectedBatch: widget.SelectedBatch,
                      allclients: widget.allClients,
                    )),
          );
        }
      },
      onError: (address, err, type, msg) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('❌ DFU error [$err]: $msg'), duration: Duration(seconds: 10)),
        // );
      },
    );

    try {
      debugPrint("Device :${device.device.remoteId.str}");
      debugPrint("file :${file}");
      debugPrint("file :${UserData().designationCode}");

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
      body:ConfirmPage(context,"AIRBIRD","c9:0c:7f:DC:53:05"),
      /*ListView.builder(
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
              style: ElevatedButton.styleFrom(backgroundColor: darkBg),
              onPressed: () {
                startDfu(scanedDevcice);
              } ,
              //
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
      ), */
    );
  }

  Widget ConfirmPage(BuildContext context, String name,  String id)  {
    printFunc("DEMODEMOMDEM : ${UserData().designation}");
    printFunc(" NAME NAME : ${widget.SelectedBatch.obj}");
    return Container(
      margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: second_lightBg.withOpacity(0.5),
            border: Border.all(
              color: darkBg,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child:SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "CONFIRM THE DETAILS",
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: darkBg,
                        shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))]),
                  ),
                ),
              ),
              Divider(color: darkBg,),
              //Device
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                    children: [
                      Text("DEVICE DETAILS ",
                          style: TextStyle(
                              color: darkBg,
                              fontWeight: FontWeight.w500,
                              fontFamily: baseFont,
                              fontSize: 16,
                              shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))])
                      ),
                      SizedBox(width: 5), // spacing before line
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                    SizedBox(height: 5,),
                    Container(
                      padding: EdgeInsets.all(10),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Name
                          Container(
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Id",
                                    style: CardText(font_Weight: FontWeight.w500, FontColor: secondaryText)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(id,
                                    style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 14,
                                        FontColor: darkBg)),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          // Description
                          Container(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Name",
                                  style: CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  name,
                                  style: CardText(
                                      font_Weight: FontWeight.w700,
                                      size: 16,
                                      FontColor: darkBg),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //Bacthes
              Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("BATCH DETAILS ",
                            style: TextStyle(
                                color: darkBg,
                                fontWeight: FontWeight.w500,
                                fontFamily: baseFont,
                                fontSize: 16,
                                shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))])
                        ),
                        SizedBox(width: 5), // spacing before line
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(
                      padding: EdgeInsets.all(10),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Name
                          Container(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Batch",
                                    style: CardText(font_Weight: FontWeight.w500, FontColor: secondaryText)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(widget.SelectedBatch.obj["name"].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg)),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          // Description
                          Container(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Description",
                                  style: CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  widget.SelectedBatch.obj["description"].toString(),
                                  style: CardText(
                                      font_Weight: FontWeight.w700,
                                      size: 16,
                                      FontColor: darkBg),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
              //FirmWare
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("FIRMWARE DETAILS ",
                            style: TextStyle(
                                color: darkBg,
                                fontWeight: FontWeight.w500,
                                fontFamily: baseFont,
                                fontSize: 16,
                                shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))])
                        ),
                        SizedBox(width: 5), // spacing before line
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(
                      padding: EdgeInsets.all(10),
                      child:  FittedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Firm version
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Firmware Version",
                                  style: CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  widget.SelectedBatch.obj["firmware"]["version"].toString(),
                                  style: CardText(
                                      font_Weight: FontWeight.w700,
                                      size: 16,
                                      FontColor: darkBg),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // firmware name
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Firmware Name",
                                  style: CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  widget.SelectedBatch.obj["firmware"]["versionName"].toString(),
                                  style: CardText(
                                      font_Weight: FontWeight.w700,
                                      size: 16,
                                      FontColor: darkBg),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //Config
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("CONFIG DETAILS ",
                            style: TextStyle(
                                color: darkBg,
                                fontWeight: FontWeight.w500,
                                fontFamily: baseFont,
                                fontSize: 16,
                                shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))])
                        ),
                        SizedBox(width: 5), // spacing before line
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: FittedBox(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
// Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold

                                    Text(
                                      "U. Threshold",
                                      style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg,
                                      ),
                                    ),
// Upper Threshold
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.battery_charging_full_outlined,
                                            size: 18, color: secondaryText),
                                        SizedBox(width: 5),
                                        Text(
                                          "${widget.SelectedBatch.obj["profile"]["uT"]} V",
                                          style: CardText(
                                            font_Weight: FontWeight.w700,
                                            size: 18,
                                            FontColor: darkBg,
                                          ),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
// Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                    Text(
                                      "U.Volt",
                                      style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg,
                                      ),
                                    ),// Upper Voltage
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.battery_6_bar_outlined, size: 18, color: secondaryText),
                                        SizedBox(width: 5),
                                        Text(
                                          "${widget.SelectedBatch.obj["profile"]['uV']} V",
                                          style: CardText(
                                            font_Weight: FontWeight.w700,
                                            size: 18,
                                            FontColor: darkBg,
                                          ),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
// Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                    Text(
                                      "L.Threshold",
                                      style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg,
                                      ),
                                    ),
// Lower Threshold
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.battery_alert_outlined, size: 18, color: secondaryText),
                                        SizedBox(width: 5),
                                        Text(
                                          "${widget.SelectedBatch.obj["profile"]['lT']} V",
                                          style: CardText(
                                            font_Weight: FontWeight.w700,
                                            size: 18,
                                            FontColor: darkBg,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
// Icon(Icons.battery_2_bar, size: 18, color: secondaryText), // Lower Voltage
                                    Text(
                                      "L. Volt",
                                      style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg,
                                      ),
                                    ),
                                    SizedBox(height: 5),
// Lower Voltage
                                    Row(
                                      children: [
                                        Icon(Icons.battery_1_bar_rounded, size: 18, color: secondaryText),
                                        SizedBox(width: 5),
                                        Text(
                                          "${widget.SelectedBatch.obj["profile"]['lV']} V",
                                          style: CardText(
                                            font_Weight: FontWeight.w700,
                                            size: 18,
                                            FontColor: darkBg,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Btns
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: darkBg,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 25,vertical: 8)
                        ),
                        onPressed: (){},
                        child: Row(
                          children: [
                            Icon(Icons.keyboard_double_arrow_left),
                            SizedBox(width: 5,),
                            Text("Back")
                          ],
                        )
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: darkBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                            ),
                          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 8)
                        ),
                        onPressed: (){},
                        child: Row(
                          children: [
                            Text("Flash"),
                            SizedBox(width: 5,),
                            Icon(Icons.flash_on_outlined),
                          ],
                        )
                    ),
                  ],
                ),

              )

            ],
          ),
        )
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
