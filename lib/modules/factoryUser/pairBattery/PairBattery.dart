import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/api/getBatteryByMac.dart';
import 'package:tracker_firmware/modules/factoryUser/api/pairBattery.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/qr_code.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/Methods/scanAndconnect.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class PairBattery extends StatefulWidget {
  const PairBattery({super.key});

  @override
  State<PairBattery> createState() => _PairBatteryState();
}

class _PairBatteryState extends State<PairBattery> {
  //controllers for barcode and qr code
  TextEditingController _macIdController = new TextEditingController();
  TextEditingController _batteryController = new TextEditingController();

  //for barcode
  bool enableBarCode = false;

  //for validation
  bool validateFields = false;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Battery Pairing",
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
      body: SingleChildScrollView(
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
                "PAIR DEVICE WITH BATTERY",
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


                                enableBarCode
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
                                    :ElevatedButton(
                                  onPressed: enableSubmit
                                      ? () {}
                                      : () async {
                                    validateField();
                                    !validateFields;

                                    // await scanAndConnect();

                                    setState(() {});
                                  },
                                  child: (device != null && device!.isConnected)
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
                                : SizedBox(),



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
                                      onChanged: (value) {},
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
                                Visibility(
                                    visible: !enableBarCode,
                                    child: Container(
                                      width: screenSize.width / 3,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              darkBg),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20))),
                                        ),
                                        onPressed: () async {
                                          validateField();
                                          result = await getBatteryByMac(
                                              context,
                                              macID: _macIdController.text);
                                          bool batteryAvailable = result[0];
                                          Map<String, dynamic> batteryDetail =
                                          result[1];

                                          printFunc(
                                              "Demo battery details : ${batteryAvailable} \n ${batteryDetail}");

                                          if (batteryAvailable &&
                                              batteryDetail.isNotEmpty) {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Column(
                                                      children: [
                                                        Text(
                                                          "BATTERY FOUND",
                                                          style: TextStyle(
                                                              color: darkBg,
                                                              fontSize: 24,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w800,
                                                              shadows: [
                                                                Shadow(
                                                                    color: Colors
                                                                        .black,
                                                                    blurRadius:
                                                                    0.4)
                                                              ]),
                                                        ),
                                                        Divider(
                                                          color: darkBg,
                                                          thickness: 0.5,
                                                        )
                                                      ],
                                                    ),
                                                    content: Text(
                                                        "This Device is Paired with this ${batteryDetail['batterySerialNumber']} Battery. Do you want too?"),
                                                    actions: [
                                                      //Continue btn
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          //Go back
                                                          enableBarCode = true;
                                                          setState(() {
                                                            _batteryController.text = batteryDetail['batterySerialNumber'];
                                                          });
                                                          Navigator.of(context)
                                                              .pop(); //Save Log API

                                                        },
                                                        child: Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                darkBg),
                                                            shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        18)))),
                                                      ),
                                                      //Assign new Btn
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          enableBarCode = true;
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                          "Assign New",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                darkBg),
                                                            shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        18)))),
                                                      )
                                                    ],
                                                  );
                                                });
                                          } else if (batteryAvailable &&
                                              batteryDetail.isEmpty) {
                                            enableBarCode = true;
                                            ShowSnackBarMessage(context,
                                                'No Battery is Paired!', true);
                                            setState(() {});
                                          } else if(!batteryAvailable){
                                            enableBarCode = false;
                                            // ShowSnackBarMessage(context, 'No MacID found!', false);
                                            _macIdController.clear();
                                            setState(() {});
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.search),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Search",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  shadows: [
                                                    Shadow(color: Colors.black)
                                                  ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                    //BAR CODE
                    enableBarCode
                        ? Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "BATTERY NUMBER",
                                    style: TextStyle(
                                        color: darkBg,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 0.3)
                                        ]),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: darkBg),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRScannerScreen(title: "Scan Barcode"),
                                                ),
                                              );


                                              printFunc("DEMO RESULT : ${result.replaceAll("-","")}");

                                              if (result != null) {
                                                setState(() {
                                                  _batteryController.text =
                                                      result.replaceAll("-","");
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  30, 15, 30, 5),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border:
                                                    Border.all(color: darkBg),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                          CupertinoIcons
                                                              .barcode,
                                                          size: 35,
                                                          color: darkBg,
                                                          shadows: [
                                                            Shadow(
                                                                color: Colors
                                                                    .black,
                                                                blurRadius: 0.4)
                                                          ]),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Scan Barcode",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: darkBg,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            shadows: [
                                                              Shadow(
                                                                  color: Colors
                                                                      .black,
                                                                  blurRadius:
                                                                      0.4)
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    CupertinoIcons
                                                        .chevron_right_2,
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
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                height: 1,
                                                color: Colors.black,
                                              )),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Text(
                                                  "OR",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 30),
                                                height: 1,
                                                color: Colors.black,
                                              )),
                                            ],
                                          ),
                                          TextFeildNewUser(
                                            hintText:
                                                "Enter Battery Serial Number",
                                            Controller: _batteryController,
                                            type: TextInputType.number,
                                            onChanged: (value) {},
                                            enable: true,
                                            // etext: validateFields
                                            //     ? "Please Enter Battery Serial number"
                                            //     : "",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: screenSize.width / 3,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: NotConnected
                                          ? MaterialStateProperty.all<Color>(
                                            Color(0xFF358A94).withOpacity(0.4))
                                            : MaterialStateProperty.all<Color>(
                                                darkBg),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                      ),
                                      onPressed: () async {
                                        //After this everything goes to the server
                                        validateField();
                                        printFunc(
                                            "MacID : ${_macIdController.text} \n Battery SErial number : ${_batteryController.text}");
                                        if (!validateFields) {
                                          await scanAndConnect();
                                          isBatterySnoSent = await sendBatterySerialNumber(_batteryController.text.toString());
                                          if(isBatterySnoSent){
                                            disconnect();
                                            await saveMacandBattery(context,
                                                macId: _macIdController.text,
                                                BatterySerialNo:
                                                _batteryController.text);
                                            _batteryController.clear();
                                            _macIdController.clear();
                                            enableBarCode = false;
                                            validateFields = false;

                                            setState(() {});
                                            // Navigator.popUntil(context, (route) => route.isFirst);
                                          }
                                          else{
                                            // _batteryController.clear();
                                            // _macIdController.clear();
                                            // enableBarCode = false;
                                            // validateFields = false;
                                            await disconnect();
                                            setState(() {});
                                          }
                                        }
                                        if(mounted){

                                          setState(() {});
                                        }
                                      },
                                      child: Text(
                                        "SUBMIT",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            shadows: [
                                              Shadow(color: Colors.black)
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  void validateField() {
    final Controllers = [_macIdController, _batteryController];
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
    print("BEFORe Device Connected -- $status");

    setState(() {
      status = "Scanning...";
      NotConnected = true;
    });


    print("Found Old macid: ${_macIdController.text}");
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
          print("Total Services Found: ${services.length}");
          print("Total Services Found1: ${services}");

          //for Printing
          for (var service in services) {
            print("Service UUID: ${service.uuid}");
            for (var characteristic in service.characteristics) {
              print("  Characteristic UUID: ${characteristic.uuid}");
              print("    Properties: ${characteristic.properties}");
            }
          }

          print("Services Found: $services");

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
                if (c.uuid == calibrationCharUUID) calibrationChar = c;
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

  Future<bool> sendBatterySerialNumber(String batterySerialCtrl) async {

    if (configChar == null) {
      printFunc("DEMODEMODMEOM configChar : $configChar");
      printFunc("Characteristic is null, can't send battery serial number.");
      return false;
    }

    try {
      int batterySerial = int.parse(batterySerialCtrl.trim());

      // if (batterySerial < 0 || batterySerial > 99) {
      //   printFunc("Battery Serial Number out of bounds: $batterySerial");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Battery Serial Number must be between 0 and 99")),
      //   );
      //   return false;
      // }

      // Create 5-byte packet
      List<int> data = List.filled(5, 0);
      data[0] = '{'.codeUnitAt(0);
      data[1] = 'B'.codeUnitAt(0);
      data[2] = batterySerial & 0xFF;
      data[3] = (batterySerial >> 8) & 0xFF;
      data[4] = '}'.codeUnitAt(0);

      printFunc("Battery Config packet: $data");

      await configChar!.write(data);
      printFunc("Battery Serial Number sent successfully");
      return true;
    } catch (e) {
      printFunc("Failed to send Battery Serial Number: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid Battery Serial Number: $e")),
      );
      return false;
    }
  }


  @override
  void dispose() {
    _macIdController.dispose();
    _batteryController.dispose();
    super.dispose();
  }
}

//barcode cutting process
/*
* String barcodeResult = result;
                                                  String code = barcodeResult
                                                      .split('\n')
                                                      .firstWhere(
                                                          (line) =>
                                                              line.startsWith(
                                                                  'Code:'),
                                                          orElse: () => '')
                                                      .replaceFirst(
                                                          'Code: ', '');*/
