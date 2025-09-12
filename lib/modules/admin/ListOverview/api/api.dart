import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

// Firmware
Future<bool> setFirmwareStatus(BuildContext context,
    {required String id, required String status}) async {
  final requestBody = {"id": id, "active": status};

  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'PUT',
      endpoint: ApiEndpoints.updateFirmwareStatus,
      bodyOrParams: requestBody,
      onSuccess: (data) {
        if (status == 'Y') {
          ShowSnackBarMessage(
              context, 'Firmware Activated successfully!', true);
          isSuccess = true;
        } else {
          ShowSnackBarMessage(
              context, 'Firmware De-activated successfully!', true);
          isSuccess = true;
        }
      });
  return isSuccess;
}

//Config
Future<bool> setconfigStatus(BuildContext context,
    {required String id, required String status}) async {
  final requestBody = {"id": id, "active": status};

  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'PUT',
      endpoint: ApiEndpoints.updateConfigStatus,
      bodyOrParams: requestBody,
      onSuccess: (data) {
        if (status == 'Y') {
          ShowSnackBarMessage(context, 'Config Activated successfully!', true);
          isSuccess = true;
        } else {
          ShowSnackBarMessage(
              context, 'Config De-activated successfully!', true);
          isSuccess = true;
        }
      });
  return isSuccess;
}

//Batches
Future<bool> setBacthesStatus(BuildContext context,
    {required String id, required String status}) async {
  final requestBody = {"id": id, "active": status};

  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'PUT',
      endpoint: ApiEndpoints.updateBatchStatus,
      bodyOrParams: requestBody,
      onSuccess: (data) {});
  return isSuccess;
}
