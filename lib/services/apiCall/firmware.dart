import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

import '../../widgets/alertBoxes.dart';

Future<Map<String, dynamic>> getFirmwareList(BuildContext context,
    {required String active}) async {
  Map<String, dynamic> firmwareList = {};
  final requestBody = {
    "active" : active,
  };


  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.getAllFirmwareDetails,
      headerAuth: true,
      bodyOrParams: requestBody,
      onSuccess: (data) async {
        printFunc("Firmware data : $data");
        firmwareList.clear();
        for (var firmware in data) {
          firmwareList[firmware["versionName"]] = {
            "id": firmware["id"],
            "version": firmware["versionName"],
            "releaseNote":
                "${firmware["versionReleaseNote"]}-(${(firmware["versionReleasedDate"].toString().split("T"))[0]})",
            "versionName": firmware["versionName"],
            "file": firmware["file"],
            "active": firmware["active"],
          };
        }
        printFunc("firmwareList required : $firmwareList");
      });
  return firmwareList;
  firmwareList = {
    "2.0.3": {
      "id": 1234,
      "version": "2.0.3",
      "releaseNote": "29/05/2025",
      "versionName": "b6 2.0.3",
      "deviceTypeId": "1",
      "file": "Base64Data",
      "saved": false,
      "deviceType": "B6"
    },
    "2.0.2": {
      "id": 1235,
      "version": "2.0.2",
      "releaseNote": "28/04/2025",
      "versionName": "b6 2.0.2",
      "deviceTypeId": "1",
      "file": "Base64Data",
      "saved": false,
      "deviceType": "B6"
    },
    "2.0.12": {
      "id": 1236,
      "version": "2.0.12",
      "releaseNote": "15/04/2025",
      "versionName": "b6 2.0.3",
      "deviceTypeId": "1",
      "file": "Base64Data",
      "saved": false,
      "deviceType": "B6"
    },
    "2.0.1": {
      "id": 1237,
      "version": "2.0.1",
      "releaseNote": "29/03/2025",
      "versionName": "b6 2.0.3",
      "deviceTypeId": "1",
      "file": "Base64Data",
      "saved": false,
      "deviceType": "B6"
    },
    "1.0.3": {
      "id": 21234,
      "version": "1.0.3",
      "releaseNote": "01/03/2025",
      "versionName": "b6 2.0.3",
      "deviceTypeId": "2",
      "file": "Base64Data",
      "saved": false,
      "deviceType": "B6"
    },
    "1.0.2": {
      "id": 21235,
      "version": "1.0.2",
      "releaseNote": "18/02/2025",
      "versionName": "b6 2.0.3",
      "deviceTypeId": "2",
      "file": "Base64Data",
      "saved": false,
      "deviceType": "B6"
    },
    "1.0.1": {
      "id": 21236,
      "version": "1.0.1",
      "releaseNote": "11/02/2025",
      "versionName": "b6 2.0.3",
      "deviceTypeId": "2",
      "file": "Base64Data",
      "saved": false,
      "deviceType": "B6"
    },
    "1.0.0": {
      "id": 21237,
      "version": "1.0.0",
      "releaseNote": "05/02/2025",
      "versionName": "b6 2.0.3",
      "deviceTypeId": "2",
      "file": "Base64Data",
      "saved": false,
      "deviceType": "B6"
    },
  };
  return firmwareList;
}

Future<bool> addNewFirmware(
  BuildContext context, {
  required String versionName,
  required String versionCode,
  required String releaseNote,
  required String firmwareFile,
}) async {
  final requestBody = {
    "versionName": versionCode,
    "versionReleaseNote": releaseNote,
    "file": firmwareFile,
  };

  bool isSuccess = false;

  await ApiService.callApi(
    context: context,
    method: 'POST',
    endpoint: ApiEndpoints.saveFirmware,
    bodyOrParams: requestBody,
    onSuccess: (data) {
      ShowSnackBarMessage(context, 'Firmware added successfully!', true);
      isSuccess = true;
    },
  );

  return isSuccess;
}
