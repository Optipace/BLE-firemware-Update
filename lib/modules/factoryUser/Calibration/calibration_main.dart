import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/qr_code.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/Methods/scanAndconnect.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/internetStatusWatcher.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class CalibrateDevice extends StatefulWidget {
  const CalibrateDevice({super.key});

  @override
  State<CalibrateDevice> createState() => _CalibrateDeviceState();
}

class _CalibrateDeviceState extends State<CalibrateDevice> {
  //controllers for barcode and qr code
  TextEditingController _macIdController = new TextEditingController();


  //for validation
  bool validateFields = false;
  bool enableConnect = false;

  List result = [];

// For Bluetooth Device
  final flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? configChar;
  BluetoothCharacteristic? thresholdChar;
  BluetoothCharacteristic? calibrationChar;

  final serviceUUID = Guid("f043176a-5168-11ee-be56-0242ac120012");
  final configCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120014");
  final thresholdCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120016");
  final calibrationCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120017");

  bool NotConnected = false;
  bool enableSubmit = false;
  bool connect = false;
  String status = "Disconnected";
  String deviceName = "-";

  bool connected = false;
  bool enablePopUp = false;
  bool isBatterySnoSent = false;


  //For calibration
  int calibrationStep = 0;
  bool waitingForAck = false;

