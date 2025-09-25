import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/getNumberModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/factoryUser/api/saveLog.dart';
import 'package:tracker_firmware/modules/login/login_screen.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

var screenSize;

void printFunc(var str) {
  // if(isTesting)
  // print(str.toString());
  // dev.log(str.toString());
  // debugPrint(str.toString());
}

void printLog(var str) {
  // if(isTesting)
  // printFunc(str.toString());
  // dev.log(str.toString());
  // debugPrint(str.toString());
}

void requestPermission() async {
  if (await Permission.storage.request().isGranted) {
  } else {
    await Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
    } else {
      await Permission.storage.request();
    }
  }
  if (!await Permission.locationWhenInUse.isGranted) {
    await Permission.locationWhenInUse.request();
  }

  if (!await Permission.location.isGranted) {
    await Permission.location.request();
  }
  if (!await Permission.manageExternalStorage.status.isGranted) {
    await Permission.manageExternalStorage.request();
  }
  if (!await Permission.mediaLibrary.isGranted) {
    await Permission.mediaLibrary.request();
  }

  if (!await Permission.camera.status.isGranted) {
    await Permission.camera.request();
  }
  // if (!await Permission.phone.status.isGranted) {
  //   await Permission.phone.request();
  // }
  if (!await Permission.accessMediaLocation.status.isGranted) {
    await Permission.accessMediaLocation.request();
  }
  if (!await Permission.location.status.isGranted) {
    await Permission.location.request();
  }
  if (!await Permission.phone.status.isGranted) {
    await Permission.phone.request();
  }
  if (!await Permission.locationWhenInUse.status.isGranted) {
    await Permission.locationWhenInUse.request();
  }
  // LocationPermission permission;
  //
  // permission = await Geolocator.checkPermission();
  // if (permission == LocationPermission.denied) {
  //   permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     // Permissions are denied, next time you could try
  //     // requesting permissions again (this is also where
  //     // Android's shouldShowRequestPermissionRationale
  //     // returned true. According to Android guidelines
  //     // your App should show an explanatory UI now.
  //     return Future.error('Location permissions are denied');
  //   }
  // }
}

Future<int> checkInternet(context) async {
  // return 0;
  try {
    // showAlertProgres(context, "Checking Connection");

    final result = await InternetAddress.lookup('google.com');
    // Navigator.of(context, rootNavigator: true).pop();

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //print_func(connected");
      // Navigator.of(context, rootNavigator: true).pop();
      return 0;
    }
    return 1;
  } on SocketException catch (_) {
    printFunc(" exception not connected");
    // Navigator.of(context, rootNavigator: true).pop();
    return 1;
  }
}

getSize(BuildContext context) {
  screenSize = MediaQuery.of(context).size;

  if (MediaQuery.of(context).size.width <= MediaQuery.of(context).size.height) {
    screenSize = MediaQuery.of(context).size;
  } else {
    screenSize.width = MediaQuery.of(context).size.width / 2;
    screenSize.height = MediaQuery.of(context).size.height;
  }
}


class ThreeDecimalInputFormatter extends TextInputFormatter {
  final RegExp _regExp =
      RegExp(r'^\d{0,2}(\.\d{0,3})?$'); // Adjust digits as needed

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

Future<dynamic> forceLogOut(BuildContext context) async {
  sharedPreferences = await SharedPreferences.getInstance();

  sharedPreferences.clear();
  UserData().clear();
  await setDeviceId();
  // Optionally navigate to login screen
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}

Future<dynamic> LogOutUser(BuildContext context) async {
  sharedPreferences = await SharedPreferences.getInstance();
  await syncLog(context);
  showAlertNavigtorLogout(context, "ALERT", "Are you sure you want to log out?",
      () async {
    Navigator.of(context, rootNavigator: true).pop();

    ApiService.performLogoutApiCall(context);
    await forceLogOut(context);
    final box = Hive.box<GetNumberModel>('$getNumberHiveBox');
    printFunc("Before logout : ${box.values}");

    await box.clear();
  }, () {
    Navigator.of(context, rootNavigator: true).pop();
  }, "Yes", "No");
}
