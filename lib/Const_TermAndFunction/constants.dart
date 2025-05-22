import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entiry/userData.dart';

// Dark background
Color darkBg = Color(0xFF358A94);
// Color.fromRGBO(58, 80, 153, 1.0);

// Light background
Color lightBg = Color.fromRGBO(234, 241, 251, 1.0);

// buttonColor
Color primaryButton = Color.fromRGBO(53, 138, 148, 1.0);
Color primaryButtonText = Colors.white;

// primary Text
Color primaryText = Color.fromRGBO(44, 62, 80, 1.0);
Color secondaryText = Color.fromRGBO(108, 122, 137, 1.0);

//Border Or Icon
Color outlineColor = Color.fromRGBO(162, 195, 200, 1.0);

String baseFont = 'Crimson';

bool isSession = false;

showAlertDialog(
    BuildContext context,
    String type,
    String msg,
    ) {
  Widget okButton = Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.blue,
      border: Border.all(
        color: Colors.lightBlue,
        width: 1,
      ),
    ),
    height: 35,
    // width:30,
    padding: EdgeInsets.all(0),
    child: TextButton(
      child: Text(
        "ok",

        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
      onPressed: () {

        Navigator.of(context, rootNavigator: true).pop();
        // Navigator.of(context).pop();
      },
    ),
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      type
    ),
    content: Text(
      msg

    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (context) {
      return BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: alert);
    },
  );
}

Map<String, dynamic> designationRoles = {
  "Admin": {
    "id": 1,
    "name": "admin",
    "priority": 1,
  },
  "Factory User": {
    "id": 2,
    "name": "Factory User",
    "priority": 2,
  },
  "Field User":{
    "id":3,
    "name":"Field User",
    "priority":3
  },
};


