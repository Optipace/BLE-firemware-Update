import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/login/login_screen.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';

class FieldMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: "Feild-User \n DashBoard",
        userProfile: true,
        onLogout: (){
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
        child: Center(
          child: Text("FIELD USER MENU"),
        )
    );
  }

}