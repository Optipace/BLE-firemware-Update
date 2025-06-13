import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/admin/admin_main.dart';
import 'package:tracker_firmware/modules/factoryUser/factory_user_main.dart';
import 'package:tracker_firmware/modules/fieldOfficer/field_user_main.dart';

Future<bool> logInAPICall(BuildContext context, String phoneNum, String password) async {
  var request = {
    "contact": phoneNum,
    "password": password,
    "deviceId": "DEVICE185", // sharedPreferences.getString("UUID"),
  };
  // String endPoint = "";
  // var request = json.encode(data);
  print("DEMO REQUEST LOGIN API BODY : $request");
  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.login,
      bodyOrParams: request,
      onSuccess: (data) async {
        // ShowSnackBarMessage(context, 'Logged out successfully.', true);
        setTokenInfo(data);
        sharedPreferences.setBool("user_logged_in", true);

        await setSharedPreference(await getEmployeeDetail(context, phoneNum) ?? {});

        await setDeviceId();
        await setUserData();
        UserData userData = new UserData();

        navigateToDashBoard(context, int.tryParse(userData.designationCode) ?? 2);
        return true;
      });
  return false;
}

Future<Map<String, dynamic>?> getEmployeeDetail(BuildContext context, String contactNumber) async {
  sharedPreferences = await SharedPreferences.getInstance();

  var request = {
    "contact": contactNumber,
  };
  // String endPoint = "";
  print("DEMO REQUEST LOGIN API BODY 2: $request");

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.getProfileByContact,
      bodyOrParams: request,
      headerAuth: false,
      onSuccess: (data) async {
        // ShowSnackBarMessage(context, 'Logged out successfully.', true);

        return data;
      });
  return {};
}

void navigateToDashBoard(BuildContext context, int designation_id) {
  if (designation_id == 1) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AdminMain()));
  } else if (designation_id == 2) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => FactoryMain()));
    return;
  } else if (designation_id == 3) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => FieldMain()));
    return;
  }
}
