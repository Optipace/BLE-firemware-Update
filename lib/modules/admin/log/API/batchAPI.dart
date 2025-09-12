import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<List<dynamic>> getLogsByBatchId(BuildContext context,
    {required String bacthId}) async {
  List<dynamic> finalResponse = [];
  List<Map<String, dynamic>> FormattedLogs = [{}];

  final requestBody = {"batchId": bacthId};

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.getAllBatchDetailLogResponse,
      bodyOrParams: requestBody,
      onSuccess: (data) async {
        printFunc("API getAllBatchDetailLogResponse response : $data");
        if (data != null && data['logs'] != null) {
          finalResponse.add({
            "TotalCount": data['totalCount'],
            "SuccessCount": data['sucessCount'],
            "FailureCount": data['failureCount']
          });

          var logs = data['logs'];
          FormattedLogs.clear();
          for (var log in logs) {
            FormattedLogs.add({
              "empId": log['employee']['employeeId'].toString(),
              "Name": log['employee']['employeeName'].toString(),
              "status": log["status"] == "Y" ? "Success" : "Failure",
              "mac_Id": log['motherBoardId'],
              "DeviceID": log['batch']['configuration']['device']['deviceName'],
              "Batch": log['batch']['batchName'],
              "Config": log['batch']['configuration']['name'],
              "firm_version": log['batch']['firmware']['versionName'],
              "Date-Time": log['actionTimeStamp'],
              "reason": log['message']
            });
          }

          finalResponse.add(FormattedLogs);
        }
      });
  return finalResponse;
}
