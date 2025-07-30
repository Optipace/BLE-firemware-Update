import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<List<dynamic>> getLogsByDays(BuildContext context,{required int days}) async{
  List<dynamic> finalResponse = [];
  List<Map<String,dynamic>> FormattedLogs = [{}];

  final requestbody ={"days":days};

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.getAllLogsOnDays,
      bodyOrParams: requestbody,
      errorDisplay: false,
      onSuccess: (data)async{
        printFunc("API getAllLogsOnDays response : $data");
        printFunc("API getAllLogsOnDays response : ${data['logs'][1]['batch']['configuration']['device']['deviceName']}");

        if(data != null && data['logs'] != null){
          finalResponse.add({
            "TotalCount" : data['totalCount'],
            "SuccessCount" : data['sucessCount'],
            "FailureCount" : data['failureCount'],
          });

          var logs = data['logs'];
          FormattedLogs.clear();
          for(var log in logs){
            FormattedLogs.add({
              "empId" : log['employee']['employeeId'].toString(),
              "Name" : log['employee']['employeeName'].toString(),
              "status" : log["status"] == "Y" ? "Success" : "Failure",
              "mac_Id" : log['motherBoardId'],
              "DeviceID" : log['batch']['configuration']['device']['deviceName'],
              "Batch" : log['batch']['batchName'],
              "Config" : log['batch']['configuration']['name'],
              "firm_version": log['batch']['firmware']['versionName'],
              "Date-Time" : log['actionTimeStamp'],
              "reason" : log['message']
            });
          }

          finalResponse.add(FormattedLogs);

        }
      }
  );
  // printFunc("Demo in getAllLogsOnDays List<MAP<K,V>> : $FormattedLogs");
  printFunc("Demo in getAllLogsOnDays List<dynamic> : $finalResponse");

  return finalResponse;

}