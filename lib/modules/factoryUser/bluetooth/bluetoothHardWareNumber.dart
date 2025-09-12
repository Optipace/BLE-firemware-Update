import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/getNumberModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/api/getProductIdByMac.dart';
import 'package:tracker_firmware/modules/factoryUser/api/saveHardware.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/Methods/scanAndconnect.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/CustomCard.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';
import 'package:tracker_firmware/widgets/internetStatusWatcher.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class BluetoothHardwareNumber extends StatefulWidget {
  final DataController? SelectedBatch;
  final Map<String, dynamic>? allclients;
  final String? macID;
  BuildContext? safecontext;

  BluetoothHardwareNumber(
      {required safecontext,
      super.key,
      this.SelectedBatch,
      this.allclients,
      this.macID});

  @override
  State<BluetoothHardwareNumber> createState() =>
      BluetoothHardwareNumberState();
}

class BluetoothHardwareNumberState extends State<BluetoothHardwareNumber> {
  // For Current Date
  DateTime now = DateTime.now();

  bool _initialNetworkCheckDone = false;
  bool _isPidLoading = false;


  //Hardware number and Client Details
  Map<String, dynamic> HardWareMap = {};
  List<Map<String, dynamic>> allClients = [{}];
  DataController HardWareNumber = DataController();
  DataController ClientName = DataController();

  //Controllers
  TextEditingController batchName = new TextEditingController();
  TextEditingController firmWareName = new TextEditingController();
  TextEditingController configName = new TextEditingController();

  bool _validateDropDown = false;
  bool _added = false;

  List result = [];

  bool NotConnected = false;
  bool enableSubmit = false;

  // New flags for connection
  bool isDeviceConnected = false;
  bool isScanning = false;
  bool deviceNotFoundError = false;
  bool connectionFailedError = false;

  //Controllers and variables for device bluetooth
  final flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? configChar;
  BluetoothCharacteristic? thresholdChar;
  BluetoothCharacteristic? calibrationChar;

  final serviceUUID = Guid("f043176a-5168-11ee-be56-0242ac120012");
  final configCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120014");
  final thresholdCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120016");
  final calibrationCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120017");

  //For calibration
  int calibrationStep = 0; // 0 = Vmax, 1 = Vmin, 2 = Temp
  bool waitingForAck = false;

  // Controllers
  final batteryTypeCtrl = TextEditingController(); //profile [deviceType]
  final dateCtrl = TextEditingController(); //current Date
  final serialCtrl = TextEditingController(); //10 serial number
  final custIdCtrl = TextEditingController(); //
  final productIdCtrl = TextEditingController(); //constant
  final chemistryTypeCtrl = TextEditingController(); //constant
  final maxVoltageCtrl = TextEditingController(); //config[mv]
  final maxThresholdCtrl = TextEditingController(); //config[mt]
  final minThresholdCtrl = TextEditingController(); //config[lt]
  final minVoltageCtrl = TextEditingController(); //config[lv]
  final nominalVoltageCtrl = TextEditingController(); //hardcode
  final minTempCtrl = TextEditingController(); //hardcode
  final maxTempCtrl = TextEditingController(); //hardcode
  final tempCalibCtrl = TextEditingController(); //hardcode

  String status = "Disconnected";
  String deviceName = "-";

  int batteryFactor = 1;

  //bool for sending things
  bool isConfigSent = true;
  bool isVoltSent = true;
  bool isTempSent = true;

  //flag for Disconnect
  bool enableDisconnect = false;

  BuildContext? alertContext;

  String? fullSerial;

  Timer? timeoutTimer;

  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    generateHardWareMap();

    printFunc("_initialNetworkCheckDone 01 -- ${_initialNetworkCheckDone}");
    InternetStatus.isOnline.addListener(_onInternetChange);
    printFunc("InternetStatus.isOnline 01 - ${InternetStatus.isOnline.value}");
    printFunc("_initialNetworkCheckDone 01 -- ${_initialNetworkCheckDone}");