  bool isDeviceConnected = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Calibration",
          style: TextStyle(
              fontFamily: baseFont,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: lightBg),
        ),
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: lightBg,
      body: InternetStatusWatcher(
        child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: darkBg),
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(15)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      "Enter or Scan MAC-ID",
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
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: darkBg),
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //QR CODE
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 15,right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "MAC-ID  ",
                                        style: TextStyle(
                                            color: darkBg,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            shadows: [
                                              Shadow(color: Colors.black, blurRadius: 0.3)
                                            ]),
                                      ),


                                      enableConnect
                                      ? NotConnected
                                          ? Container(
                                        color: Colors.transparent,
                                        height: 25,
                                        width: 25,
                                        child:  Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.grey),
                                          ),
                                        ),
                                      )
                                          : ElevatedButton(
                                        onPressed: (device != null && device!.isConnected)
                                            ? () {}
                                            : () async {
                                          //After this everything goes to the server
                                          validateField();
                                          !validateFields;
                                          if (!validateFields) {
                                            await scanAndConnect();

                                          }
                                          if(mounted){

                                            setState(() {});
                                          }
                                        },
                                        child: (device != null && device!.isConnected )
                                            ? Text("Connected")
                                            : Text("Connect"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(darkBg),
                                          elevation: MaterialStateProperty.all(5),
                                          shadowColor:
                                          MaterialStateProperty.all(darkBg),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: darkBg, width: 1)),
                                          ),
                                        ),
                                      )
                                      : SizedBox()




                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: darkBg),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRScannerScreen(title: "Scan QR-Code"),
                                                ),
                                              );
                                              if (result != null) {
                                                setState(() {
                                                  _macIdController.text = result;
                                                  enableConnect = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin:
                                              EdgeInsets.fromLTRB(30, 15, 30, 5),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: darkBg),
                                                borderRadius:
                                                BorderRadius.circular(15),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(CupertinoIcons.qrcode,
                                                          size: 35,
                                                          color: darkBg,
                                                          shadows: [
                                                            Shadow(
                                                                color: Colors.black,
                                                                blurRadius: 0.4)
                                                          ]),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Scan QR-Code",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: darkBg,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            shadows: [
                                                              Shadow(
                                                                  color: Colors.black,
                                                                  blurRadius: 0.4)
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    CupertinoIcons.chevron_right_2,
                                                    color: darkBg,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 0.4)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 30),
                                                    height: 1,
                                                    color: Colors.black,
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Text(
                                                  "OR",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: 30),
                                                    height: 1,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                          TextFeildNewUser(
                                            hintText: "Enter the MacID",
                                            Controller: _macIdController,
                                            onChanged: (value) {
                                              setState(() {
                                                enableConnect = true;
                                              });
                                            },
                                            enable: true,
                                            etext: validateFields &&
                                                _macIdController.text
                                                    .trim()
                                                    .isEmpty
                                                ? "Please Enter MAC-Id"
                                                : "",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),



                          (device != null && device!.isConnected)
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, top: 15),
                                child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      enableConnect = false;
                                    });
                                    _macIdController.clear();
                                    disconnect();

                                    },
                                  style: ButtonStyle(
                                    backgroundColor: isDeviceConnected
                                        ? MaterialStateProperty.all(darkBg)
                                        : MaterialStateProperty.all(darkBg.withOpacity(0.4)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          side: BorderSide(color: darkBg, width: 1)),
                                    ),
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: screenSize.width / 3.5,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "Disconnect",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: baseFont,
                                          shadows: [
                                            Shadow(color: Colors.black, blurRadius: 0.1)
                                          ],
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Handle Calibration Btn
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, top: 15),
                                child: ElevatedButton(
                                  onPressed: isDeviceConnected
                                      ? () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext contextt) {
                                          return AlertDialog(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                            insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                                            backgroundColor: second_lightBg,
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min, // keeps dialog compact
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Title
                                                  Center(
                                                    child: Text(
                                                      "Calibration",
                                                      style: TextStyle(
                                                        color: darkBg,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: baseFont,
                                                        fontSize: 20,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 0.5,
                                                            offset: Offset(0.5, 0.5),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //divider
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Divider(color: darkBg,),
                                                      SizedBox(height: 10),
                                                    ],
                                                  ),

                                                  // Send Config Button
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: darkBg
                                                          ),
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: darkBg,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            _showInputDialog(
                                                                Alertcontext: context,
                                                                title: "Vmax for Calibration",
                                                                hint: "e.g. 4200",
                                                                onSubmit: sendVmax,
                                                                afterText: "Calibrating Vmax...",
                                                                labelText: "Enter Vmax(mV)"
                                                            );


                                                          },
                                                          child: Text(
                                                            "Voltage\nCalibration",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w500
                                                            ),
                                                            textAlign: TextAlign.center,

                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: darkBg
                                                          ),
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: darkBg,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            _showInputDialog(
                                                                Alertcontext: context,
                                                                title: "Temperature for Calibration",
                                                                hint: "e.g. 25000",
                                                                onSubmit: sendTemperature,
                                                                labelText: "Enter Temperature",
                                                                afterText: "Calibrating Temp..."
                                                            );
                                                          },
                                                          child: Text(
                                                            "Temperature\nCalibration",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w500
                                                            ),
                                                            textAlign: TextAlign.center,

                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                                  ),
                                                ),
                                                child: Text("Cancel", style: TextStyle(fontSize: 16)),
                                              ),

                                            ],
                                          );

                                        });
                                  }
                                      : (){
                                    printFunc("Not Connected");
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: isDeviceConnected
                                        ? MaterialStateProperty.all(darkBg)
                                        : MaterialStateProperty.all(darkBg.withOpacity(0.4)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          side: BorderSide(color: darkBg, width: 1)),
                                    ),
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: screenSize.width / 3.5,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "Calibration",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: isDeviceConnected
                                              ? Colors.white
                                              : Color(0xFFEEEEEE),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: baseFont,
                                          shadows: [
                                            Shadow(color: Colors.black, blurRadius: 0.1)
                                          ],
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : SizedBox(height: 20,),


                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void validateField() {
    final Controllers = [_macIdController, ];
    bool hasEmpty =
    Controllers.any((controller) => controller.text.trim().isEmpty);
    setState(() {
      validateFields = hasEmpty;
    });
  }

  Future<void> requestPermissions() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothAdvertise.request();
  }

  Future<void> scanAndConnect() async {
    if(_macIdController.text.isNotEmpty){
      printFunc("BEFORe Device Connected -- $status");

      setState(() {
        status = "Scanning...";
        NotConnected = true;
      });


      printFunc("Found Old macid: ${_macIdController.text}");
      await requestPermissions();

      printFunc("device present : ${device != null}");

      // If Device is Present we need to disconnect
      if (device != null && device!.isConnected) {
        printFunc("device present : ${device != null}");
        await disconnect();
      }

      printFunc("device present : ${device != null}");
      await Future.delayed(Duration(seconds: 5));

      //Scanning the device and returing
      device = await scanDeviceByMACId(_macIdController.text);
      printFunc( "DEMO DEVICE : $device");

      if (device != null) {
        connected = await connectToDevice(device!);
        printFunc("DEMO DEVICE IS CONNECTED : $connected");
        if (connected) {
          if (device!.isConnected) {
            List<BluetoothService> services = await device!.discoverServices();
            printFunc("Total Services Found: ${services.length}");
            printFunc("Total Services Found1: ${services}");

            //for Printing
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

                  if (c.uuid == configCharUUID) configChar = c;
                  if (c.uuid == thresholdCharUUID) thresholdChar = c;
                  if (c.uuid == calibrationCharUUID) {
                    calibrationChar = c;
                    await calibrationChar!.setNotifyValue(true);
                    calibrationChar!.value.listen(_handleAck);
                  }
                }
              }
            }
          }
          setState(() {
            status = "Connected";
            NotConnected = false;
            enableSubmit = true;
            enablePopUp = true;
            connect = true;
            deviceName = device!.advName;
          });
          printFunc("DEmo is device Connected enableSubmit: $enableSubmit \n NotConnected :  $NotConnected  ");

          printFunc("charterstics : configChar : $configChar");
          return;
        } else {
          if(mounted){
            setState(() {
              NotConnected = false;
            });
          }
          printFunc("Connection Failed!!");

          showDialog(context: context, builder: (BuildContext contextt) {
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
                  onPressed: (){
                    Navigator.of(context).pop();
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
                )
              ],
              backgroundColor: second_lightBg,
            );
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text("Connection Failed, Try to Re-Submit", style: TextStyle(color: Colors.white)),
          //       backgroundColor: Colors.redAccent,
          //       duration: Duration(seconds: 3),
          //
          // ));

        }
      }
      else {
        if(mounted){
          setState(() {NotConnected = false;});
        }
        printFunc("DEVICE NOT FOund in else Cond");
        await FlutterBluePlus.stopScan();
        printFunc("${_macIdController.text} is not found");


        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Device not found",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ));
      }

      printFunc("DEMO STReet : $NotConnected");
      if(mounted){
        setState(() {NotConnected = false;});
      }
      printFunc("DEMO STReet1 : $NotConnected");
    }
  }

  Future<void> disconnect() async {
    if (device != null) {
      await device!.disconnect();
      if(mounted){
        setState(() {
          status = "Disconnected";
          deviceName = "-";
          NotConnected = false;
        });
      }
    }
    await Future.delayed(Duration(seconds: 2));

    printFunc("${_macIdController.text} is disconnected");
  }

  void _handleAck(List<int> data) {
    String ack = String.fromCharCodes(data);
    printFunc(" Received ACK from device: $ack");

    if (calibrationStep == 0 && ack.contains("ACK_VMAX")) {
      if(mounted){
        setState(() {
          calibrationStep = 1;
          waitingForAck = false;
        });
        Navigator.of(context, rootNavigator: true).pop();
        ShowSnackBarMessage(context, 'Voltage_max sent for Calibration', true);
        Future.delayed(const Duration(milliseconds: 300), () {
          _showInputDialog(
              Alertcontext: context,
              title: "Vmin for Calibration",
              hint: "e.g. 3200",
              onSubmit: sendVmin,
              labelText: "Enter Vmin (mV)",
              afterText: "Calibrating Vmin..."
          );
        });
      }
      // Open Vmin popup
    } else if (calibrationStep == 1 && ack.contains("ACK_VMIN")) {
      printFunc(" Vmin accepted, waiting for COMPLETE...");
    } else if (calibrationStep == 1 && ack.contains("ACK_COMPLETE")) {
      printFunc(" Voltage Calibration Completed!");
      ShowSnackBarMessage(context, 'Voltage Calibration Completed!', true);
      if(mounted){
        setState(() {
          calibrationStep = 0;
          waitingForAck = false;
        });
      }
      Navigator.of(context, rootNavigator: true).pop();
    } else if (calibrationStep == 2 && ack.contains("ACK_TEMP")) {
      printFunc("Temperature Calibration Completed!");
      ShowSnackBarMessage(context, 'Temperature Calibration Completed!', true);
      setState(() {
        calibrationStep = 0;
        waitingForAck = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
      printFunc("Temperature Calibration Completed!");
    }
  }

  Future<void> _showInputDialog({
    required BuildContext Alertcontext,
    required String title,
    required String hint,
    required String afterText,
    required String labelText,
    required Function(int) onSubmit,
  }) async {
    final TextEditingController inputCtrl = TextEditingController();
    bool error = false;


    return showDialog(
      context: Alertcontext,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkBg,
                fontWeight: FontWeight.w700,
                fontSize: 18,

              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Divider(color: darkBg,),
                    SizedBox(height: 10),
                  ],
                ),

                if (!waitingForAck) Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(labelText,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: darkBg,
                            fontFamily: baseFont,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 0.2,
                                // offset: Offset(0.5, 0.5)
                              )
                            ])),
                  ),
                ),
                if (!waitingForAck) Container(
                  height: 60,
                  width: screenSize.width,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Center(
                    child: TextField(
                        cursorWidth: 1,
                        style: TextStyle(
                            fontSize: 18,
                            color:  darkBg,
                            fontWeight: FontWeight.w500,
                            fontFamily: baseFont,
                            letterSpacing: 0.2),
                        controller: inputCtrl,
                        cursorColor: darkBg,
                        keyboardType: TextInputType.number,
                        enabled: !waitingForAck,
                        // validator: validator,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: darkBg, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(width: 1, color: darkBg )),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                BorderSide(width: 1, color:  Colors.black )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                BorderSide(width: 1, color: Colors.black )),
                            hintText: hint,
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF9AC4C9),
                                fontFamily: baseFont,
                                fontWeight: FontWeight.w400),

                            counterText: "")),
                  ),
                ),
                // const SizedBox(height: 10),
                if (waitingForAck)  CircularProgressIndicator(color: darkBg,),
                if (waitingForAck)  SizedBox(height: 8),
                if (waitingForAck)  Text(afterText,style: TextStyle(color: darkBg),),
              ],
            ),
            actions: [
              if (!waitingForAck)
                ElevatedButton(
                  onPressed: () {
                    final val = int.tryParse(inputCtrl.text);
                    if (val != null) {
                      onSubmit(val);
                      setState(() {
                        waitingForAck = true;
                      });
                      setStateDialog(() {});
                    } else {
                      printFunc(" Invalid input");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(darkBg),

                  ),
                  child: const Text("Send"),
                ),
            ],
          );
        });
      },
    );
  }

  Future<bool> sendVmax(int vmax) async {
    final packet = Uint8List.fromList([
      '['.codeUnitAt(0),
      'V'.codeUnitAt(0),
      vmax & 0xFF,
      (vmax >> 8) & 0xFF,
      ']'.codeUnitAt(0),
    ]);
    printFunc("Sending Vmax: $vmax, Packet: $packet");
    try {
      await calibrationChar!.write(packet, withoutResponse: false);
      setState(() => waitingForAck = true);
      return true;
    } catch (e) {
      printFunc("Exception at Vmax : $e");
      return false;
    }
  }

  Future<bool> sendVmin(int vmin) async {
    final packet = Uint8List.fromList([
      '['.codeUnitAt(0),
      'V'.codeUnitAt(0),
      vmin & 0xFF,
      (vmin >> 8) & 0xFF,
      ']'.codeUnitAt(0),
    ]);
    printFunc(" Sending Vmin: $vmin, Packet: $packet");
    try {
      await calibrationChar!.write(packet, withoutResponse: false);
      setState(() => waitingForAck = true);
      return true;
    } catch (e) {
      printFunc("Excpetion in VMin : $e");
      return false;
    }
  }

  Future<bool> sendTemperature(int temp) async {
    final packet = Uint8List.fromList([
      '['.codeUnitAt(0),
      'T'.codeUnitAt(0),
      temp & 0xFF,
      (temp >> 8) & 0xFF,
      ']'.codeUnitAt(0),
    ]);
    printFunc("Sending Temp: $temp, Packet: $packet");
    try {
      await calibrationChar!.write(packet, withoutResponse: false);
      setState(() {
        waitingForAck = true;
        calibrationStep = 2;
      });
      return true;
    } catch (e) {
      printFunc("Exception on Temp : $e");
      return false;
    }
  }


  @override
  void dispose() {
    _macIdController.dispose();
    super.dispose();
  }
}