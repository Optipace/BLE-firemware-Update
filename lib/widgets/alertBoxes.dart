import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

showAlertNavigtorLogout(BuildContext context, String type, String msg, Function Action1, Function Action2) {
  // Create button
  getSize(context);
  Widget cancleButton = ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFC62828)),
    child: Text(
      "NO",
      style: TextStyle(fontSize: 12, fontFamily: baseFont),
    ),
    onPressed: Action2 as void Function()?,
  );
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2E7D32)),
    child: Text(
      "YES",
      style: TextStyle(fontSize: 12, fontFamily: baseFont),
    ),
    onPressed: Action1 as void Function()?,
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: lightBg,
    elevation: 5,
    shadowColor: darkBg,
    title: Text(
      type,
      style: TextStyle(fontSize: 18, color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w800),
    ),
    content: Text(
      msg,
      style: TextStyle(fontSize: 18, color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w500),
    ),
    actions: [
      okButton,
      cancleButton,
    ],
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: alert);
    },
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> ShowSnackBarMessage(
    BuildContext context, String message, bool? type) {
  Color bgColor;
  Color textColor;
  IconData icon;

  if (type == true) {
    // Success
    bgColor = successBg;
    textColor = successText;
    icon = CupertinoIcons.checkmark_alt_circle_fill;
  } else if (type == false) {
    // Error
    bgColor = errorBg;
    textColor = errorText_msg;
    icon = CupertinoIcons.xmark_octagon_fill;
  } else {
    // Info
    bgColor = infoBg;
    textColor = infoText;
    icon = CupertinoIcons.info_circle_fill;
  }

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
                fontFamily: baseFont,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: bgColor,
      elevation: 6,
      margin: EdgeInsets.all(16),
      duration: Duration(milliseconds: 2000),
    ),
  );
}
