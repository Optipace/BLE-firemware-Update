import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/qr_code.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/Methods/scanAndconnect.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

class locateHomePage extends StatefulWidget {
  const locateHomePage({super.key});

  @override
  State<locateHomePage> createState() => _locateHomePageState();
}

class _locateHomePageState extends State<locateHomePage> {
  StreamSubscription<List<ScanResult>>? scanSub;
  List<ScanResult> results = [];
  bool isScanning = false;
  Map<String, int> progressMap = {};

  //mac_Id for ApiCal
  String? mac_Id;
  List result = [];
  String? QRMacId;

  //For Device
  BluetoothDevice? selectedDevice;
  BluetoothCharacteristic? locateChar;

  final serviceUUID = Guid("f043176a-5168-11ee-be56-0242ac120012");
  final locateCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120015");

  String status = "Disconnected";
  String deviceName = "-";
  bool NotConnected = false;
  bool connected = false;
  bool connecting = false;

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await [
        Permission.location,
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise
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
        return name.contains("eionic") || name.contains("airbird");
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startScan();
  }

  @override
  Widget build(BuildContext context) {
    getSize(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
        iconTheme: IconThemeData(color: lightBg),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        title: const Text("Locate Devices"),
        actions: [
          isScanning
              ? Container(
                  color: darkBg,
                  margin: EdgeInsets.all(18),
                  child: const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(isScanning ? Icons.pause : Icons.play_arrow),
                  onPressed: isScanning ? stopScan : startScan,
                ),
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
        ],
      ),
      body: DeviceList(),
    );
  }

  Widget DeviceList() {
    return Stack(
      children: [
        ListView.builder(
          itemCount: results.length,
          itemBuilder: (_, i) {
            final device = results[i].device;
            final id = device.remoteId.str;
            final name = device.platformName.isNotEmpty
                ? device.platformName
                : 'Unnamed';

            return ListTile(
              leading: const Icon(Icons.bluetooth),
              title: Text(name),
              subtitle: Text(id),
              trailing: IconButton(
                  onPressed: () async {
                    printFunc("DEMO DEMO MACID - ${id}");

                    if (selectedDevice != null) {
                      printFunc("Already device");
                      await disconnect();
                    }

                    setState(() {
                      mac_Id = id;
                      selectedDevice = device;
                      connecting = true; // Start connecting
                    });

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext contextt) {
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
                              // Listen to state changes and update dialog
                              return StreamBuilder(
                                stream: Stream.periodic(
                                    Duration(milliseconds: 100)),
                                builder: (context, snapshot) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (connecting)
                                          CircularProgressIndicator(
                                            color: darkBg,
                                          ),
                                        if (connecting) SizedBox(height: 8),
                                        if (connecting)
                                          Text(
                                            "Connecting...",
                                            style: TextStyle(color: darkBg),
                                          ),
                                        if (connected && !connecting)
                                          Image.asset(
                                            'assets/image/alarm.gif',
                                            width: 80,
                                            height: 80,
                                          ),
                                        if (connected && !connecting)
                                          SizedBox(height: 8),
                                        if (connected && !connecting)
                                          Text(
                                            "Buzzing . . .",
                                            style: TextStyle(
                                                color: darkBg,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        });

                    scanAndConnect(selectedDevice!);

                    printFunc("Demo mac_Id : $mac_Id");
                  },
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    color: darkBg,
                  )),
            );
          },
        ),
      ],
    );
  }

  Future<void> scanAndConnect(BluetoothDevice Device) async {
    if (selectedDevice == Device) {
      printFunc("DEMO");
    }
    printFunc("DEMO IS DEVICE THERE : ${selectedDevice != null}");

    printFunc("BEFORE Device Connected -- $status");

    setState(() {
      status = "Scanning...";
      NotConnected = true;
      connecting = true;
    });

    await requestPermissions();

    printFunc("device present 01 : ${selectedDevice != null}");
    printFunc("device present 02 : ${selectedDevice!.isConnected}");

    // If Device is Present we need to disconnect
    if (selectedDevice != null && selectedDevice!.isConnected) {
      printFunc("device present : ${selectedDevice != null}");
      await disconnect();
    }

    printFunc("device present : ${selectedDevice != null}");
    printFunc("device is null ${selectedDevice}");
    await Future.delayed(Duration(seconds: 5));

    printFunc("DEMO DEVICE : $selectedDevice");

    if (selectedDevice != null) {
      connected = await connectToDevice(selectedDevice!);
      printFunc("DEMO DEVICE IS CONNECTED : $connected");

      if (connected) {
        if (selectedDevice!.isConnected) {
          List<BluetoothService> services =
              await selectedDevice!.discoverServices();
          printFunc("Total Services Found: ${services.length}");
          printFunc("Total Services Found1: ${services}");

          //for printFuncing
          for (var service in services) {
            printFunc("Service UUID: ${service.uuid}");
            for (var characteristic in service.characteristics) {
              printFunc("  Characteristic UUID: ${characteristic.uuid}");
              printFunc("    Properties: ${characteristic.properties}");
            }
          }

          printFunc("Services Found: $services");

          for (var s in services) {
            printFunc(
                "service uuid : ${s.uuid} \nf043176a-5168-11ee-be56-0242ac120012 : ${s.uuid == serviceUUID}");

            if (s.uuid == serviceUUID) {
              printFunc("s.characteristics : ${s.characteristics}");
              for (var c in s.characteristics) {
                printFunc("characteristics c : $c");
                printFunc("UUID");
                printFunc("characteristics UUID : ${c.uuid}");

                if (c.uuid == locateCharUUID) {
                  locateChar = c;
                }
              }
            }
          }
        }

        // Update state when connected successfully
        setState(() {
          status = "Connected";
          NotConnected = false;
          connecting = false; // Stop loading
          deviceName = selectedDevice!.advName;
          connected = true; // Set connected to true
        });

        // Call demo method as requested
        _locateTracker();

        printFunc("After Connected[false] : $connecting");
        return;
      } else {
        // Connection failed
        if (mounted) {
          setState(() {
            NotConnected = false;
            connecting = false; // Stop loading on failure
            connected = false;
          });
        }
        printFunc("Connection Failed!!");
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext contextt) {
              return AlertDialog(
                // title: Text(""),
                content: Text(
                  "Connection Failed!!",
                  style: TextStyle(
                    color: darkBg,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actions: [
                  //OK btn that goes for next page
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                    },
                    child: Text(
                      "Back",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(darkBg),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)))),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      printFunc("selectedDevice : $selectedDevice");
                      // printFunc("DEMO DEMO MACID - ${id}");

                      // if (selectedDevice != null) {
                      //   printFunc("Already device");
                      //   await disconnect();
                      // }

                      // setState(() {
                      //   mac_Id = id;
                      //   selectedDevice = device;
                      //   connecting = true; // Start connecting
                      // });

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext contextt) {
                            return StatefulBuilder(
                              builder: (context, setDialogState) {
                                // Listen to state changes and update dialog
                                return StreamBuilder(
                                  stream: Stream.periodic(
                                      Duration(milliseconds: 100)),
                                  builder: (context, snapshot) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (connecting)
                                            CircularProgressIndicator(
                                              color: darkBg,
                                            ),
                                          if (connecting) SizedBox(height: 8),
                                          if (connecting)
                                            Text(
                                              "Connecting...",
                                              style: TextStyle(color: darkBg),
                                            ),
                                          if (connected && !connecting)
                                            Image.asset(
                                              'assets/image/alarm.gif',
                                              width: 80,
                                              height: 80,
                                            ),
                                          if (connected && !connecting)
                                            SizedBox(height: 8),
                                          if (connected && !connecting)
                                            Text(
                                              "Buzzing . . .",
                                              style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          });

                      scanAndConnect(selectedDevice!);

                      printFunc("Demo mac_Id : $mac_Id");
                    },
                    child: Text(
                      "Re-Try",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(darkBg),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)))),
                  ),

                ],
                backgroundColor: second_lightBg,
              );
            });
      }
    } else {
      // Device not found
      if (mounted) {
        setState(() {
          NotConnected = false;
          connecting = false; // Stop loading when device not found
          connected = false;
        });
      }
      printFunc("DEVICE NOT FOUND in else Cond");
      await FlutterBluePlus.stopScan();

      printFunc("Device not found");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          "Device not found",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
    }

    printFunc("DEMO STReet : $NotConnected");
    if (mounted) {
      setState(() {
        NotConnected = false;
        connecting = false; // Ensure loading stops
      });
    }
    printFunc("DEMO STReet1 : $NotConnected");
  }

  Future<void> disconnect() async {
    if (selectedDevice != null) {
      await selectedDevice!.disconnect();
      if (mounted) {
        setState(() {
          status = "Disconnected";
          deviceName = "-";
          NotConnected = false;
          connected = false;
          connecting = false;
        });
      }
    }

    printFunc("${mac_Id} is disconnected");
  }

  Future<void> _locateTracker() async {
    try {
      if (locateChar == null) {
        ShowSnackBarMessage(context, 'Device not properly connected', false);
        disconnect();
        Navigator.of(context).pop();
        return;
      }

      // Convert string to bytes (same as your HTML code)
      String command = 'locate';
      List<int> commandBytes = utf8.encode(command);

      // Send the locate command
      await locateChar!.write(commandBytes);

      printFunc('Locate command sent: "$command"');

      Future.delayed(Duration(seconds: 3), () {
        disconnect();
        Navigator.of(context).pop();
      });
    } catch (e) {
      printFunc('Failed to send Locate Tracker command: $e');
    }
  }

  @override
  void dispose() {
    scanSub?.cancel();
    super.dispose();
  }
}