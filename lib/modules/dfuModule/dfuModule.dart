import 'dart:async';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:nordic_dfu/nordic_dfu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/api/saveLog.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/qr_code.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/bluetoothHardWareNumber.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

class DfuHomePage extends StatefulWidget {
  const DfuHomePage(
      {super.key, required this.SelectedBatch, required this.allClients});

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
  bool isDeviceSelected = false;

  //mac_Id for ApiCal
  String? mac_Id;
  List result = [];
  String? QRMacId;
  bool showsnackBar = false;
  bool _dfuPopUp = false;

  //current date and time for action timeStamp
  DateTime now = DateTime.now();

  //context for savelog api
  // late BuildContext _safeContext;

  //flag for Pop-up after DFU
  bool showPopUpAfterDFU = false;

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
    printFunc("DEMO QRCODE : $QRMacId");
    const int duration = 10;

    await requestPermissions();
    await scanSub?.cancel();
    results.clear();
    isScanning = true;
    setState(() {});

    List<ScanResult> latestDevices = [];

    await FlutterBluePlus.startScan(timeout: Duration(seconds: duration));

    scanSub = FlutterBluePlus.scanResults.listen((devices) {
      latestDevices = devices;
    });

    // After scan duration, process results
    Future.delayed(Duration(seconds: duration), () async {
      await stopScan();

      final filtered = latestDevices.where((d) {
        final name = d.device.platformName.toLowerCase();
        return name.contains("eionic") || name.contains("airbird") ||  name.contains("dfu") || name.contains("targ");
      }).toList();

      final match = latestDevices
          .where(
            (d) =>
                d.device.remoteId.str.toUpperCase() == QRMacId?.toUpperCase(),
          )
          .firstOrNull;

      if (QRMacId == null) {
        printFunc("No QR — showing filtered devices.");
        results = filtered;
        setState(() {});
        return;
      }

      if (match != null) {
        printFunc("MATCH FOUND for QR: ${match.device.remoteId.str}");
        results = [match];
        QRMacId = null;
        setState(() {});
      } else {
        printFunc("NO MATCH — showing fallback filtered devices.");
        results = filtered;
        QRMacId = null;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("NO DEVICE FOUND"),
            backgroundColor: darkBg,
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }

  Future<void> stopScan() async {
    await scanSub?.cancel();
    scanSub = null;
    await FlutterBluePlus.stopScan();
    isScanning = false;
    setState(() {});
  }

  Future<void> startDfu(ScanResult device, int numberofPackets,
      {bool first = true, String oldId = ""}) async {
    _dfuPopUp = false;


    String DFUstatus;
    String DFUreason;

    printFunc("DEMO DEVICE : $device");
    await stopScan();
    await Future.delayed(const Duration(milliseconds: 1000));

    String file = widget.SelectedBatch.obj["firmware"]["file"];
    debugPrint("🔄 SelectedBatch: ${widget.SelectedBatch.obj}");

    final handler = DfuEventHandler(
      //Device connection
      onDeviceConnecting: (address) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔄 Connecting to $address")));
      },
      onDeviceConnected: (address) {
        setState(() => progressMap[first ? address : oldId] = -1);
        setState(() => percent = -1);

        debugPrint("✅ Connected to device: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Connected to $address")));
      },
      //process starting
      onDfuProcessStarting: (address) {
        debugPrint("🚀 DFU Process Starting: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🚀 DFU Starting for $address")));
      },
      //Firmware uploading and entering the DFU model
      onEnablingDfuMode: (address) async {
        debugPrint("🛠️ Enabling DFU mode on: $address");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "🛠️ Enabling DFU mode on $address",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: darkBg,
        ));
        if (first) {
          await Future.delayed(const Duration(milliseconds: 2000));
          await NordicDfu().abortDfu(address: address);
          ScanResult dfuDevice = await startScanSecondTime(device);
          // results.clear();
          // results.add(dfuDevice);
          await startDfu(dfuDevice, numberofPackets = 3,
              first: false, oldId: device.device.remoteId.str);
          debugPrint("️ DFU Aborted: $device");
        }
      },
      onFirmwareUploading: (address) {
        debugPrint(" Firmware uploading started on: $address");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(" Uploading firmware on $oldId"),
          duration: Duration(seconds: 6),
        ));
      },
      onFirmwareValidating: (address) {
        debugPrint(" Validating firmware for: $address");
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text("🧪 Validating firmware for $address")));
      },

      // If DFU is Aborting [call saveLog API]
      onDfuAborted: (address) {
        debugPrint("️ DFU Aborted: $address");
        //Save LOG API CALL
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ DFU Aborted for $address")));
      },
      // Device disconnecting
      onDeviceDisconnecting: (address) {
        debugPrint(" Disconnecting from device: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔌 Disconnecting from $address")));
      },
      onDeviceDisconnected: (address) {
        debugPrint("Disconnected from device: $address");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔌 Disconnected from $address")));
      },
      onProgressChanged: (address, progress, speed, avgSpeed, part, total) {
        setState(() => progressMap[first ? address : oldId] = progress);
        setState(() => percent = progress);
      },

      // On cmplting [call saveLog API]
      onDfuCompleted: (address) async {
        if (_dfuPopUp) return;
        _dfuPopUp = true;
        DFUstatus = "Y";
        DFUreason = "DFU completed successfully";
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('DFU completed: $oldId'),
              duration: Duration(seconds: 3)),
        );
        setState(() => progressMap.remove(first
            ? address
            : oldId)); //progressMap[first ? address : oldId] = );
        setState(() => percent = 101);
        setState(() {
          // isDeviceSelected = false;
          // scanedDevcice = null;
        });

        if (mounted) {
          await saveLog(context, //_safeContext,
              DateAndTime: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now),
              deviceID: UserData.instance.UUID,
              macID: mac_Id.toString(),
              empID: UserData.instance.userId,
              batchID: widget.SelectedBatch.obj["id"],
              status: DFUstatus,
              reason: DFUreason);
        }

        // Here the Pop-up Goes if the OK btn clicks then it goes to the Bluetooth-Hardware Page

        isDeviceSelected
            ? showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    // title: Text(""),
                    content: Text(
                      "DFU Completed Successfully!!",
                      style: TextStyle(
                        color: darkBg,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    actions: [
                      //OK btn that goes for next page
                      ElevatedButton(
                        onPressed: UserData().designationCode == '3'
                            ? () {
                                printFunc("Inside the Factory User");
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }
                                if (mounted) {
                                  setState(() {
                                    isDeviceSelected = false;
                                    showPopUpAfterDFU = true;
                                  });
                                }

                                Navigator.push(
                                  context, // _safeContext,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BluetoothHardwareNumber(
                                            safecontext: context,
                                            SelectedBatch: widget.SelectedBatch,
                                            allclients: widget.allClients,
                                            macID: mac_Id,
                                          )),
                                );
                              }
                            : () {
                                printFunc("Inside the Field User");
                                Navigator.of(context).pop();
                                setState(() {
                                  isDeviceSelected = false;
                                });
                              },
                        child: Text(
                          "Ok",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(darkBg),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)))),
                      )
                    ],
                    backgroundColor: second_lightBg,
                  );
                },
              )
            : SizedBox();
      },

      // If error occured -- [ call saveLog API ]
      onError: (address, err, type, msg) async {
        debugPrint("⚠️ DFU ERROR onError ${first} : $address \n $msg \n $type \n $err ");
        if (!first||true) {
          DFUstatus = "N";
          DFUreason = "$msg : ${first ? "1": "2"}" ;
          setState(() {
            percent = null;
            isDeviceSelected = false;
          });
          debugPrint("Addres : ${address} \n"
              "error : ${err} \n"
              "type : ${type} \n"
              "msg : ${msg}");

          printFunc("Save log when error occured");
          printFunc("Time : ${DateFormat('dd-MM-yyyy hh:mm a').format(now)} \n"
              "DeviceID : ${UserData.instance.UUID} \n"
              "MacID : ${mac_Id} \n"
              "Batch : ${widget.SelectedBatch.obj["id"]} \n"
              "empID : ${UserData.instance.userId} \n"
              "Status : ${DFUstatus} \n"
              "Reason : ${DFUreason}");

          // CALL savelog API
          await saveLog(context,
              DateAndTime: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now),
              deviceID: UserData.instance.UUID,
              macID: mac_Id.toString(),
              empID: UserData.instance.userId,
              batchID: widget.SelectedBatch.obj["id"],
              status: DFUstatus,
              reason: DFUreason);
        }
        ShowSnackBarMessage(context, ' ⚠️ DFU error [$err]: $msg', false);
      },

    );

    try {
      await NordicDfu().startDfu(
        device.device.remoteId.str,
        file, //file.files.single.path!,
        dfuEventHandler: handler,
        forceDfu: true,
        numberOfPackets: numberofPackets,

        // enableUnsafeExperimentalButtonlessServiceInSecureDfu:true,
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
    } catch (e) {
      printFunc("ERROR : $e");
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
  Widget build(BuildContext context) {
    // _safeContext = context;
    if (!isDeviceSelected) {
      scanedDevcice = null;
      percent = null;
      printFunc(" designation ${UserData().designationCode}");
    }
    getSize(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
        iconTheme: IconThemeData(color: lightBg),
        leading: isDeviceSelected
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                onPressed: () {
                  if (isDeviceSelected) {
                    setState(() {
                      isDeviceSelected = false;
                      scanedDevcice = null;
                    });
                  } else {
                    printFunc("2nd POP");
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
              ),
        title: const Text("DFU Devices"),
        //Optipace - DFU
        actions: [
          if (!isDeviceSelected)
            isScanning
                ? Container(
                    color: darkBg,
                    margin: EdgeInsets.all(18),
                    child: const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5, // thinner stroke
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(isScanning ? Icons.pause : Icons.play_arrow),
                    onPressed: isScanning ? stopScan : startScan,
                  ),
          if (!isDeviceSelected)
            IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QRScannerScreen(title: "Scan QR-Code"),
                    ),
                  );
                  QRMacId = result;
                  setState(() {});
                  await startScan();
                },
                icon: Icon(Icons.qr_code_2_outlined)),
          IconButton(
            icon: const Icon(Icons.battery_alert),
            tooltip: 'Battery Optimization',
            onPressed: openBatteryOptimizationSettings,
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isDeviceSelected) {
            setState(() {
              isDeviceSelected = false;
              scanedDevcice = null;
            });
            return false;
          } else {
            // Navigator.of(context,rootNavigator: true).pop();
            return true;
          }
        },
        child: isDeviceSelected ? DFUConfirm() : DeviceList(),
      ),
    );
  }

  ScanResult? scanedDevcice = null;
  int? percent;

  Widget DeviceList() {
    return Stack(
      children: [
        ListView.builder(
          itemCount: results.length,
          itemBuilder: (_, i) {
            final device = results[i].device;
            final id = device.remoteId.str;
            percent = progressMap[id];
            final name = device.platformName.isNotEmpty
                ? device.platformName
                : 'Unnamed';

            return ListTile(
              leading: const Icon(Icons.bluetooth),
              title: Text(name),
              subtitle: Text(id),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: darkBg),

                onPressed: () => setState(() {
                  isDeviceSelected = true;
                  scanedDevcice = results[i];
                  percent = null; // progressMap[id];
                  printFunc("Demo dfu device : $scanedDevcice");
                  stopScan;
                }), //startDfu(scanedDevcice),
                child: Text('Select'),
                // Text(percent != null ? '$percent%' :percent == -1 ?"i need a progress circle": 'DFU'),
              ),
            );
          },
        ),
        if (showPopUpAfterDFU)
          Positioned.fill(
            child: Container(
              color: Colors.black54, // dim background
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Notice",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text("Do you need to flash New Device ?",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 120,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(darkBg),
                              ),
                              onPressed: () {
                                setState(() {
                                  showPopUpAfterDFU = false;
                                });
                              },
                              child: FittedBox(
                                  fit: BoxFit.scaleDown, child: Text("Yes")),
                            ),
                          ),
                          Container(
                            width: 120,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(darkBg),
                              ),
                              onPressed: () {
                                printFunc("3rd pop");
                                Navigator.of(context)
                                    .pop(); // pop screen if needed
                                Navigator.of(context).pop();
                                setState(() {
                                  showPopUpAfterDFU = false;
                                });
                              },
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text("NO"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget DFUConfirm() {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    "CONFIRM THE DETAILS",
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: darkBg,
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              blurRadius: 0.5,
                              offset: Offset(0.5, 0.5))
                        ]),
                  ),
                ),
              ),
              Divider(
                color: darkBg,
              ),
              //Device
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 0.5,
                                      offset: Offset(0.5, 0.5))
                                ])),
                        SizedBox(width: 5), // spacing before line
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Name
                          Container(
                            width: screenSize.width * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("MAC Id",
                                    style: CardText(
                                        font_Weight: FontWeight.w500,
                                        FontColor: secondaryText)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                    scanedDevcice != null
                                        ? scanedDevcice!.device.remoteId.str
                                        : "-",
                                    style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 14,
                                        FontColor: darkBg)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Description
                          Container(
                            width: screenSize.width * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Name",
                                  style: CardText(
                                      font_Weight: FontWeight.w500,
                                      FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  scanedDevcice != null
                                      ? scanedDevcice!.device.platformName
                                      : "-",
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
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 0.5,
                                      offset: Offset(0.5, 0.5))
                                ])),
                        SizedBox(width: 5), // spacing before line
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Name
                              Container(
                                width: 80,
                                child: Text("Batch",
                                    style: CardText(
                                        font_Weight: FontWeight.w500,
                                        FontColor: secondaryText)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // Description
                              Container(
                                width: 80,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Description",
                                    style: CardText(
                                        font_Weight: FontWeight.w500,
                                        FontColor: secondaryText),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // Description
                              Container(
                                width: 60,
                                child: Text(
                                  "Series",
                                  style: CardText(
                                      font_Weight: FontWeight.w500,
                                      FontColor: secondaryText),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Name
                              Container(
                                width: 80,
                                child: Text(
                                    widget.SelectedBatch.obj["name"].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // Description
                              Container(
                                width: 80,
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.SelectedBatch.obj["description"]
                                          .toString(),
                                      style: CardText(
                                          font_Weight: FontWeight.w700,
                                          size: 16,
                                          FontColor: darkBg),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // Description
                              Container(
                                width: 60,
                                child: Center(
                                  child: Text(
                                    widget.SelectedBatch
                                        .obj["battery"]['batteryCode']
                                        .toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
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
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 0.5,
                                      offset: Offset(0.5, 0.5))
                                ])),
                        SizedBox(width: 5), // spacing before line
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: FittedBox(
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
                                  style: CardText(
                                      font_Weight: FontWeight.w500,
                                      FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  widget
                                      .SelectedBatch.obj["firmware"]["version"]
                                      .toString(),
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
                                  style: CardText(
                                      font_Weight: FontWeight.w500,
                                      FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  widget.SelectedBatch
                                      .obj["firmware"]["versionName"]
                                      .toString(),
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
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 0.5,
                                      offset: Offset(0.5, 0.5))
                                ])),
                        SizedBox(width: 5), // spacing before line
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                                        Icon(
                                            Icons
                                                .battery_charging_full_outlined,
                                            size: 18,
                                            color: secondaryText),
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
                                    ), // Upper Voltage
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.battery_6_bar_outlined,
                                            size: 18, color: secondaryText),
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
                                        Icon(Icons.battery_alert_outlined,
                                            size: 18, color: secondaryText),
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
                                        Icon(Icons.battery_1_bar_rounded,
                                            size: 18, color: secondaryText),
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
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                    Text(
                                      "N. Volt",
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
                                        Icon(
                                            Icons
                                                .battery_charging_full_outlined,
                                            size: 18,
                                            color: darkBg),
                                        SizedBox(width: 5),
                                        Text(
                                          "${widget.SelectedBatch.obj["profile"]["nV"]} V",
                                          style: CardText(
                                            font_Weight: FontWeight.w700,
                                            size: 16,
                                            FontColor: darkBg,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                    Text(
                                      "U.Temp",
                                      style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg,
                                      ),
                                    ),
                                    // Upper Voltage
                                    SizedBox(height: 5),
                                    Text(
                                      "${widget.SelectedBatch.obj["profile"]['uTemp']}",
                                      style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                    Text(
                                      "L.Temp",
                                      style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg,
                                      ),
                                    ),
                                    // Lower Threshold
                                    SizedBox(height: 5),
                                    Text(
                                      "${widget.SelectedBatch.obj["profile"]['lTemp']} ",
                                      style: CardText(
                                        font_Weight: FontWeight.w700,
                                        size: 16,
                                        FontColor: darkBg,
                                      ),
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
              SizedBox(
                height: 20,
              ),

              Divider(
                color: darkBg,
              ),
              Divider(
                color: darkBg,
              ),

              SizedBox(
                height: 5,
              ),
              if (percent != null && percent != 101)
                Text("Firmware updating ...",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: secondaryText)),
              if (percent == 101)
                Text("Firmware update completed",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: secondaryText)),

              SizedBox(height: 10,),

              percent != null && percent != -1
                  ? SizedBox(
                      width: screenSize.width * 0.7,
                      height: 5,
                      child: LinearProgressIndicator(
                        value: double.parse(((percent ?? 0.1) / 100.0)
                            .toStringAsFixed(2)), //(percent??0.001)/10.0,
                        minHeight: 3,
                        // backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                      ),
                    )
                  : percent == -1
                      ? SizedBox(
                          width: screenSize.width * 0.7,
                          child: LinearProgressIndicator(
                            minHeight: 4,
                            backgroundColor: Colors.grey[300],
                            color: Colors.blue, // or any color of your theme
                          ),
                        )
                      : SizedBox(),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (percent == null || percent == 101)
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: darkBg),
                          onPressed: () {
                            setState(() {
                              isDeviceSelected = false;
                              scanedDevcice = null;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.keyboard_double_arrow_left),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Change device")
                            ],
                          )),
                    //start dfu

                    if (percent == null || percent == 101)
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: darkBg),
                          onPressed: () async {
                            setState(() {
                              mac_Id = scanedDevcice != null
                                  ? scanedDevcice!.device.remoteId.str
                                  : "-";
                            });

                            await startDfu(scanedDevcice!, 3);

                            // For aborting Button things
                            /*if (percent != null && percent != 101) {
                            try {
                              await NordicDfu().abortDfu(
                                  address: scanedDevcice!.device.remoteId.str);
                              setState(() {
                                percent = null;
                              });
                            }catch (e) {
                              printFunc("exception while NordicDfu :$e");
                            }
                          }
                          else {
                            await startDfu(scanedDevcice!,4);
                          } */
                          },
                          child: Row(
                            children: [
                              Icon(Icons.flash_on_outlined
                                  //For aborting Button
                                  /*percent != null && percent != 101
                                ? Icons.clear_outlined
                                : Icons.flash_on_outlined */
                                  ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(percent == 101 ? "Start Again" : 'Start DFU'
                                  // For abort button
                                  /*percent != null && percent != 101
                                ? "   Abort   "
                                : percent == 101
                                    ? "Start Again"
                                    : 'Start DFU'*/
                                  )
                            ],
                          )),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<ScanResult> startScanSecondTime(ScanResult oldDevice) async {
    printFunc("In the Second Tym");
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
        final oldBytes = oldMac
            .split(':')
            .map((e) => int.tryParse(e, radix: 16) ?? 0)
            .toList();
        final newBytes = d.device.remoteId.str
            .split(':')
            .map((e) => int.tryParse(e, radix: 16) ?? 0)
            .toList();

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
        final oldBytes = oldMac
            .split(':')
            .map((e) => int.tryParse(e, radix: 16) ?? 0)
            .toList();
        final newBytes = d.device.remoteId.str
            .split(':')
            .map((e) => int.tryParse(e, radix: 16) ?? 0)
            .toList();

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

  @override
  void dispose() {
    scanSub?.cancel();
    super.dispose();
  }
}
