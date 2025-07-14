import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<bool> saveLog(BuildContext context,{
  required String DateAndTime,
  required String deviceID,
  required String macID,
  required String empID,
  required String batchID,
  required String status,
  required String reason
})async {
  bool isSuccess = false;
  final body = {
    "mobileDeviceId": deviceID,
    "motherboardId": macID,
    "actionTimestamp": DateAndTime,
    "status": status,
    "message": reason,
    "softwareVersion": batchID,
    "employeeId": empID
  };

  printFunc("In Save Log API : ${DateAndTime},${deviceID},${macID},${empID},${batchID},${status},${reason}");

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.saveLog,
      bodyOrParams: body,
      onSuccess: (data){
        printFunc("LOG SAVED!!!!!");
        isSuccess =true;
      }
  );
  return isSuccess;
}