    if(InternetStatus.isOnline.value == false){
      setState(() {
        isOffline = true;
      });
    }else{
      PIDforFactoryUser();
      scanAndConnect();
    }


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(!isOffline) {
        // PIDforFactoryUser();
        // await scanAndConnect();
      }else{
        printFunc("OFFLINE");
      }
    });
    setState(() {
      batteryTypeCtrl.text =
          widget.SelectedBatch?.obj['battery']['batteryCode'];
      dateCtrl.text = DateFormat('yyyy-MM-dd').format(now);
      HardWareNumber.getText.toString();
      custIdCtrl.text = "1";
      productIdCtrl.text = "4637";
      chemistryTypeCtrl.text = "03";
      "Li-ion";
      maxVoltageCtrl.text = widget.SelectedBatch?.obj['profile']['uV'];
      maxThresholdCtrl.text = widget.SelectedBatch?.obj['profile']['uT'];
      minThresholdCtrl.text = widget.SelectedBatch?.obj['profile']['lT'];
      minVoltageCtrl.text = widget.SelectedBatch?.obj['profile']['lV'];
      nominalVoltageCtrl.text = widget.SelectedBatch?.obj['profile']['nV'];
      minTempCtrl.text = widget.SelectedBatch?.obj['profile']['lTemp'];
      maxTempCtrl.text = widget.SelectedBatch?.obj['profile']['uTemp'];
      tempCalibCtrl.text = "13";
    });

    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> _onWillPop() async {
    await disconnect();
    return true;
  }

  void resetConnectionFlags() {
    setState(() {
      deviceNotFoundError = false;
      connectionFailedError = false;
      isDeviceConnected = false;
      isScanning = false;
      NotConnected = false;
      enableSubmit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    chemistryTypeCtrl.text = "03";
    "Li-ion";
    batchName.text = widget.SelectedBatch?.obj['name'];
    firmWareName.text = widget.SelectedBatch?.obj['firmware']['versionName'];
    configName.text = widget.SelectedBatch?.obj['profile']['name'];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Adding",
            style: TextStyle(
                fontFamily: baseFont,
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: lightBg),
          ),
          toolbarHeight: screenSize.height / 13,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        body: Center(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
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
                        padding: EdgeInsets.only(top: 15, left: 25, right: 25),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "DETAILS ",
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
                              isScanning
                                  ? Container(
                                color: second_lightBg,
                                height: 25,
                                width: 25,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
                                  ),
                                ),
                              )
                                  : ElevatedButton(
                                onPressed: !isOffline
                                    ? isDeviceConnected
                                    ? () async {
                                  await disconnect();
                                }
                                    : () async {
                                  printFunc("NETWORK IS THEIR : $isOffline");
                                  resetConnectionFlags();
                                  PIDforFactoryUser();
                                  await scanAndConnect();
                                }
                                    : null,
                                child: Text(isDeviceConnected
                                    ? "Connected"
                                    : "Connect"),
                                style: ButtonStyle(
                                  backgroundColor:
                                  !isOffline
                                      ? MaterialStateProperty.all(darkBg)
                                      : MaterialStateProperty.all(Color(0xFFB0BEC5)),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              const LabelText(text: "Batch Name :"),
                              TextFeildNewUser(
                                hintText: batchName.text,
                                Controller: batchName,
                                onChanged: (value) {},
                                enable: false,
                              ),
                              SizedBox(height: 10),
                              const LabelText(text: "FirmWare Name :"),
                              TextFeildNewUser(
                                hintText: firmWareName.text,
                                Controller: firmWareName,
                                onChanged: (value) {},
                                enable: false,
                              ),
                              SizedBox(height: 10),
                              const LabelText(text: "Config Name :"),
                              TextFeildNewUser(
                                hintText: configName.text,
                                Controller: configName,
                                onChanged: (value) {},
                                enable: false,
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                child: PrimeryDropDownButton(
                                  isEnabled: false,
                                  tail: ErrorContainer(
                                      show: _validateDropDown &&
                                          HardWareNumber.getText == "",
                                      errorMsg:
                                      "Please Select the HardWare Number"),
                                  mainText: "Select Tracker Serial Number",
                                  text: HardWareNumber.Text != ""
                                      ? HardWareNumber.getText
                                      : "Tracker Serial Number",
                                  press: () async {
                                    await BottomSheet_Widget(context, [
                                      MapListItemBuilder(
                                          listItems: HardWareMap,
                                          press: () {
                                            printFunc(
                                                "Demo datacontroller - ${HardWareNumber.getText}");
                                          },
                                          selected: HardWareNumber)
                                    ]);
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          )),

                      //BTNS [Configure, Calibration, Submit]
                      isDeviceConnected
                          ? Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                EdgeInsets.only(bottom: 10, top: 15),
                                child: ElevatedButton(
                                  onPressed: isDeviceConnected
                                      ? enableDisconnect
                                      ? () async {
                                    await disconnect();
                                    if (mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                      : () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext
                                        contextt) {
                                          return AlertDialog(
                                            contentPadding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                20,
                                                vertical: 16),
                                            insetPadding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                40,
                                                vertical: 24),
                                            backgroundColor:
                                            second_lightBg,
                                            content:
                                            SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize
                                                    .min,
                                                // keeps dialog compact
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  // Title
                                                  Center(
                                                    child: Text(
                                                      "Configure Details",
                                                      style:
                                                      TextStyle(
                                                        color:
                                                        darkBg,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        fontFamily:
                                                        baseFont,
                                                        fontSize:
                                                        20,
                                                        shadows: [
                                                          Shadow(
                                                            color:
                                                            Colors.black,
                                                            blurRadius:
                                                            0.5,
                                                            offset: Offset(
                                                                0.5,
                                                                0.5),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: 15),

                                                  //Battery Section
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Battery Details",
                                                        style:
                                                        TextStyle(
                                                          color:
                                                          darkBg,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontFamily:
                                                          baseFont,
                                                          fontSize:
                                                          16,
                                                          shadows: [
                                                            Shadow(
                                                              color:
                                                              Colors.black,
                                                              blurRadius:
                                                              0.5,
                                                              offset:
                                                              Offset(0.5, 0.5),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                          5),
                                                      const Expanded(
                                                          child: Divider(
                                                              color:
                                                              Colors.black26,
                                                              thickness: 1)),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 6),
                                                  Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          "Battery",
                                                          style: TextStyle(
                                                              color:
                                                              darkBg,
                                                              fontWeight: FontWeight.w500,
                                                              shadows: [
                                                                Shadow(color: Colors.black, blurRadius: 0.5)
                                                              ]),
                                                        ),
                                                        Text(
                                                          widget.SelectedBatch?.getobj['battery']['batteryName'] ??
                                                              "",
                                                          style: TextStyle(
                                                              color:
                                                              darkBg,
                                                              fontWeight: FontWeight.w500,
                                                              shadows: [
                                                                Shadow(color: Colors.black, blurRadius: 0.5)
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: 12),

                                                  // Voltage Section
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Voltage Details",
                                                        style:
                                                        TextStyle(
                                                          color:
                                                          darkBg,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontFamily:
                                                          baseFont,
                                                          fontSize:
                                                          16,
                                                          shadows: [
                                                            Shadow(
                                                              color:
                                                              Colors.black,
                                                              blurRadius:
                                                              0.5,
                                                              offset:
                                                              Offset(0.5, 0.5),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                          5),
                                                      const Expanded(
                                                          child: Divider(
                                                              color:
                                                              Colors.black26,
                                                              thickness: 1)),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 5),
                                                  Table(
                                                    defaultColumnWidth:
                                                    const FlexColumnWidth(),
                                                    children: [
                                                      TableRow(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  6,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    "U-Volt",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  6,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    "L-Volt",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  6,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    "N-Volt",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                          ]),
                                                      TableRow(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  3,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    widget.SelectedBatch?.getobj['profile']['uV'] ?? "",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  3,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    widget.SelectedBatch?.getobj['profile']['lV'] ?? "",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  3,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    widget.SelectedBatch?.getobj['profile']['nV'] ?? "",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 10),

                                                  // Threshold Section
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Threshold Details",
                                                        style:
                                                        TextStyle(
                                                          color:
                                                          darkBg,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontFamily:
                                                          baseFont,
                                                          fontSize:
                                                          16,
                                                          shadows: [
                                                            Shadow(
                                                              color:
                                                              Colors.black,
                                                              blurRadius:
                                                              0.5,
                                                              offset:
                                                              Offset(0.5, 0.5),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                          5),
                                                      const Expanded(
                                                          child: Divider(
                                                              color:
                                                              Colors.black26,
                                                              thickness: 1)),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 5),
                                                  Table(
                                                    defaultColumnWidth:
                                                    const FlexColumnWidth(),
                                                    children: [
                                                      TableRow(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  6,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    "U-Threshold",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  6,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    "L-Threshold",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                          ]),
                                                      TableRow(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  3,
                                                                  6,
                                                                  6),
                                                              child: Center(
                                                                  child: Text(
                                                                    widget.SelectedBatch?.getobj['profile']['uT'] ?? "",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  3,
                                                                  6,
                                                                  6),
                                                              child: Center(
                                                                  child: Text(
                                                                    widget.SelectedBatch?.getobj['profile']['lT'] ?? "",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 10),

                                                  // Temperature Section
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Temperature Details",
                                                        style:
                                                        TextStyle(
                                                          color:
                                                          darkBg,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontFamily:
                                                          baseFont,
                                                          fontSize:
                                                          16,
                                                          shadows: [
                                                            Shadow(
                                                              color:
                                                              Colors.black,
                                                              blurRadius:
                                                              0.5,
                                                              offset:
                                                              Offset(0.5, 0.5),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                          5),
                                                      const Expanded(
                                                          child: Divider(
                                                              color:
                                                              Colors.black26,
                                                              thickness: 1)),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 6),
                                                  Table(
                                                    defaultColumnWidth:
                                                    const FlexColumnWidth(),
                                                    children: [
                                                      TableRow(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  6,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    "U-Temp",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  6,
                                                                  6,
                                                                  3),
                                                              child: Center(
                                                                  child: Text(
                                                                    "L-Temp",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                          ]),
                                                      TableRow(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  3,
                                                                  6,
                                                                  6),
                                                              child: Center(
                                                                  child: Text(
                                                                    widget.SelectedBatch?.getobj['profile']['uTemp'] ?? "",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(
                                                                  6,
                                                                  3,
                                                                  6,
                                                                  6),
                                                              child: Center(
                                                                  child: Text(
                                                                    widget.SelectedBatch?.getobj['profile']['lTemp'] ?? "",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, shadows: [
                                                                      Shadow(color: Colors.black, blurRadius: 0.5)
                                                                    ]),
                                                                  )),
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 15),

                                                  // Send Config Button
                                                  Center(
                                                    child:
                                                    ElevatedButton(
                                                      onPressed:
                                                          () async {
                                                        printFunc(
                                                            "Demo selectedBatch - ${widget.SelectedBatch?.getobj}");
                                                        printFunc("DEMO DEVICE SELECTED : $device");
                                                        await handleConfigProcess();
                                                      },
                                                      style:
                                                      ButtonStyle(
                                                        backgroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            darkBg),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                            RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(18)),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                          "Send Configure",
                                                          style: TextStyle(
                                                              fontSize:
                                                              16)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                      : () {
                                    printFunc("NOT CONNECTED");
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: isDeviceConnected
                                        ? MaterialStateProperty.all(darkBg)
                                        : MaterialStateProperty.all(
                                        darkBg.withOpacity(0.4)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(25),
                                          side: BorderSide(
                                              color: darkBg, width: 1)),
                                    ),
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: screenSize.width / 3.5,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        enableDisconnect
                                            ? "Disconnect"
                                            : "Configure",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: isDeviceConnected
                                              ? Colors.white
                                              : Color(0xFFEEEEEE),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: baseFont,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 0.1)
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
                                padding:
                                EdgeInsets.only(bottom: 10, top: 15),
                                child: ElevatedButton(
                                  onPressed: isDeviceConnected
                                      ? () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:
                                            (BuildContext contextt) {
                                          return AlertDialog(
                                            contentPadding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal: 20,
                                                vertical: 16),
                                            insetPadding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal: 40,
                                                vertical: 24),
                                            backgroundColor:
                                            second_lightBg,
                                            content:
                                            SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                // keeps dialog compact
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  // Title
                                                  Center(
                                                    child: Text(
                                                      "Calibration",
                                                      style:
                                                      TextStyle(
                                                        color: darkBg,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        fontFamily:
                                                        baseFont,
                                                        fontSize: 20,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors
                                                                .black,
                                                            blurRadius:
                                                            0.5,
                                                            offset: Offset(
                                                                0.5,
                                                                0.5),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //divider
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                          height: 10),
                                                      Divider(
                                                        color: darkBg,
                                                      ),
                                                      SizedBox(
                                                          height: 10),
                                                    ],
                                                  ),

                                                  // Send Config Button
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        padding:
                                                        EdgeInsets
                                                            .all(
                                                            10),
                                                        decoration:
                                                        BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                              darkBg),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                          color:
                                                          darkBg,
                                                        ),
                                                        child:
                                                        GestureDetector(
                                                          onTap:
                                                              () async {
                                                            _showInputDialog(
                                                                Alertcontext:
                                                                context,
                                                                title:
                                                                "Vmax for Calibration",
                                                                hint:
                                                                "e.g. 4200",
                                                                onSubmit:
                                                                sendVmax,
                                                                afterText:
                                                                "Calibrating Vmax...",
                                                                labelText:
                                                                "Enter Vmax(mV)");
                                                          },
                                                          child: Text(
                                                            "Voltage\nCalibration",
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                FontWeight.w500),
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                        EdgeInsets
                                                            .all(
                                                            10),
                                                        decoration:
                                                        BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                              darkBg),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                          color:
                                                          darkBg,
                                                        ),
                                                        child:
                                                        GestureDetector(
                                                          onTap:
                                                              () async {
                                                            _showInputDialog(
                                                                Alertcontext:
                                                                context,
                                                                title:
                                                                "Temperature for Calibration",
                                                                hint:
                                                                "e.g. 25000",
                                                                onSubmit:
                                                                sendTemperature,
                                                                labelText:
                                                                "Enter Temperature",
                                                                afterText:
                                                                "Calibrating Temp...");
                                                          },
                                                          child: Text(
                                                            "Temperature\nCalibration",
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                FontWeight.w500),
                                                            textAlign:
                                                            TextAlign
                                                                .center,
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
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context);
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(
                                                      darkBg),
                                                  shape: MaterialStateProperty
                                                      .all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            18)),
                                                  ),
                                                ),
                                                child: Text("Cancel",
                                                    style: TextStyle(
                                                        fontSize:
                                                        16)),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                      : () {
                                    printFunc("Not Connected");
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: isDeviceConnected
                                        ? MaterialStateProperty.all(darkBg)
                                        : MaterialStateProperty.all(
                                        darkBg.withOpacity(0.4)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(25),
                                          side: BorderSide(
                                              color: darkBg, width: 1)),
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
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 0.1)
                                          ],
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              //Submit btn
                            ],
                          ),
                        ],
                      )
                          : SizedBox(
                        height: 15,
                      ),
                    ],
                  )),
            ),
          ),
        )
      ),
    );
  }



  Future<void> handleConfigProcess() async {
    if (isDeviceConnected && !deviceNotFoundError && !connectionFailedError) {
      AddedSuccess(HardWareNumber, ClientName);

      if (await sendConfig()) {
        if (await sendVoltageThresholds()) {
          if (await sendTemperatureThresholds()) {
            printFunc("Inside the Send Temp Func");
            await saveHardware(context,
                macId: widget.macID.toString(),
                BatchId: widget.SelectedBatch?.obj['id'],
                productId: HardWareNumber.obj['id'].toString());
            await deleteByHardWareNumber();
            ShowSnackBarMessage(context, "Configure Sent!!", true);
            Navigator.of(context).pop();
            setState(() {
              enableDisconnect = true;
            });
          } else {
            showOperationFailedDialog("Temperature Not Sent");
          }
        } else {
          showOperationFailedDialog("Voltage Not Sent");
        }
      } else {
        showOperationFailedDialog("Config Not Sent");
      }
    }
  }

  void showOperationFailedDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contextt) {
        return AlertDialog(
          content: Text(
            "$message !! \n Try to Re-Submit.",
            style: TextStyle(
              color: darkBg,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // Reset flags and allow retry
                resetConnectionFlags();
                disconnect();
                await scanAndConnect();

              },
              child: Text(
                "Re-try",
                style: TextStyle(fontSize: 16),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                "Go Back",
                style: TextStyle(fontSize: 16),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)))),
            ),
          ],
          backgroundColor: second_lightBg,
        );
      },
    );
  }


  void AddedSuccess(DataController hardWareNumber, DataController clientName) {
    if (HardWareNumber.getText != "" && ClientName.getText != "") {
      setState(() {
        _added = true;
      });
    }
  }

  ///////////// Hardware number and pop-up /////////////////////
  Future<void> PIDforFactoryUser() async {
    if (UserData().designationCode.toString() == "3") {
      result =
          await getProductIdbyMac(context, mac_ID: widget.macID.toString());
      printFunc("result demo ${result[0]} \n ${result[1]}");
      bool macaAvailable = result[0];

      if (!mounted) return;

      if (macaAvailable) {
        Map<String, dynamic> productId = result[1];
        printFunc("productIdproductId : ${productId['productId']}");

        if (!mounted) return;

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext contextt) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text(
                      "Tracker Serial Number Found",
                      style: TextStyle(
                          color: darkBg,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 0.4)
                          ]),
                    ),
                    Divider(
                      color: darkBg,
                      thickness: 0.5,
                    )
                  ],
                ),
                content: Text(
                  "This Device is Assign with this ${productId['productId'].toString()} Tracker Serial Number. Do you want too?",
                  style: TextStyle(
                    color: darkBg,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(contextt, rootNavigator: true).pop();
                      HardWareNumber.setText =
                          productId['productId'].toString();
                      HardWareNumber.setobj = productId;
                      serialCtrl.text = HardWareNumber.getText.toString();
                      if (mounted) setState(() {});
                    },
                    child: Text(
                      "Continue",
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
                    onPressed: () {
                      Navigator.of(contextt, rootNavigator: true).pop();
                      HardWareNumber.setText = HardWareMap.entries.first.key;
                      HardWareNumber.setobj = HardWareMap.entries.first.value;
                      serialCtrl.text = HardWareNumber.getText.toString();
                      if (mounted) setState(() {});
                    },
                    child: Text(
                      "Assign New",
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

      } else {
        HardWareNumber.setText = HardWareMap.entries.first.key;
        HardWareNumber.setobj = HardWareMap.entries.first.value;
        serialCtrl.text = HardWareNumber.getText.toString();
        if (mounted) setState(() {});;
      }
    }
  }

  void generateHardWareMap() {
    final box = Hive.box<GetNumberModel>('$getNumberHiveBox');
    printFunc("Hive box : ${box.values}");
    for (var item in box.values)
      // printFunc("item.productId :${item.productId.toString()}");
      HardWareMap = {
        for (var item in box.values)
          item.productId.toString(): {
            'id': item.id,
            'productId': item.productId.toString(),
            'discription': item.discription,
            'createdOn': item.createdOn,
            'active': item.active
          }
      };
  }

  Future<void> deleteByHardWareNumber() async {
    final box = Hive.box<GetNumberModel>('$getNumberHiveBox');

    final keyToDelete = box.keys.firstWhere(
        (key) => box.get(key)?.productId.toString() == HardWareNumber.getText,
        orElse: () => null);
    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }

  /////////////  End of Hardware number /////////////////////

  ///////////// Writing on device ////////////////////
  Future<void> requestPermissions() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothAdvertise.request();
  }

  Future<void> scanAndConnect() async {
    printFunc("BEFORE Device Connected -- $status");

    setState(() {
      status = "Scanning...";
      isScanning = true;
      deviceNotFoundError = false;
      connectionFailedError = false;
    });

    timeoutTimer?.cancel();
    timeoutTimer = Timer(Duration(seconds: 45), () async {
      await FlutterBluePlus.stopScan();
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    });

    printFunc("Found Old macid: ${widget.macID}");
    await requestPermissions();

    printFunc("device present : ${device != null}");

    // If Device is Present we need to disconnect
    if (device != null && device!.isConnected) {
      printFunc("device present : ${device != null}");
      await disconnect();
    }

    printFunc("device present : ${device != null}");
    await Future.delayed(Duration(seconds: 5));

    //Scanning the device and returning
    device = await scanDeviceByMACId(widget.macID.toString());
    printFunc("DEMO DEVICE : $device");

    if (device != null) {
      bool connected = await connectToDevice(device!);
      if (connected) {
        if (device!.isConnected) {
          timeoutTimer?.cancel();
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
                  // Add Two Lines From demo
                  await calibrationChar!.setNotifyValue(true);
                  calibrationChar!.value.listen(_handleAck);
                }
              }
            }
          }
        }
        setState(() {
          status = "Connected";
          isScanning = false;
          isDeviceConnected = true;
          enableSubmit = true;
          deviceName = device!.advName;
        });
        return;
      } else {
        // Connection failed
        setState(() {
          connectionFailedError = true;
          isScanning = false;
          isDeviceConnected = false;
          enableSubmit = false;
        });

        printFunc("Connection Failed!!");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext contextt) {
            return AlertDialog(
              content: Text(
                "Connection Failed !! \n Try to Re-Connect.",
                style: TextStyle(
                  color: darkBg,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Reset flags and retry
                    resetConnectionFlags();
                  },
                  child: Text(
                    "Re-Connect",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Go Back",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)))),
                ),
              ],
              backgroundColor: second_lightBg,
            );
          },
        );
      }
    } else {
      // Device not found
      setState(() {
        deviceNotFoundError = true;
        isScanning = false;
        isDeviceConnected = false;
        enableSubmit = false;
      });

      printFunc("DEVICE NOT Found in else Cond");
      printFunc("${widget.macID} is not found");
      await FlutterBluePlus.stopScan();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contextt) {
          return AlertDialog(
            content: Text(
              "Device not found !!",
              style: TextStyle(
                color: darkBg,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Back",
                  style: TextStyle(fontSize: 16),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)))),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Reset flags and retry
                  resetConnectionFlags();
                },
                child: Text(
                  "Re-try",
                  style: TextStyle(fontSize: 16),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)))),
              ),
            ],
            backgroundColor: second_lightBg,
          );
        },
      );
    }

    timeoutTimer?.cancel();
    if (mounted) {
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> disconnect() async {
    if (device != null) {
      await device!.disconnect();
      if (mounted) {
        setState(() {
          status = "Disconnected";
          deviceName = "-";
          isDeviceConnected = false;
          isScanning = false;
          enableSubmit = false;
        });
      }
    }
    await Future.delayed(Duration(seconds: 2));
    printFunc("${widget.macID} is disconnected");
  }

  Future<bool> sendConfig() async {
    printFunc("null");
    printFunc("configCHar : $configChar");
    if (configChar == null) return false;
    printFunc("null2");
    try {
      int batteryType = int.parse(batteryTypeCtrl.text);
      batteryFactor = batteryType;

      List<String> parts = dateCtrl.text.split("-");
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);

      int serial = int.parse(serialCtrl.text);
      int product = int.parse(productIdCtrl.text);
      int chem = int.parse(chemistryTypeCtrl.text);

      var data = List<int>.filled(12, 0);
      data[0] = '['.codeUnitAt(0);
      data[1] = batteryType;
      data[2] = day;
      data[3] = month;
      data[4] = year & 0xFF;
      data[5] = (year >> 8) & 0xFF;
      data[6] = serial & 0xFF;
      data[7] = (serial >> 8) & 0xFF;
      data[8] = product & 0xFF;
      data[9] = (product >> 8) & 0xFF;
      data[10] = chem;
      data[11] = ']'.codeUnitAt(0);
      printFunc("config data : $data");
      await configChar!.write(data);
      printFunc("Configuration sent");
      return true;
    } catch (e) {
      printFunc("Invalid input at config: $e");
      return false;
    }
  }

  Future<bool> sendVoltageThresholds() async {
    if (thresholdChar == null) return false;

    double maxVoltage = double.parse(maxVoltageCtrl.text);
    double maxThreshold = double.parse(maxThresholdCtrl.text);
    double minThreshold = double.parse(minThresholdCtrl.text);
    double minVoltage = double.parse(minVoltageCtrl.text);
    double nominalVoltage = double.parse(nominalVoltageCtrl.text);

    int batteryType = int.parse(batteryTypeCtrl.text);
    batteryFactor = batteryType;
    printFunc("bfactor------------> $batteryFactor");
    int factor = batteryFactor == 0 ? 1 : batteryFactor;

    double maxV = maxVoltage * factor;
    double maxT = maxThreshold * factor;
    double minT = minThreshold * factor;
    double minV = minVoltage * factor;
    double nomV = nominalVoltage * factor;

    printFunc("Raw Inputs:");
    printFunc("Max Voltage: $maxVoltage");
    printFunc("Max Threshold: $maxThreshold");
    printFunc("Min Threshold: $minThreshold");
    printFunc("Min Voltage: $minVoltage");
    printFunc("Nominal Voltage: $nominalVoltage");

    printFunc("After applying battery factor ($factor):");
    printFunc("maxV = $maxV");
    printFunc("maxT = $maxT");
    printFunc("minT = $minT");
    printFunc("minV = $minV");
    printFunc("nomV = $nomV");

    final data = Uint8List(12);
    final view = ByteData.view(data.buffer);

    data[0] = 91; // '['
    view.setUint16(1, (maxV * 100).round(), Endian.little);
    view.setUint16(3, (maxT * 100).round(), Endian.little);
    view.setUint16(5, (minT * 100).round(), Endian.little);
    view.setUint16(7, (minV * 100).round(), Endian.little);
    view.setUint16(9, (nomV * 100).round(), Endian.little);
    data[11] = 93; // ']'
    try {
      printFunc("Final Bytes to Send: ${data.join(', ')}");

      await thresholdChar!.write(data);
      return true;
    } catch (e) {
      printFunc("Exception at voltage $e");
      printFunc("Error: $e");
      return false;
    }
    printFunc("${widget.macID} is voltage is sent");
  }

  Future<bool> sendTemperatureThresholds() async {
    if (thresholdChar == null) return false;
    try {
      int minTemp = int.parse(minTempCtrl.text);
      int maxTemp = int.parse(maxTempCtrl.text);
      printFunc("DEMODEMODEMO maxTemp minTemp  : $maxTemp $minTemp");

      Uint8List buffer = Uint8List(6);
      buffer[0] = 123;
      ByteData view = ByteData.view(buffer.buffer);

      view.setInt16(1, minTemp, Endian.little);
      view.setInt16(3, maxTemp, Endian.little);
      buffer[5] = 125;

      printFunc("Demo Temperature Packet : $buffer");

      await thresholdChar!.write(buffer);
      return true;
    } catch (e) {
      printFunc("Invalid temperature input: $e");
      return false;
    }
  }

  void _handleAck(List<int> data) {
    String ack = String.fromCharCodes(data);
    printFunc(" Received ACK from device: $ack");

    if (calibrationStep == 0 && ack.contains("ACK_VMAX")) {
      if (mounted) {
        setState(() {
          calibrationStep = 1;
          waitingForAck = false;
        });
        Navigator.of(context, rootNavigator: true).pop();
        ShowSnackBarMessage(
            alertContext!, 'Voltage_max sent for Calibration', true);
        Future.delayed(const Duration(milliseconds: 300), () {
          _showInputDialog(
              Alertcontext: context,
              title: "Vmin for Calibration",
              hint: "e.g. 3200",
              onSubmit: sendVmin,
              labelText: "Enter Vmin (mV)",
              afterText: "Calibrating Vmin...");
        });
      }
      // Open Vmin popup
    } else if (calibrationStep == 1 && ack.contains("ACK_VMIN")) {
      printFunc(" Vmin accepted, waiting for COMPLETE...");
    } else if (calibrationStep == 1 && ack.contains("ACK_COMPLETE")) {
      printFunc(" Voltage Calibration Completed!");
      ShowSnackBarMessage(
          alertContext!, 'Voltage Calibration Completed!', true);
      if (mounted) {
        setState(() {
          calibrationStep = 0;
          waitingForAck = false;
        });
      }
      Navigator.of(context, rootNavigator: true).pop();
    } else if (calibrationStep == 2 && ack.contains("ACK_TEMP")) {
      printFunc("Temperature Calibration Completed!");
      ShowSnackBarMessage(
          alertContext!, 'Temperature Calibration Completed!', true);
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
    setState(() {
      alertContext = Alertcontext;
    });

    return showDialog(
      context: Alertcontext,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(
              title,
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
                    Divider(
                      color: darkBg,
                    ),
                    SizedBox(height: 10),
                  ],
                ),

                if (!waitingForAck)
                  Align(
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
                if (!waitingForAck)
                  Container(
                    height: 60,
                    width: screenSize.width,
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Center(
                      child: TextField(
                          cursorWidth: 1,
                          style: TextStyle(
                              fontSize: 18,
                              color: darkBg,
                              fontWeight: FontWeight.w500,
                              fontFamily: baseFont,
                              letterSpacing: 0.2),
                          controller: inputCtrl,
                          cursorColor: darkBg,
                          keyboardType: TextInputType.number,
                          enabled: !waitingForAck,
                          // validator: validator,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: darkBg, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              focusColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide:
                                      BorderSide(width: 1, color: darkBg)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black)),
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
                if (waitingForAck)
                  CircularProgressIndicator(
                    color: darkBg,
                  ),
                if (waitingForAck) SizedBox(height: 8),
                if (waitingForAck)
                  Text(
                    afterText,
                    style: TextStyle(color: darkBg),
                  ),
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


  Future<void> _startPIDCheck() async {
    printFunc("Inside StartPID");
    if (_isPidLoading) return; // avoid multiple
    _isPidLoading = true;

    try {
      await PIDforFactoryUser();
      await scanAndConnect();
      if (mounted) {
        setState(() {
          isScanning = false;
          isOffline = false;
        });
      }
    } finally {
      _isPidLoading = false;
    }
  }

  void _onInternetChange() {
    printFunc("Inside _onInternetChange");

    final status = InternetStatus.isOnline.value;

    printFunc("IsONLIne : $status");

    if (!mounted) return;

    if (status) {
      // Online case
      if (_initialNetworkCheckDone &&
          (HardWareNumber.Text == null || HardWareNumber.Text!.isEmpty)) {
        _startPIDCheck();
        printFunc("NT01");
      } else if (!_initialNetworkCheckDone) {
        setState(() {
          _initialNetworkCheckDone = true;
        });
        _startPIDCheck();
        printFunc("NT02");
      }
    } else {
      // Offline case
      setState(() {
        isScanning = false;
        deviceNotFoundError = false;
        connectionFailedError = false;
        _initialNetworkCheckDone = true;
        isOffline = true;
      });


    }
  }


  @override
  void dispose() {
    timeoutTimer?.cancel();
    InternetStatus.isOnline.removeListener(_onInternetChange);

    super.dispose();
  }






}

//Old Class
/*
class BluetoothHardwareNumberState extends State<BluetoothHardwareNumber> {
  // For Current Date
  DateTime now = DateTime.now();

  //Hardware number and Client Details
  Map<String, dynamic> HardWareMap = {};
  List<Map<String, dynamic>> allClients = [{}];
  DataController HardWareNumber = DataController();
  DataController ClientName = DataController();

  //Controllers
  TextEditingController batchName = new TextEditingController();
  TextEditingController firmWareName = new TextEditingController();
  TextEditingController configName = new TextEditingController();

  bool _validateDropDown = false;
  bool _added = false;

  List result = [];

  bool NotConnected = false;
  bool enableSubmit = false;


  //Controllers and variables for device bluetooth

  final flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? configChar;
  BluetoothCharacteristic? thresholdChar;
  BluetoothCharacteristic? calibrationChar;

  final serviceUUID = Guid("f043176a-5168-11ee-be56-0242ac120012");
  final configCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120014");
  final thresholdCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120016");
  final calibrationCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120017");

  // Controllers
  final batteryTypeCtrl = TextEditingController(); //profile [deviceType]
  final dateCtrl = TextEditingController(); //current Date
  final serialCtrl = TextEditingController(); //10 serial number
  final custIdCtrl = TextEditingController(); //
  final productIdCtrl = TextEditingController(); //constant
  final chemistryTypeCtrl = TextEditingController(); //constant
  final maxVoltageCtrl = TextEditingController(); //config[mv]
  final maxThresholdCtrl = TextEditingController(); //config[mt]
  final minThresholdCtrl = TextEditingController(); //config[lt]
  final minVoltageCtrl = TextEditingController(); //config[lv]
  final nominalVoltageCtrl = TextEditingController(); //hardcode
  final minTempCtrl = TextEditingController(); //hardcode
  final maxTempCtrl = TextEditingController(); //hardcode
  final tempCalibCtrl = TextEditingController(); //hardcode

  String status = "Disconnected";
  String deviceName = "-";

  int batteryFactor = 1;

  //bool for sending things
  bool isConfigSent = true;
  bool isVoltSent = true;
  bool isTempSent = true;
  String? fullSerial;



  Timer? timeoutTimer;


  @override
  void initState() {
    super.initState();
    generateHardWareMap();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PIDforFactoryUser();
      // await scanAndConnect();


    });
    setState(() {


      batteryTypeCtrl.text = widget.SelectedBatch?.obj['battery']['batteryCode'];
      dateCtrl.text = DateFormat('yyyy-MM-dd').format(now);
      HardWareNumber.getText.toString();
      custIdCtrl.text = "1";
      productIdCtrl.text = "4637";
      chemistryTypeCtrl.text = "03";
      "Li-ion";
      maxVoltageCtrl.text = widget.SelectedBatch?.obj['profile']['uV'];
      maxThresholdCtrl.text = widget.SelectedBatch?.obj['profile']['uT'];
      minThresholdCtrl.text = widget.SelectedBatch?.obj['profile']['lT'];
      minVoltageCtrl.text = widget.SelectedBatch?.obj['profile']['lV'];
      nominalVoltageCtrl.text = widget.SelectedBatch?.obj['profile']['nV'];
      minTempCtrl.text = widget.SelectedBatch?.obj['profile']['lTemp'];
      maxTempCtrl.text = widget.SelectedBatch?.obj['profile']['uTemp'];
      tempCalibCtrl.text = "13";
    });

    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> _onWillPop() async {
    await disconnect();
    return true; // Block default system back button
  }

  @override
  Widget build(BuildContext context) {
    chemistryTypeCtrl.text = "03";
    "Li-ion";

    batchName.text = widget.SelectedBatch?.obj['name'];
    firmWareName.text = widget.SelectedBatch?.obj['firmware']['versionName'];
    configName.text = widget.SelectedBatch?.obj['profile']['name'];
    // HardWareNumber.setobj = HardWareMap.entries.first.value;
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Adding",
            style: TextStyle(
                fontFamily: baseFont,
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: lightBg),
          ),
          //Leading Icon
          /*leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await disconnect();
              Navigator.pop(context); // Go back manually
            },
          ),*/
          toolbarHeight: screenSize.height / 13,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        body: Center(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // <-- radius here
            ),
            child: Container(
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
                    padding: EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "DETAILS ",
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
                          NotConnected
                              ? Container(
                                  color: second_lightBg,
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
                                  onPressed: enableSubmit
                                      ? () {
                                    setState(() {});
                                    timeoutTimer?.cancel();
                                    timeoutTimer = Timer(Duration(seconds: 15), () async {
                                      setState(() {
                                        NotConnected = false;
                                      });
                                      await FlutterBluePlus.stopScan();
                                    });
                                  }
                                      : ()  { },
                                  child: enableSubmit
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
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          const LabelText(text: "Batch Name :"),
                          TextFeildNewUser(
                            hintText: batchName.text,
                            Controller: batchName,
                            onChanged: (value) {},
                            enable: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const LabelText(text: "FirmWare Name :"),
                          TextFeildNewUser(
                            hintText: firmWareName.text,
                            Controller: firmWareName,
                            onChanged: (value) {},
                            enable: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const LabelText(text: "Config Name :"),
                          TextFeildNewUser(
                            hintText: configName.text,
                            Controller: configName,
                            onChanged: (value) {},
                            enable: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            child: PrimeryDropDownButton(
                              isEnabled: false,
                              tail: ErrorContainer(
                                  show: _validateDropDown &&
                                      HardWareNumber.getText == "",
                                  errorMsg:
                                      "Please Select the HardWare Number"),
                              mainText: "Select HardWare Number",
                              text: HardWareNumber.Text != ""
                                  ? HardWareNumber.getText
                                  : "Select HardWare Number",
                              press: () async {
                                await BottomSheet_Widget(context, [
                                  MapListItemBuilder(
                                      listItems: HardWareMap,
                                      press: () {
                                        printFunc(
                                            "Demo datacontroller - ${HardWareNumber.getText}");
                                      },
                                      selected: HardWareNumber)
                                ]);
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),


                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 15),
                    child: ElevatedButton(
                      //Demo onpress
                      onPressed: () async {
                              ValidateDropDown(HardWareNumber, ClientName);
                             if(device!=null){ if(device!.isDisconnected){
                                await device!.connect(autoConnect: false);
                              }
                          }   else{

                             }
                              AddedSuccess(HardWareNumber, ClientName);
                              // if (await sendConfig() ) {
                              //   saveHardware(context,
                              //       macId: widget.macID.toString(),
                              //       BatchId: widget.SelectedBatch?.obj['id'],
                              //       productId:
                              //           HardWareNumber.obj['id'].toString());
                              //   await deleteByHardWareNumber();
                              //
                              //   //await Future.delayed(Duration(seconds: 2));
                              //   await sendVoltageThresholds();
                              //   await sendTemperatureThresholds();
                              //   await Future.delayed(Duration(seconds: 3));
                              //   disconnect();
                              //   Navigator.of(context).pop();
                              // }
                              // else {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //           content:
                              //               Text("Configuration sent")));
                              //   await disconnect();
                              //   // Navigator.of(context, rootNavigator: true)
                              //   //     .pop();
                              // }

                              await scanAndConnect();
                              if(await sendConfig()){
                                if(await sendVoltageThresholds()){
                                  if(await sendTemperatureThresholds()){
                                    printFunc("Inside the Send Temp Func");
                                    await saveHardware(context,
                                        macId: widget.macID.toString(),
                                        BatchId: widget.SelectedBatch?.obj['id'],
                                        productId:
                                        HardWareNumber.obj['id'].toString());
                                    await deleteByHardWareNumber();
                                    disconnect();
                                  }else{
                                    isTempSent = false;
                                    // showDialog(context: context, builder: (BuildContext contextt) {
                                    //   return AlertDialog(
                                    //     // title: Text(""),
                                    //     content: Text(
                                    //       "Temperature Not Sent !! \n Try to Re-Submit.",
                                    //       style: TextStyle(
                                    //         color: darkBg,
                                    //         fontWeight: FontWeight.w500,
                                    //       ),
                                    //     ),
                                    //     actions: [
                                    //       //OK btn that goes for next page
                                    //       ElevatedButton(
                                    //         onPressed: (){
                                    //           Navigator.of(context).pop();
                                    //         },
                                    //
                                    //         child: Text(
                                    //           "Re-try",
                                    //           style: TextStyle(fontSize: 16),
                                    //         ),
                                    //         style: ButtonStyle(
                                    //             backgroundColor:
                                    //             MaterialStateProperty.all<Color>(darkBg),
                                    //             shape:
                                    //             MaterialStateProperty.all<RoundedRectangleBorder>(
                                    //                 RoundedRectangleBorder(
                                    //                     borderRadius: BorderRadius.circular(18)))),
                                    //       ),
                                    //     ],
                                    //     backgroundColor: second_lightBg,
                                    //   );
                                    // });

                                    setState(() {});
                                    ShowSnackBarMessage(context, "Temperature Not Sent", false);
                                  }
                                }else{
                                  isVoltSent = false;
                                  // showDialog(context: context, builder: (BuildContext contextt) {
                                  //   return AlertDialog(
                                  //     // title: Text(""),
                                  //     content: Text(
                                  //       "Voltage Not Sent !! \n Try to Re-Submit.",
                                  //       style: TextStyle(
                                  //         color: darkBg,
                                  //         fontWeight: FontWeight.w500,
                                  //       ),
                                  //     ),
                                  //     actions: [
                                  //       //OK btn that goes for next page
                                  //       ElevatedButton(
                                  //         onPressed: (){
                                  //           Navigator.of(context).pop();
                                  //         },
                                  //
                                  //         child: Text(
                                  //           "Re-try",
                                  //           style: TextStyle(fontSize: 16),
                                  //         ),
                                  //         style: ButtonStyle(
                                  //             backgroundColor:
                                  //             MaterialStateProperty.all<Color>(darkBg),
                                  //             shape:
                                  //             MaterialStateProperty.all<RoundedRectangleBorder>(
                                  //                 RoundedRectangleBorder(
                                  //                     borderRadius: BorderRadius.circular(18)))),
                                  //       ),
                                  //     ],
                                  //     backgroundColor: second_lightBg,
                                  //   );
                                  // });

                                  setState(() {});
                                  ShowSnackBarMessage(context, "Voltage Not Sent", false);
                                }
                              }
                              else{
                                isConfigSent = false;
                                // showDialog(context: context, builder: (BuildContext contextt) {
                                //   return AlertDialog(
                                //     content: Text(
                                //       "Config Not Sent !! \n Try to Re-Submit.",
                                //       style: TextStyle(
                                //         color: darkBg,
                                //         fontWeight: FontWeight.w500,
                                //       ),
                                //     ),
                                //     actions: [
                                //       ElevatedButton(
                                //         onPressed: (){
                                //           Navigator.of(context).pop();
                                //           if(mounted){
                                //             setState(() {
                                //               NotConnected = false;
                                //             });
                                //           }
                                //         },
                                //
                                //         child: Text(
                                //           "Re-try",
                                //           style: TextStyle(fontSize: 16),
                                //         ),
                                //         style: ButtonStyle(
                                //             backgroundColor:
                                //             MaterialStateProperty.all<Color>(darkBg),
                                //             shape:
                                //             MaterialStateProperty.all<RoundedRectangleBorder>(
                                //                 RoundedRectangleBorder(
                                //                     borderRadius: BorderRadius.circular(18)))),
                                //       ),
                                //     ],
                                //     backgroundColor: second_lightBg,
                                //   );
                                // });

                                setState(() {});
                                ShowSnackBarMessage(context, "Config Not Sent", false);
                              }


                              printFunc("MacID : ${widget.macID}  \n"
                                  "batchId :${widget.SelectedBatch?.obj['id']} \n"
                                  "ProductId :${HardWareNumber.obj['id']} \n");
                            },
                      style: ButtonStyle(
                        backgroundColor: NotConnected
                        ? MaterialStateProperty.all(darkBg.withOpacity(0.4))
                        : MaterialStateProperty.all(darkBg),
                        // backgroundColor: enableSubmit
                        //     ? MaterialStateProperty.all(darkBg)
                        //     : MaterialStateProperty.all(Color(0xFFB3D3D6)),

                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: darkBg, width: 1)),
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: screenSize.width / 2.5,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Submit",
                            maxLines: 1,
                            style: TextStyle(
                              color: enableSubmit
                                  ? Colors.white
                                  : Color(0xFFEEEEEE),
                              fontSize: 20,
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
                  // ElevatedButton(onPressed: ()async{await disconnect();}, child: Text("Disconnect"))
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  void ValidateDropDown(
      DataController HardwareNumber, DataController ClientName) {
    if (HardWareNumber.getText == "" && ClientName.getText == "") {
      setState(() {
        _validateDropDown = true;
      });
    } else {
      setState(() {
        _validateDropDown = false;
      });
    }
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _validateDropDown = false;
        });
      }
    });
  }

  void AddedSuccess(DataController hardWareNumber, DataController clientName) {
    if (HardWareNumber.getText != "" && ClientName.getText != "") {
      setState(() {
        _added = true;
      });
    }
  }

  ///////////// Hardware number and pop-up /////////////////////
  Future<void> PIDforFactoryUser() async {
    if (UserData().designationCode.toString() == "3") {
      //apical for get productId by mac
      //if map has a productId then
      result =
          await getProductIdbyMac(context, mac_ID: widget.macID.toString());
      printFunc("result demo ${result[0]} \n ${result[1]}");
      bool macaAvailable = result[0];

      if (macaAvailable) {
        Map<String, dynamic> productId = result[1];
        printFunc("productIdproductId : ${productId['productId']}");
        String fullSerialno = productId['productId'].toString();
        //Pop-up
        showDialog(
            context: context,
            builder: (BuildContext contextt) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text(
                      "Tracker Serial Number Found",
                      style: TextStyle(
                          color: darkBg,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 0.4)
                          ]),
                    ),
                    Divider(
                      color: darkBg,
                      thickness: 0.5,
                    )
                  ],
                ),
                content: Text(
                  "This Device is Assign with this ${fullSerialno} Tracker Serial Number. Do you want too?",
                  style: TextStyle(
                    color: darkBg,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actions: [
                  //Continue btn
                  ElevatedButton(
                    onPressed: () async {
                      //Go back
                      Navigator.of(contextt, rootNavigator: true).pop();
                      HardWareNumber.setText =
                          productId['productId'];
                      HardWareNumber.setobj = productId;
                      serialCtrl.text = HardWareNumber.getText.toString();
                      setState(() {});
                      // ProductID should prefill the part of ProductId
                    },
                    child: Text(
                      "Continue",
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
                  //Assign new Btn
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(contextt, rootNavigator: true).pop();
                      HardWareNumber.setText = HardWareMap.entries.first.key;
                      HardWareNumber.setobj = HardWareMap.entries.first.value;
                      serialCtrl.text =HardWareNumber.getText.toString();
                      setState(() {});
                      // New ProductId assinged Procees should start
                    },
                    child: Text(
                      "Assign New",
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
      } else {
        HardWareNumber.setText = HardWareMap.entries.first.key;
        HardWareNumber.setobj = HardWareMap.entries.first.value;
        serialCtrl.text = HardWareNumber.getText.toString();
        setState(() {});
        // New product ID assigned without any Pop -up
      }
    }
  }

  void generateHardWareMap() {
    final box = Hive.box<GetNumberModel>('$getNumberHiveBox');
    printFunc("Hive box : ${box.values}");
    for (var item in box.values)
      printFunc("item.productId :${item.productId.toString()}");
    HardWareMap = {
      for (var item in box.values)
        item.productId.toString(): {
          'id': item.id,
          'productId': item.productId.toString(),
          'discription': item.discription,
          'createdOn': item.createdOn,
          'active': item.active
        }
    };
  }

  Future<void> deleteByHardWareNumber() async {
    final box = Hive.box<GetNumberModel>('$getNumberHiveBox');

    final keyToDelete = box.keys.firstWhere(
        (key) => box.get(key)?.productId.toString() == HardWareNumber.getText,
        orElse: () => null);
    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }

  /////////////  End of Hardware number /////////////////////

  ///////////// Wrinting on device ////////////////////
  Future<void> requestPermissions() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothAdvertise.request();
  }

  Future<void> scanAndConnect() async {
    printFunc("BEFORe Device Connected -- $status");

    setState(() {
      status = "Scanning...";
      NotConnected = true;
    });


    timeoutTimer?.cancel();
    timeoutTimer = Timer(Duration(seconds: 45), ()async {
      await FlutterBluePlus.stopScan();
      setState(() {
        NotConnected = false;
      });
    });


    printFunc("Found Old macid: ${widget.macID}");
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
    device = await scanDeviceByMACId(widget.macID.toString());
    printFunc( "DEMO DEVICE : $device");

    if (device != null) {
      bool connected = await connectToDevice(device!);
      if (connected) {
        if (device!.isConnected) {
          timeoutTimer?.cancel();
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
                if (c.uuid == calibrationCharUUID) calibrationChar = c;
              }
            }
          }
        }
        setState(() {
          status = "Connected";
          NotConnected = false;
          enableSubmit = true;
          deviceName = device!.advName;
        });
        return;
      } else {
        if(mounted){
          setState(() {
            NotConnected = false;
          });
        }
        printFunc("Connection Failed!!");

        showAlertNavigtorLogout(context, "Connection Failed!!", "",
                (){Navigator.of(context).pop();},
                (){Navigator.of(context).pop();Navigator.of(context).pop(); },
            "Re-Connect", "Go Back"
        );


    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Connection Failed", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ));

      }
    }
    else {
      if(mounted){
        setState(() {NotConnected = false;});
      }
      printFunc("DEVICE NOT FOund in else Cond");
      printFunc("${widget.macID} is not found");
      await FlutterBluePlus.stopScan();

      showDialog(context: context, builder: (BuildContext contextt) {
        return AlertDialog(
          // title: Text(""),
          content: Text(
            "Device not found !!",
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
              onPressed: (){
                Navigator.of(context).pop();
              },

              child: Text(
                "Re-try",
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


      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //     "Device not found",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Colors.redAccent,
      // ));
    }

    printFunc("DEMO STReet : $NotConnected");
    timeoutTimer?.cancel();
    if(mounted){
      setState(() {NotConnected = false;});
    }
    printFunc("DEMO STReet1 : $NotConnected");
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

    printFunc("${widget.macID} is disconnected");
  }

  Future<bool> sendConfig() async {
    printFunc("null");
    printFunc("configCHar : $configChar");
    if (configChar == null) return false;
    printFunc("null2");
    try {
      int batteryType = int.parse(batteryTypeCtrl.text);
      batteryFactor = batteryType;

      List<String> parts = dateCtrl.text.split("-");
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);

      int serial = int.parse(serialCtrl.text);
      int product = int.parse(productIdCtrl.text);
      int chem = int.parse(chemistryTypeCtrl.text);

      var data = List<int>.filled(12, 0);
      data[0] = '['.codeUnitAt(0);
      data[1] = batteryType;
      data[2] = day;
      data[3] = month;
      data[4] = year & 0xFF;
      data[5] = (year >> 8) & 0xFF;
      data[6] = serial & 0xFF;
      data[7] = (serial >> 8) & 0xFF;
      data[8] = product & 0xFF;
      data[9] =  (product >> 8) & 0xFF;
      data[10] = chem;
      data[11] = ']'.codeUnitAt(0);
      printFunc("config data : $data");
      await configChar!.write(data);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Configuration sent")));
      printFunc("Configuration sent");
      return true; //------------------- commit
    } catch (e) {
      printFunc("Invalid input at config: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid input: $e")));
      return false;
    }
  }

  Future<bool> sendVoltageThresholds() async {
    if (thresholdChar == null) return false;

    double maxVoltage = double.parse(maxVoltageCtrl.text);
    double maxThreshold = double.parse(maxThresholdCtrl.text);
    double minThreshold = double.parse(minThresholdCtrl.text);
    double minVoltage = double.parse(minVoltageCtrl.text);
    double nominalVoltage = double.parse(nominalVoltageCtrl.text);

    int batteryType = int.parse(batteryTypeCtrl.text);
    batteryFactor = batteryType;
    printFunc("bfactor------------>$batteryFactor");
    int factor = batteryFactor == 0 ? 1 : batteryFactor;

    double maxV = maxVoltage * factor;
    double maxT = maxThreshold * factor;
    double minT = minThreshold * factor;
    double minV = minVoltage * factor;
    double nomV = nominalVoltage * factor;

    printFunc("Raw Inputs:");
    printFunc("Max Voltage: $maxVoltage");
    printFunc("Max Threshold: $maxThreshold");
    printFunc("Min Threshold: $minThreshold");
    printFunc("Min Voltage: $minVoltage");
    printFunc("Nominal Voltage: $nominalVoltage");

    printFunc("After applying battery factor ($factor):");
    printFunc("maxV = $maxV");
    printFunc("maxT = $maxT");
    printFunc("minT = $minT");
    printFunc("minV = $minV");
    printFunc("nomV = $nomV");

    final data = Uint8List(12);
    final view = ByteData.view(data.buffer);

    data[0] = 91; // '['
    view.setUint16(1, (maxV * 100).round(), Endian.little);
    view.setUint16(3, (maxT * 100).round(), Endian.little);
    view.setUint16(5, (minT * 100).round(), Endian.little);
    view.setUint16(7, (minV * 100).round(), Endian.little);
    view.setUint16(9, (nomV * 100).round(), Endian.little);
    data[11] = 93; // ']'
    try {
      printFunc("Final Bytes to Send: ${data.join(', ')}");

      await thresholdChar!.write(data);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Voltage thresholds sent successfully")),
      // );
      return true;
    } catch (e) {
      printFunc("Exception at voltage $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid voltage input: $e")),
      );
      printFunc("Error: $e");
      return false;
    }
    printFunc("${widget.macID} is voltage is sented");
  }

  Future<bool> sendTemperatureThresholds() async {
    if (thresholdChar == null) return false;
    try {
      int minTemp = int.parse(minTempCtrl.text);
      int maxTemp = int.parse(maxTempCtrl.text);
      printFunc("DEMODEMODEMO maxTemp minTemp  : $maxTemp $minTemp");

      Uint8List buffer = Uint8List(6);
      buffer[0] = 123;
      ByteData view = ByteData.view(buffer.buffer);

      view.setInt16(1, minTemp, Endian.little);
      view.setInt16(3, maxTemp, Endian.little);
      buffer[5] = 125;

      printFunc("Demo Temperature Packet : $buffer");

      // var data = List<int>.filled(6, 0);
      // data[0] = 123;
      // ByteData.view(Uint8List.fromList(data).buffer).setInt16(1, minTemp, Endian.little);
      // ByteData.view(Uint8List.fromList(data).buffer).setInt16(3, maxTemp, Endian.little);
      // data[5] = 125;
      //
      // printFunc("Demo Temperature Packet : $data");

      await thresholdChar!.write(buffer);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Temperature thresholds sent")));
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid temperature input: $e")));
      return false;
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

}
*/
