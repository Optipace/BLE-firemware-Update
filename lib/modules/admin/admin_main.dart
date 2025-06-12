import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/ListOverview/listOverview.dart';
import 'package:tracker_firmware/modules/admin/log/admin_logs.dart';
import 'package:tracker_firmware/modules/admin/newUser/adminNewUser.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

import 'FirmwareSettings/addFirmware.dart';

class AdminMain extends StatefulWidget {
  @override
  State<AdminMain> createState() => AdminMainState();
}

class AdminMainState extends State<AdminMain> {
  // Controleers for New Battery
  TextEditingController _bname = TextEditingController();
  TextEditingController _relaseNote = TextEditingController();
  TextEditingController _upperThershold = TextEditingController();
  TextEditingController _lowerThershold = TextEditingController();
  TextEditingController _upperVoltage = TextEditingController();
  TextEditingController _lowerVoltage = TextEditingController();

  bool validateUser = false;
  bool pluss = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: 'ADMIN\nDASH-BOARD',
        userProfile: true,
        child: Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // View logs
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/viewLog.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "View Log",
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AdminLogs()));
                      }),
                  SizedBox(
                    height: 15,
                  ),

                  // Manage users
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/modify.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "Modify User",
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AdminNewUser()));
                      }),
                  SizedBox(
                    height: 15,
                  ),

                  //  Firmware
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/modify.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "Firmware settings",
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AddNewFirmware()));
                      }),
                  SizedBox(
                    height: 15,
                  ),

                  // List of Firmware, profiles,Battery, batches,
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/to-do-list.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "System Overview",
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => listOverview()));
                      }),
                  SizedBox(
                    height: 25,
                  ),

                  //----logout----------
                  /* SizedBox(
                      width: 350,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () {
                            showAlertNavigtorLogout(context,
                                "ALERT",
                                "DO YOU REALLY NEED TO LOG-OUT",
                                    (){
                                  sharedPreferences.clear();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => LoginScreen()),
                                        (Route<dynamic> route) => false,  // Remove all previous routes
                                  );

                                },
                                    (){
                                  Navigator.pop(context);
                                }
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: darkBg,
                              elevation: 8,
                              shadowColor: darkBg,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(
                                      color: Colors.black,
                                      width: 0.5
                                  )
                              )
                          ),
                          child: Text("LOGOUT",
                              style: TextStyle(
                              fontFamily: baseFont,
                              fontSize: 22,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w800,
                              shadows: [Shadow(
                        color: Colors.black,
                        blurRadius: 0.1
                    )]
                ),
              ),
            ),
          ),*/
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: !pluss,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            pluss = !pluss;
                          });
                          await BottomSheet_Widget(context, color: lightBg, [
                            Container(
                              height: size.height / 1.5,
                              width: size.width,
                              color: lightBg,
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Enter Battery Details!",
                                        style: TextStyle(
                                            fontFamily: baseFont,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 24,
                                            color: darkBg,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 0.5,
                                                  offset: Offset(0.5, 0.5))
                                            ]),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Battery Name
                                            LabelText(text: "Battery Name :"),
                                            TextFeildNewUser(
                                              hintText: "Enter Battery Name",
                                              Controller: _bname,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: validateUser && _bname.text.trim().isEmpty
                                                  ? "Please Enter the Phone Number"
                                                  : "",
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            // Relase Note
                                            LabelText(text: "Relase Date"),
                                            TextFeildNewUser(
                                              hintText: "Enter Relase Date",
                                              Controller: _relaseNote,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: validateUser && _relaseNote.text.trim().isEmpty
                                                  ? "Please Enter the Phone Number"
                                                  : "",
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            // Upper thershold
                                            LabelText(text: "Upper Thershold"),
                                            TextFeildNewUser(
                                              hintText: "Enter Upper Thershold",
                                              Controller: _upperThershold,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: validateUser && _upperThershold.text.trim().isEmpty
                                                  ? "Please Enter the Phone Number"
                                                  : "",
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            // Lower Temp
                                            LabelText(text: "Lower Thershold"),
                                            TextFeildNewUser(
                                              hintText: "Enter Lower Thershold",
                                              Controller: _lowerThershold,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: validateUser && _lowerThershold.text.trim().isEmpty
                                                  ? "Please Enter the Phone Number"
                                                  : "",
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            // Upper Voltage
                                            LabelText(text: "Upper Voltage"),
                                            TextFeildNewUser(
                                              hintText: "Enter Upper Voltage",
                                              Controller: _upperVoltage,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: validateUser && _upperVoltage.text.trim().isEmpty
                                                  ? "Please Enter the Phone Number"
                                                  : "",
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            // Lower Voltage
                                            LabelText(text: "Lower Voltage"),
                                            TextFeildNewUser(
                                              hintText: "Enter Lower Voltage",
                                              Controller: _lowerVoltage,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: validateUser && _lowerVoltage.text.trim().isEmpty
                                                  ? "Please Enter the Phone Number"
                                                  : "",
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Add Btn
                                      manageUserBtn(
                                          text: "Add Battery",
                                          onPress: () {
                                            ValidateUser();
                                            setState(() {});
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ]);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(lightBg),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: darkBg, width: 1),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(Size(size.width / 3.2, 30))),
                        child: Text(
                          "Add Battery",
                          style: TextStyle(
                              color: darkBg, fontSize: 18, fontFamily: baseFont, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            pluss = !pluss;
                          });
                          ShowSnackBarMessage(context, 'User Updated Successfully!!', false);

                          setState(() {});
                        },
                        iconSize: 55,
                        icon: Container(
                          decoration: BoxDecoration(
                            color: darkBg, // background color
                            shape: BoxShape.circle, // circular background
                          ),
                          width: 60,
                          height: 60,
                          // space inside the circle
                          child: Icon(
                            Icons.add,
                            color: lightBg, // icon color
                            size: 26,
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void ValidateUser() {
    final Controllers = [
      _bname,
      _relaseNote,
      _upperThershold,
      _upperVoltage,
      _lowerThershold,
      _lowerVoltage,
    ];

    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);
    printFunc("has Next : $hasEmpty");
    setState(() {
      validateUser = hasEmpty;
    });

    // Future Delayed

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        validateUser = false;
      });
    });
  }
}
