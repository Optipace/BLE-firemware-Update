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

// Error Color
Color errorText = Color(0xFFCD5C5C);

// Color for cards
Color SuccessCard = Color.fromRGBO(220, 240, 255, 1.0); // soft light blue
Color SuccessCardText = Color.fromRGBO(80, 140, 200, 1.0); // medium blue (text/icon)

Color FailureCard = Color.fromRGBO(245, 235, 250, 1.0); // soft lavender/grayish
Color FailureCardText = Color.fromRGBO(120, 90, 160, 1.0); // muted purple (text/icon)





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



