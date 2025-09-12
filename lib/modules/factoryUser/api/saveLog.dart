import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/dataBase/table_curl.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<bool> saveLog(BuildContext context,
    {required String DateAndTime,
    required String deviceID,
    required String macID,
    required String empID,
    required String batchID,
    required String status,
    required String reason}) async {
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

  printFunc(
      "In Save Log API : ${DateAndTime},${deviceID},${macID},${empID},${batchID},${status},${reason}");
  if (await checkInternet(context) == 0) {
    await ApiService.callApi(
        context: context,
        method: 'POST',
        endpoint: ApiEndpoints.saveLog,
        bodyOrParams: body,
        onSuccess: (data) {
          printFunc("LOG SAVED!!!!!");

          isSuccess = true;
        });
  } else {
    await insertIntoLogs(body);
    ShowSnackBarMessage(context, "Log locally saved", null);
  }
  return isSuccess;
}

Future<void> syncLog(BuildContext context) async {
  if (await checkInternet(context) == 0) {
    if (await hasLogs()) {
      for (var log in await getAllLogs()) {
        String msg =
            log["message"].toString().replaceAll("- offline", "").trim();
        if (await saveLog(context,
            DateAndTime: log["actionTimestamp"],
            deviceID: log["mobileDeviceId"],
            macID: log["motherboardId"],
            empID: log["employeeId"],
            batchID: log["softwareVersion"],
            status: log["status"],
            reason: "${msg} - offline")) {
          await deleteFromLogs(log);
          printFunc("I can pop here");
        }
      }
    }
  }
}
