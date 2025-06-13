import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/login/login_screen.dart';
import 'package:tracker_firmware/services/apiCall/logIn.dart';

class splashScreen extends StatefulWidget {
  @override
  splashScreenState createState() => splashScreenState();
}

class splashScreenState extends State<splashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  //Inistiating and navigating to login Screen
  @override
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    Timer(Duration(seconds: 4), () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        requestPermission();
        setDeviceId();
        getSize(context);
        isSession = await checkSession();
        if (isSession) {
          printFunc("Yes Session is active");
          printFunc(await getUserDataFromSharedPref());
          await setUserData();

          UserData userData = new UserData();
          printFunc("Userdata from Userdata() ${userData.toJson()}");
          navigateToDashBoard(context, int.tryParse(userData.designationCode) ?? 1);
        }
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  //clearing the Controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBg, lightBg], // Your gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TRACKER FIRMWARE ",
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                wordSpacing: 1.5,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "PROVISIONING APP",
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                wordSpacing: 1.5,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
