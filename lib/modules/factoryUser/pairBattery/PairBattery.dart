import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/api/getBatteryByMac.dart';
import 'package:tracker_firmware/modules/factoryUser/api/pairBattery.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/barcode.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/qr_code.dart';
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
                    //QR CODE
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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

                                          if(_macIdController.text != null){
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
                                                            ShowSnackBarMessage(
                                                                context,
                                                                'Battery Paired successfully!',
                                                                true);
                                                            Navigator.of(context)
                                                                .pop(); //Save Log API
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
                                            } else if (!batteryAvailable &&
                                                batteryDetail.isNotEmpty) {

                                              enableBarCode = true;
                                              ShowSnackBarMessage(context,
                                                  'No Battery is Paired!', true);
                                              setState(() {});
                                            } else {
                                              enableBarCode = false;
                                              _macIdController.clear();
                                            }
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
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRScannerScreen(title: "Scan Barcode"),
                                                ),
                                              );
                                              printFunc(
                                                  "DEMO RESULT : $result");

                                              if (result != null) {
                                                setState(() {
                                                  _batteryController.text =
                                                      result;
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
                                            onChanged: (value) {},
                                            enable: true,
                                            etext: validateFields &&
                                                    _batteryController.text
                                                        .trim()
                                                        .isEmpty
                                                ? "Please Enter Battery Serial number"
                                                : "",
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
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
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
                                          await saveMacandBattery(context,
                                              macId: _macIdController.text,
                                              BatterySerialNo:
                                                  _batteryController.text);
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
