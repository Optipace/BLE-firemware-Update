import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/login/login_screen.dart';
import 'package:tracker_firmware/services/apiCall/logIn.dart';

class splashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<splashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _timer = Timer(Duration(seconds: 4), () {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    // Check if widget is still mounted before proceeding
    if (!mounted) return;

    try {
      // Perform non-context dependent operations first
      requestPermission();
      setDeviceId();

      // Check if still mounted before using context
      if (!mounted) return;

      getSize(context);
      isSession = await checkSession();

      if (isSession) {
        printFunc("Yes Session is active");
        printFunc("CHECK AUTH :: ${await ApiService.checkAuth(context) == true}");
        printFunc("CHECK Interenet :: ${await checkInternet(context) == 0}");


        if (!mounted) return;

        if (await checkInternet(context) == 0) {
          if (await ApiService.checkAuth(context) == true) {
            await setUserData();

            UserData userData = new UserData();
            printFunc("Userdata from Userdata() ${userData.toJson()}");

            if (!mounted) return;

            navigateToDashBoard(
                context, int.tryParse(userData.designationCode) ?? 1);
            return;
          }
        }
        else{
          await setUserData();

          UserData userData = new UserData();
          printFunc("Userdata from Userdata() ${userData.toJson()}");

          if (!mounted) return;

          navigateToDashBoard(
              context, int.tryParse(userData.designationCode) ?? 1);
          return;
        }
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));

    } catch (e) {
      printFunc("Error in splash navigation: $e");

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
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

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to prevent callback execution
    _controller.dispose();
    super.dispose();
  }
}