import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/admin/admin_main.dart';
import 'package:tracker_firmware/modules/factoryUser/factory_user_main.dart';
import 'package:tracker_firmware/modules/fieldOfficer/field_user_main.dart';

Future<bool> logInAPICall(BuildContext context, String phoneNum, String password) async {
  var request = {
    "mobileNumber": phoneNum,
    "password": password,
    "deviceId": "DEVICE185", // sharedPreferences.getString("UUID"),
  };

  request={
    "mobileNumber":"9455555513",
    "password":"abc@123",
    "deviceId":"DEVICE185"
  };
  phoneNum="9455555513";

  printFunc("DEMO REQUEST LOGIN API BODY : $request");
  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.login,
      headerAuth:false,
      bodyOrParams: request,
      onSuccess: (data) async {
        printFunc("Log in responce :$data");
        setTokenInfo(data);
        sharedPreferences.setBool("user_logged_in", true);

        await setSharedPreference(await getEmployeeDetail(context, phoneNum));

        await setUserData();
        await setDeviceId();

        UserData userData = new UserData();
        printFunc("userData after log in set userdata: ${userData.toString()}");
        navigateToDashBoard(context, int.tryParse(userData.designationCode) ?? 2);
        return true;
      });
  return false;

  /////////////////// to by pass /////////////////////////////
  /*

request={
  "mobileNumber":"1111111111",
  "password":"abd@123",
  "deviceId":"DEVICE185"
};


  var data = {"accessToken": "eyJhbGciow4oPES4M", "refreshToken": "a7314686-d08e-409d-8de6-503b00fc6586"};

  printFunc("Log in responce :${data}");
  setTokenInfo(data);
  sharedPreferences.setBool("user_logged_in", true);

  await setSharedPreference(await getEmployeeDetail(context, phoneNum));

  await setUserData();
  await setDeviceId();

  UserData userData = new UserData();
  printFunc("userData after log in set userdata: ${userData.toString()}");
  navigateToDashBoard(context, int.tryParse(userData.designationCode) ?? 2);
  return true;
  */
  ///////////////////// to by pass /////////////////////////////
}

Future<Map<String, dynamic>> getEmployeeDetail(BuildContext context, String contactNumber) async {
  sharedPreferences = await SharedPreferences.getInstance();
  //////////////////////// to bypass ////////////////////////
  // return {
  //   'userId': 'U12345',
  //   'name': 'John Doe',
  //   'email': 'john.doe@example.com',
  //   'phone': '+91$contactNumber',
  //   'designationCode': "${((int.parse(contactNumber) / 1111111111).round())}",
  //   'empRegisteredId': 'EMP56789',
  //   'designation': "Designation ${((int.parse(contactNumber) / 1111111111).round())}",
  //   'status': 'Active',
  //   'deviceId': 'ahdsjsdhvdshviu',
  // };
  var request = {
    "contact": contactNumber,
  };
  // String endPoint = "";
  printFunc("DEMO REQUEST get user data API BODY : $request");
  Map<String, dynamic> empData = {};
  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.getProfileByContact,
      bodyOrParams: request,
      headerAuth: true,
      onSuccess: (data) async {
        printFunc("User data : $data");
        empData = {
          "userId": data["id"],
          "status": data["empActiveEnum"],
          "name": data["name"],
          "empRegisteredId": data["empRegisteredId"],
          "email": data["email"],
          "phone": contactNumber,
          "createdBy": data["createdBy"],
          "modifiedBy": data["modifiedBy"],
          "deviceId": data["deviceId"] ?? "abc",
          // "empDetailActiveEnum": data["empDetailActiveEnum"],
          "designationCode": data["designationResponce"]["id"],
          "designation": data["designationResponce"]["name"],
        };
// data :
//   {
//         "id": 3,
//         "empActiveEnum": "Y",
//         "name": "Amar ",
//         "empRegisteredId": "EMP20250058",
//         "email": "levix.doe@example.com",
//         "createdBy": 1,
//         "modifiedBy": 2,
//         "empDetailActiveEnum": "Y",
//         "designationResponce": {
//         "id": 2,
//         "name": "Field_workers",
//         "priority": 2
//       }
//    }

//required format
// {
//   'userId': 'U12345',
//         'name': 'John Doe',
//         'email': 'john.doe@example.com',
//         'phone': '+91$contactNumber',
//         'designationCode': "${((int.parse(contactNumber) / 1111111111).round())}",
//         'empRegisteredId': 'EMP56789',
//         'designation': getDesgination(contactNumber),
//         'status': 'Active',
//         'deviceId': 'ahdsjsdhvdshviu',
//       };
        printFunc("User data required : $empData");
      });
  return empData;
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