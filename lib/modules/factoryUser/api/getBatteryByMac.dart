import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<List<dynamic>> getBatteryByMac(BuildContext context,
    {required String macID}) async {
  Map<String, dynamic> BatteryDetails = {};
  bool isSuccess = false;

  final requestBody = {"macId": macID};

  await ApiService.callApi(
    context: context,
    method: 'POST',
    endpoint: ApiEndpoints.batteryNobyMac,
    bodyOrParams: requestBody,
    onSuccess: (data) async {
      printFunc("Battery Details : $data");

      if (data != null && data['batteryDetail'] != null) {
        BatteryDetails = {
          "macId": data['macId'],
          ...data['batteryDetail'],
        };
      }
      isSuccess = true;
    },
    errorDisplay: true,
  );

  return [isSuccess, BatteryDetails];
}
