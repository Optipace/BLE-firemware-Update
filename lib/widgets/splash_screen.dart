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
        child: Column(
          children: [
            // Main content - keeps its centered position
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DREAMFLY INNOVATION',
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        wordSpacing: 1.5,
                      ),
                    ),

                    SizedBox(height: 5.0),

                    Text(
                      'TRAKR PROVISONING ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        wordSpacing: 1.5,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            // Bottom text
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Powered by',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset(
                        'assets/image/logo.png',
                        width: 20,
                        height: 20,

                      ),
                      Text(
                        'Optipace',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                    ],
                  ),
                  Text(
                    'Version : 1.0.0',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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