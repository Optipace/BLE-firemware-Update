import 'dart:ui';

import 'package:flutter/material.dart';

// Dark background
Color darkBg = Color(0xFF358A94);
// Color.fromRGBO(58, 80, 153, 1.0);
// Background Colors
Color successBg = Color(0xFF2E7D32); // Deep green
Color errorBg = Color(0xFFB00020); // Deep red
Color infoBg = Color(0xFF37474F); // Blue-grey

// Text/Icon Colors
Color successText = Color(0xFFE8F5E9); // Light greenish-white
Color errorText_msg = Color(0xFFFFEBEE); // Soft red-white
Color infoText = Color(0xFFECEFF1); // Light grey

// Light background
Color lightBg = Color.fromRGBO(234, 241, 251, 1.0);

Color second_lightBg = Color.fromRGBO(240, 245, 252, 1.0);

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

String baseFont = '';
String serviceHiveBox = 'ServiceBox';
String firmwareHiveBox = 'firmwareBox';
String batchHiveBox = 'batchBox';
String getNumberHiveBox = 'numberBox';
// String baseFont = 'Roboto';
// String baseFont = 'Inter  ';
// String baseFont = 'Poppins ';
Map<String, dynamic> serviceProfiles = {}; //await hiveService.readAllData();

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
    title: Text(type),
    content: Text(msg),
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

final appVersion = "1.0.0";
