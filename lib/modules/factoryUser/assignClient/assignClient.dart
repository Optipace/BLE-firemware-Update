import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/api/assignClient.dart';
import 'package:tracker_firmware/modules/factoryUser/api/getClientByMac.dart';
import 'package:tracker_firmware/modules/factoryUser/api/hardWareNumber.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/barcode.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/Methods/scanAndconnect.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/CustomCard.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class AssignClient extends StatefulWidget {
  const AssignClient({super.key});

  @override
  State<AssignClient> createState() => _AssignClientState();
}

class _AssignClientState extends State<AssignClient> {

  //MAC-ID
  TextEditingController _macIdController = new TextEditingController();

  //Client
  DataController ClientName = DataController();
  List<Map<String, dynamic>> clientList = [];
  Map<String, dynamic> AllClient = {};

  //for validation
  bool validateFileds = false;

  bool enableClientField = false;
  List result =[];

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
  bool enablePopUp = false;
  String status = "Disconnected";
  String deviceName = "-";

  bool connected = false;
  bool isCustomerIDSent = false;

  // Timer? timeoutTimer;




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      clientList = await getAllClients(context);
      clientListIntoMap();
      if (device != null && device!.isConnected) {
        printFunc("device present : ${device != null}");
        await disconnect();
      }
      printFunc("clientList/ :-> $clientList");
      if (mounted) {
        setState(() {});
      }
    });
  }

  void clientListIntoMap() {
    AllClient = {
      for (var client in clientList) client['name'].toString(): client
    };
    setState(() {
      printFunc("AllClient:$AllClient");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Assign Client",
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
                  "ENTER THE DETAILS",
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
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //MACID
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
                                  enableClientField
                                  ?NotConnected
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
                                    onPressed: enableSubmit
                                        ? () {}
                                        : () async {
                                      validateFields();

                                      !validateFileds;
                                      // await scanAndConnect();


                                      setState(() {});
                                    },
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
                                  )
                                  : SizedBox() ,


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
                                              builder: (context) => QRScannerScreen(title: "Scan QR-Code"),
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
                                        onChanged: (value) {
                                        },

                                        enable: true,
                                        etext: validateFileds &&
                                            _macIdController.text
                                                .trim()
                                                .isEmpty
                                            ? "Please Enter MAC ID "
                                            : "",
                                      ),

                                      Visibility(
                                          visible: !enableClientField,
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
                                                //POP UP GOES HERE

                                                result = await GetClientByMac(context,macId: _macIdController.text.toString());
                                                bool clientAvaliable = result[0];
                                                Map<String,dynamic> ClientDetails = result[1];
                                                print("clientAvaliable : $clientAvaliable");
                                                print("ClientDetails : $ClientDetails");


                                                if(clientAvaliable && ClientDetails.isNotEmpty){
                                                  printFunc("Client List : $clientList");
                                                  clientList.add({
                                                    "id": null,
                                                    "name": "Deselect",
                                                    "address": "",
                                                    "contactNumber": "",
                                                    "email": "",
                                                    "contactPerson": "",
                                                    "discription": "",
                                                    "createdBy": null,
                                                    "code":""
                                                  });
                                                  clientListIntoMap();
                                                  setState(() {});

                                                  ClientName.setText = ClientDetails['name'];
                                                  ClientName.setobj = {
                                                    "id": ClientDetails['id'],
                                                    "name": ClientDetails['name'],
                                                    "address": ClientDetails['address'],
                                                    "contactNumber": ClientDetails['contactNumber'],
                                                    "email": ClientDetails['email'],
                                                    "contactPerson": ClientDetails['contactPerson'],
                                                    "discription":ClientDetails['discription'],
                                                    "createdBy": ClientDetails['createdBy'],
                                                    "code":ClientDetails['code']
                                                  };


                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Column(
                                                            children: [
                                                              Text("CLIENT FOUND",style: TextStyle(color: darkBg,fontSize: 24,fontWeight: FontWeight.w800,shadows: [Shadow(color: Colors.black,blurRadius: 0.4)]),),
                                                              Divider(color: darkBg,thickness: 0.5,)
                                                            ],
                                                          ),
                                                          content: Text(
                                                            "This Device is Assigned to ${ClientDetails['name']}. Do you want too?",style: TextStyle(color: darkBg,fontWeight: FontWeight.w500,),),
                                                          actions: [
                                                            //Continue btn
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                //Go back
                                                                enableClientField = true;
                                                                Navigator.of(context).pop();                                                            //Save Log API
                                                                setState(() { });
                                                              },
                                                              child: Text("Continue",style: TextStyle(fontSize: 16),),
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(18)
                                                                      )
                                                                  )
                                                              ),
                                                            ),
                                                            //Assign new Btn
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                enableClientField = true;
                                                                Navigator.of(context).pop();
                                                                setState(() { });
                                                              },
                                                              child: Text("Assign New",style: TextStyle(fontSize: 16),),
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(darkBg),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(18)
                                                                      )
                                                                  )
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      }
                                                  );
                                                }
                                                else if(clientAvaliable && ClientDetails.isEmpty){
                                                  enableClientField = true;
                                                  ShowSnackBarMessage(context, 'No Client is Assigned!', null);
                                                  setState(() {});

                                                }
                                                else if(!clientAvaliable){
                                                  enableClientField = false;
                                                  ShowSnackBarMessage(context, 'No MacID found!', false);
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
                                ],
                              ),
                            ),

                            //Client Name
                            enableClientField
                            ? Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: GestureDetector(
                                child: PrimeryDropDownButton(
                                  isEnabled: true,
                                  tail: ErrorContainer(
                                      show: validateFileds && ClientName.getText== "",
                                      errorMsg: "Please Select the Client"),
                                  mainText: "SELECT CLIENT" ,
                                  text: ClientName.Text != "" ? ClientName.getText : "Select Client Name",
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: darkBg,
                                  ),
                                  press: () async {
                                    await BottomSheet_Widget(context, [
                                      MapListItemBuilder(
                                          listItems: AllClient,
                                          press: () {},
                                          selected: ClientName
                                      )
                                    ]);
                                    setState(() {});
                                  },
                                ),
                              ),
                            )
                            : SizedBox(),
                            //submit btn
                            enableClientField
                            ? Center(
                              child: Container(
                                width: screenSize.width / 3,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<
                                        Color>(darkBg),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                20))),
                                  ),
                                  onPressed: () async{
                                    printFunc("DEMO DEMO ClientName : ${ClientName.getobj['code'].toString()}");
                                    validateFields();
                                    if(!validateFileds){
                                       await scanAndConnect();
                                      isCustomerIDSent = await sendCustomerID(ClientName.getobj['code'].toString());
                                     if(isCustomerIDSent){
                                       await disconnect();
                                       await saveClient(context,
                                         macId: _macIdController.text,
                                         clientId: ClientName.getobj['id'].toString(),
                                       );
                                       Navigator.popUntil(context, (route) => route.isFirst);
                                     }
                                    }
                                    setState(() {});


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
                            )
                            : SizedBox(),

                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateFields() {
    bool hasEmpty = _macIdController.text.trim().isEmpty;
    if(hasEmpty && ClientName.getText == ""){
      setState(() {
        validateFileds = true;
      });
    }

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
           // timeoutTimer?.cancel();
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
           deviceName = device!.advName;
         });
         printFunc("DEmo is device Connected enableSubmit: $enableSubmit \n NotConnected :  $NotConnected  ");
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
       await FlutterBluePlus.stopScan();

       printFunc("${_macIdController.text} is not found");
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         content: Text(
           "${_macIdController.text} is not found",
           style: TextStyle(color: Colors.white),
         ),
         backgroundColor: Colors.redAccent,
       ));
     }

     printFunc("DEMO STReet : $NotConnected");
     // timeoutTimer?.cancel();
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

    printFunc("${_macIdController.text} is disconnected");
  }


  Future<bool> sendCustomerID(String custIdCtrl) async {
    if (configChar == null) {
      printFunc("Characteristic is null, can't send customer ID.");
      return false;
    }

    try {
      int customerID = int.parse(custIdCtrl.trim());

      if (customerID < 0 || customerID > 99) {
        printFunc("Customer ID out of bounds: $customerID");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Customer ID must be between 0 and 99")),
        );
        return false;
      }

      // Create 5-byte packet
      List<int> data = List.filled(5, 0);
      data[0] = '{'.codeUnitAt(0);
      data[1] = 'C'.codeUnitAt(0);
      data[2] = customerID & 0xFF;
      data[3] = (customerID >> 8) & 0xFF;
      data[4] = '}'.codeUnitAt(0);

      printFunc("Customer ID packet: $data");

      await configChar!.write(data);
      printFunc("Customer ID sent successfully");
      return true;
    } catch (e) {
      printFunc("Failed to send customer ID: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid Customer ID: $e")),
      );
      return false;
    }
  }


  @override
  void dispose() {
    _macIdController.dispose();
    super.dispose();
  }
}

// QR CODE AND BARCODE
/*Center(
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    scannedQR == null
                        ? "No QR code scanned yet."
                        : "Scanned: $scannedQR",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScannerScreen(),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          scannedQR = result;
                        });
                      }
                    },
                    child: Text("Scan QR"),
                  ),

                  Text(
                    scannedResult == null
                        ? "No QR code scanned yet."
                        : "Scanned: ${scannedResult}",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarcodeScannerScreen(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          scannedResult = result; // Show scanned code + type
                        });
                      }
                    },
                    child: Text("Scan Barcode / QR"),
                  ),
                ],
              ),

            ),*/