import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<Map<String, Map<String, Object>>> getDeviceTypes(BuildContext context) async {
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

  return deviceTypes;

  await ApiService.callApi(
      context: context,
      method: 'GET',
      endpoint: ApiEndpoints.yetToDevelop,
      headerAuth: true,
      errorDisplay: false,
      onSuccess: (data) async {
        printFunc("Devcie Types responce :$data");
        deviceTypes.clear();
        for (Map device in data) {
          deviceTypes[device["name"]] = data;
        }
      });

  return deviceTypes;
}
