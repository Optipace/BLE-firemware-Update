import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/admin/api/api.dart';
import 'package:tracker_firmware/modules/admin/log/admin_logs.dart';
import 'package:tracker_firmware/modules/admin/newUser/adminNewUser.dart';
import 'package:tracker_firmware/modules/login/login_screen.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';
import 'package:tracker_firmware/widgets/splash_screen.dart';

import '../../widgets/buttons.dart';
import 'FirmwareSettings/addFirmware.dart';

class AdminMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: 'ADMIN\nDASH-BOARD',
        userProfile: true,
        onLogout: () {
          showAlertNavigtorLogout(
              context, "ALERT", "DO YOU REALLY NEED TO LOG-OUT", () {
            sharedPreferences.clear();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (Route<dynamic> route) => false, // Remove all previous routes
            );
          }, () {
            Navigator.pop(context);
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                  icon: Image.asset(
                    'assets/image/viewLog.png',
                    width: 24,
                    height: 24,
                    color: darkBg,
                  ),
                  text: "View Log",
                  onPress: () {
                    Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => AdminLogs()));
                  }),
              SizedBox(
                height: 25,
              ),

              PrimaryButton(
                  icon: Image.asset(
                    'assets/image/modify.png',
                    width: 24,
                    height: 24,
                    color: darkBg,
                  ),
                  text: "Modify User",
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => AdminNewUser()));
                  }),
              SizedBox(
                height: 25,
              ),

              PrimaryButton(
                  icon: Image.asset(
                    'assets/image/modify.png',
                    width: 24,
                    height: 24,
                    color: darkBg,
                  ),
                  text: "Firmware settings",
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => AddNewFirmware()));
                  }),

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
        ));
  }
}
