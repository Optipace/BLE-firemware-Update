import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

import '../../widgets/alertBoxes.dart';

Future<Map<String, dynamic>> getFirmwareList(BuildContext context,
    {required String active}) async {
  Map<String, dynamic> firmwareList = {};
  final requestBody = {
    "active": active,
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
