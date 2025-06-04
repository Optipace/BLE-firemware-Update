import 'dart:ui';

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
