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
import 'package:tracker_firmware/modules/factoryUser/api/saveLog.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/Methods/scanAndconnect.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/CustomCard.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';
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


      // batteryTypeCtrl.text = "9";
      batteryTypeCtrl.text = widget.SelectedBatch?.obj['battery']['batteryCode'];
      // dateCtrl.text = "2025-07-28";
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await disconnect();
              Navigator.pop(context); // Go back manually
            },
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
                              // icon: Icon(
                              //   Icons.keyboard_arrow_down_sharp,
                              //   color: darkBg,
                              // ),
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

                          // client name field
                          /*GestureDetector(
                            child: PrimeryDropDownButton(
                              isEnabled: false,
                              tail: ErrorContainer(
                                  show: _validateDropDown && ClientName.getText == "",
                                  errorMsg: "Please Select the Client"),
                              mainText: "Select Client Name",
                              text: ClientName.Text != "" ? ClientName.getText : "Select Client Name",
                              icon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: darkBg,
                              ),
                              press: () async {
                                await BottomSheet_Widget(context, [
                                  MapListItemBuilder(
                                      listItems: widget.allclients!,
                                      press: () {},
                                      selected: ClientName
                                  )
                                ]);
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ), */
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 15),
                    child: ElevatedButton(
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
                                   setState(() {});
                                   ShowSnackBarMessage(context, "Temperature Not Sent", false);
                                  }
                                }else{
                                  isVoltSent = false;
                                  setState(() {});
                                  ShowSnackBarMessage(context, "Voltage Not Sent", false);
                                }
                              }else{
                                isConfigSent = false;
                                setState(() {});
                                ShowSnackBarMessage(context, "Config Not Sent", false);
                              }


                              printFunc("MacID : ${widget.macID}  \n"
                                  "batchId :${widget.SelectedBatch?.obj['id']} \n"
                                  "ProductId :${HardWareNumber.obj['id']} \n");
                            },
                      // enableSubmit
                      //     ? () async {
                      //         ValidateDropDown(HardWareNumber, ClientName);
                      //        if(device!=null){ if(device!.isDisconnected){
                      //           await device!.connect(autoConnect: false);
                      //         }
                      //     }   else{
                      //
                      //        }
                      //         AddedSuccess(HardWareNumber, ClientName);
                      //         // if (await sendConfig() ) {
                      //         //   saveHardware(context,
                      //         //       macId: widget.macID.toString(),
                      //         //       BatchId: widget.SelectedBatch?.obj['id'],
                      //         //       productId:
                      //         //           HardWareNumber.obj['id'].toString());
                      //         //   await deleteByHardWareNumber();
                      //         //
                      //         //   //await Future.delayed(Duration(seconds: 2));
                      //         //   await sendVoltageThresholds();
                      //         //   await sendTemperatureThresholds();
                      //         //   await Future.delayed(Duration(seconds: 3));
                      //         //   disconnect();
                      //         //   Navigator.of(context).pop();
                      //         // }
                      //         // else {
                      //         //   ScaffoldMessenger.of(context).showSnackBar(
                      //         //       SnackBar(
                      //         //           content:
                      //         //               Text("Configuration sent")));
                      //         //   await disconnect();
                      //         //   // Navigator.of(context, rootNavigator: true)
                      //         //   //     .pop();
                      //         // }
                      //
                      //         await scanAndConnect();
                      //         if(await sendConfig()){
                      //           if(await sendVoltageThresholds()){
                      //             if(await sendTemperatureThresholds()){
                      //               printFunc("Inside the Send Temp Func");
                      //               await saveHardware(context,
                      //                   macId: widget.macID.toString(),
                      //                   BatchId: widget.SelectedBatch?.obj['id'],
                      //                   productId:
                      //                   HardWareNumber.obj['id'].toString());
                      //               await deleteByHardWareNumber();
                      //               disconnect();
                      //             }else{
                      //              isTempSent = false;
                      //              setState(() {});
                      //              ShowSnackBarMessage(context, "Temperature Not Sent", false);
                      //             }
                      //           }else{
                      //             isVoltSent = false;
                      //             setState(() {});
                      //             ShowSnackBarMessage(context, "Voltage Not Sent", false);
                      //           }
                      //         }else{
                      //           isConfigSent = false;
                      //           setState(() {});
                      //           ShowSnackBarMessage(context, "Config Not Sent", false);
                      //         }
                      //
                      //
                      //         printFunc("MacID : ${widget.macID}  \n"
                      //             "batchId :${widget.SelectedBatch?.obj['id']} \n"
                      //             "ProductId :${HardWareNumber.obj['id']} \n");
                      //       }
                      //     : () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(darkBg),
                        // backgroundColor: enableSubmit
                        //     ? MaterialStateProperty.all(darkBg)
                        //     : MaterialStateProperty.all(Color(0xFFB3D3D6)),
                        elevation: MaterialStateProperty.all(5),
                        shadowColor: MaterialStateProperty.all(darkBg),
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
        //Pop-up
        showDialog(
            context: context,
            builder: (BuildContext contextt) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text(
                      "PRODUCT-ID FOUND",
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
                  "This Device is Assign with this ${productId['productId']} Product Id. Do you want too?",
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
                          productId['productId'].toString();
                      HardWareNumber.setobj = productId;
                      String fullSerial = HardWareNumber.getText.toString();
                      serialCtrl.text = fullSerial.substring(0, 4);
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
                      String fullSerial = HardWareNumber.getText.toString();
                      serialCtrl.text = fullSerial.substring(0, 4);
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
        String fullSerial = HardWareNumber.getText.toString();
        serialCtrl.text = fullSerial.substring(0, 4);
        setState(() {});
        // New product ID assigned without any Pop -up
      }
    }
  }

  void generateHardWareMap() {
    final box = Hive.box<GetNumberModel>('$getNumberHiveBox');
    printFunc("Hive box : ${box.values}");
    HardWareMap = {
      for (var item in box.values)
        item.productId.toString(): {
          'id': item.id,
          'productId': item.productId,
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
    print("BEFORe Device Connected -- $status");

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


    print("Found Old macid: ${widget.macID}");
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${widget.macID} is not found",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
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
    print("null");
    printFunc("configCHar : $configChar");
    if (configChar == null) return false;
    print("null2");
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
    print("bfactor------------>$batteryFactor");
    int factor = batteryFactor == 0 ? 1 : batteryFactor;

    double maxV = maxVoltage * factor;
    double maxT = maxThreshold * factor;
    double minT = minThreshold * factor;
    double minV = minVoltage * factor;
    double nomV = nominalVoltage * factor;

    print("Raw Inputs:");
    print("Max Voltage: $maxVoltage");
    print("Max Threshold: $maxThreshold");
    print("Min Threshold: $minThreshold");
    print("Min Voltage: $minVoltage");
    print("Nominal Voltage: $nominalVoltage");

    print("After applying battery factor ($factor):");
    print("maxV = $maxV");
    print("maxT = $maxT");
    print("minT = $minT");
    print("minV = $minV");
    print("nomV = $nomV");

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
      print("Final Bytes to Send: ${data.join(', ')}");

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
      print("Error: $e");
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


// scanning Start -- I need to call the scan method and get the device

/*
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 45));

    await FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        print("Found device macid: ${r.device.remoteId}");
        printFunc(
            "wht is this : ${r.device.remoteId.toString() == widget.macID.toString()}");

        if (r.device.remoteId.toString() == widget.macID.toString()) {
          await FlutterBluePlus.stopScan();
          // ✅ Read Advertisement Data BEFORE connecting
          print("Found device macid 23 : ${r.device.remoteId}");
          print(
              "Device cond : ${r.device.remoteId.toString() == widget.macID.toString()}");
          print("Device Connected -- $status");

          //Printing AdvertisementData
          AdvertisementData advData = r.advertisementData;
          print("Connected: ${r.device.isConnected}");
          print("Connected: ${r.device.bondState.first}");
          print("Connected: ${r.device.bondState.first}");

          print("adv Data: ${advData}");
          print("Manufacturer Data: ${advData.manufacturerData}");
          print("Service UUIDs: ${advData.serviceUuids}");
          print("Tx Power: ${advData.txPowerLevel}");
          print("Connectable: ${advData.connectable}");
          print("Local Name: ${advData.localName}");

          await Future.delayed(Duration(seconds: 2));

          // calling the connect
          try {
            await r.device.connect(autoConnect: false);
            print("Device Connected : ${r.device.isConnected}");
          } catch (e) {
            printFunc("Found Exception while connecting : $e");
          }
          if (r.device.isConnected) {
            device = r.device;

            status = "Connected";
            NotConnected = false;
            deviceName = device!.advName;
          }
          if (device != null && device!.isConnected) {
            print("$status IS THE STATUS");
            print("Connected to: ${device}");
            print("Connected to: ${device?.services.toString()}");
            print("Connected to: ${device?.services.length}");

            /////////// These things are common ////////////////////
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
            //////////////////////////////////////////////////////
          }

          break;
        }
      }
      setState(() {});
    });
    */

//Submit BTN
/*manageUserBtn(
                          text: "Submit",
                          onPress: enableSubmit
                              ? () async {
                            ValidateDropDown(HardWareNumber, ClientName);
                            await deleteByHardWareNumber();
                            AddedSuccess(HardWareNumber, ClientName);
                            if (await sendConfig()) {
                              saveHardware(context,
                                  macId: widget.macID.toString(),
                                  BatchId: widget.SelectedBatch?.obj['id'],
                                  productId: HardWareNumber.obj['id'].toString());
                              await Future.delayed(Duration(seconds: 2));
                              await sendVoltageThresholds();
                              await Future.delayed(Duration(seconds: 3));
                              await disconnect();
                              Navigator.of(context).pop();
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Configuration Not sent")));
                              await disconnect();
                              Navigator.of(context,rootNavigator: true).pop();
                            }
                            printFunc("MacID : ${widget.macID}  \n"
                                "batchId :${widget.SelectedBatch?.obj['id']} \n"
                                "ProductId :${HardWareNumber.obj['id']} \n");
                          }
                              : (){}
                          ),*/
