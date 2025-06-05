import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:platform_device_id/platform_device_id.dart';

late SharedPreferences sharedPreferences;

Future<bool> checkSession() async {
  // await Database();

  bool isPreferenceCreated = await isSharedPreferenceCreated();
  if (isPreferenceCreated) {
    sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getBool('user_logged_in') ?? false;
  } else {
    await createSharedPreference();
    return false;
  }
}

Future<bool> isSharedPreferenceCreated() async {
  sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.containsKey('user_logged_in');
  // return await getUserData();
}

Future<void> createSharedPreference() async {
  sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool('user_logged_in', false);
}

Future<bool> setUserData() async {
  Map<String, dynamic> userinfo = await getUserData();
  // userinfo["deviceId"]=userinfo["UUID"];
  UserData().fromJson(userinfo);

  return true;
}

Future<bool> setSharedPreference(Map<String, dynamic> userinfo) async {
  sharedPreferences = await SharedPreferences.getInstance();

  userinfo.forEach((key, value) {
    sharedPreferences.setString(key, value.toString().trim());
  });

  return true;
}

Future<Map<String, dynamic>> getUserData() async {
  sharedPreferences = await SharedPreferences.getInstance();
  // Get all keys
  final keys = sharedPreferences.getKeys();

  // Iterate through keys and retrieve values
  Map<String, dynamic> allData = {};
  for (String key in keys) {
    dynamic value = sharedPreferences.get(key);
    allData[key] = value;
    printFunc("Key: $key, Value: $value"); // Print the data
  }
  return allData; //sharedPreferences.getBool('user_logged_in') ?? false;
}

Future setDeviceId() async {
  sharedPreferences = await SharedPreferences.getInstance();

  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    // String? deviceId = await PlatformDeviceId.getDeviceId;

    sharedPreferences.setString("UUID", iosDeviceInfo.identifierForVendor ?? ' ');
  }
  // else if (Platform.isAndroid) {
  //   var androidDeviceInfo = await deviceInfo.androidInfo;
  //   printFunc(
  //       "DEMO DEVICEINFO :-------------------------------\n\n ${androidDeviceInfo.data}\n--------------------------------------------\n\n");
  //
  //   // String? deviceId = await PlatformDeviceId.getDeviceId;
  //   String? deviceId = "545";
  //
  //   sharedPreferences.setString("UUID", deviceId.toString());
  //   sharedPreferences.setString("osVersion", androidDeviceInfo.version.release.toString());
  //   sharedPreferences.setString(
  //       "deviceModel", "${androidDeviceInfo.brand.toString()} - ${androidDeviceInfo.model.toString()}");
  // }
  else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;

    String? deviceId = await PlatformDeviceId.getDeviceId;

    sharedPreferences.setString("UUID", deviceId.toString());
    sharedPreferences.setString("osVersion", androidDeviceInfo.version.release.toString());
    sharedPreferences.setString(
        "deviceModel", "${androidDeviceInfo.brand.toString()} - ${androidDeviceInfo.model.toString()}");

    // return androidDeviceInfo.androidId; // unique ID on Android
  }
  print("Device Information : \n"
      "uuid :  ${sharedPreferences.getString("UUID")}"
      "\n version : ${sharedPreferences.getString("osVersion")}"
      "\n model : ${sharedPreferences.getString("deviceModel")}");
}
