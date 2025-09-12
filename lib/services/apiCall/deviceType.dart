import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

//////////////// NOT YET USED ///////////////////////////////////
Future<Map<String, Map<String, Object>>> getDeviceTypes(
    BuildContext context) async {
  var deviceTypes = {
    "B6": {
      "id": 1,
      "name": "B6",
      "priority": 1,
    },
    "B9": {
      "id": 2,
      "name": "B9",
      "priority": 2,
    },
    "B12": {"id": 3, "name": "B12", "priority": 3},
  };

  // return deviceTypes;
  deviceTypes.clear();
  await ApiService.callApi(
      context: context,
      method: 'GET',
      endpoint: ApiEndpoints.getAllDeviceTypes,
      headerAuth: true,
      errorDisplay: false,
      onSuccess: (data) async {
        printFunc("Devcie Types responce :$data");
        deviceTypes.clear();
        for (Map device in data) {
          deviceTypes[device["deviceName"]] = {
            "id": device["id"],
            "name": device["deviceName"],
            "deviceName": device["deviceName"],
          };
        }
      });

  return deviceTypes;
}
//////////////////////////////////////////////////////////////////////

Future<bool> addNewDeviceType(
  BuildContext context, {
  required String name,
  required String description,
}) async {
  final body = {"deviceName": name, "discription": description};

  bool isSuccess = false;

  await ApiService.callApi(
    context: context,
    method: 'POST',
    endpoint: ApiEndpoints.saveDeviceTypes,
    bodyOrParams: body,
    onSuccess: (data) {
      ShowSnackBarMessage(context, 'New Series added successfully!', true);
      Navigator.of(context).pop();
      isSuccess = true;
    },
  );
  printFunc("DEMODEMO : $isSuccess");

  return isSuccess;
}
