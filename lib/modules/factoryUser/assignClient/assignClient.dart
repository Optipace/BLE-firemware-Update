import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/api/assignClient.dart';
import 'package:tracker_firmware/modules/factoryUser/api/getClientByMac.dart';
import 'package:tracker_firmware/modules/factoryUser/api/hardWareNumber.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/barcode.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
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




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      clientList = await getAllClients(context);
      clientListIntoMap();
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
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "MAC-ID  ",
                                style: TextStyle(
                                    color: darkBg,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(color: Colors.black, blurRadius: 0.3)
                                    ]),
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

                                      //Search btn
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

                                              onPressed: () async{
                                                validateFields();

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
                                                    "createdBy": ClientDetails['createdBy']
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
                                                                  ShowSnackBarMessage(context, 'Client Assigned successfully!', true);
                                                                  Navigator.of(context).pop();                                                            //Save Log API
                                                                  Navigator.of(context).pop();                                                            //Save Log API
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
                                                                  setState(() {

                                                                  });
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

                                                }else if(!clientAvaliable){
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
                                          )
                                      )

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
                                    validateFields();
                                    if(!validateFileds){
                                      await saveClient(context,
                                        macId: _macIdController.text,
                                        clientId: ClientName.getobj['id'].toString(),
                                      );
                                      ShowSnackBarMessage(context, 'Client is Assigned Successfully!', null);

                                    }
                                    setState(() {});
                                    Navigator.popUntil(context, (route) => route.isFirst);
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