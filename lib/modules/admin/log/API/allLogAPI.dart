import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<List<dynamic>> getAllCount(BuildContext context) async{
  //List for final response
  List<dynamic> finalResponse = [];

  // Lists for all,factory, field
  List<dynamic> finalTotalLog =[];
  List<dynamic> finalFactoryLog = [];
  List<dynamic> finalFieldLog = [];

  List<Map<String, dynamic>> FormattedAllLogs = [{}];
  List<Map<String, dynamic>> FormattedFactoryLogs = [{}];
  List<Map<String, dynamic>> FormattedFieldLogs = [{}];
  
  await ApiService.callApi(
      context: context, 
      method: 'GET', 
      endpoint: ApiEndpoints.getAllCount, 
      onSuccess: (data) async {
        printFunc("API getAllCount : ${data['fieldWorkersStatus']}");
        printFunc("API getAllCount : ${data['factoryWorkersStatus']}");

        if(data != null){
          FormattedAllLogs.clear();
          FormattedFactoryLogs.clear();
          FormattedFieldLogs.clear();

          //Factory Logs
          var factoryLogs = data['factoryWorkersStatus']['logs'];
          for(var log in factoryLogs){
            FormattedFactoryLogs.add({
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
          finalFactoryLog.add({
            "TotalFactLogs": data['factoryWorkersStatus']['total'],
            "SuccessFactLogs": data['factoryWorkersStatus']['sucess'],
            "FailureFactLogs" : data['factoryWorkersStatus']['failure'],
          });
          finalFactoryLog.add({FormattedFactoryLogs});

          //Field Logs
          var fieldLogs = data['fieldWorkersStatus']['logs'];
          for(var log in fieldLogs){
            FormattedFieldLogs.add({
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
          finalFieldLog.add({
            "TotalFieldLogs":data['fieldWorkersStatus']['total'],
            "SuccessFieldLogs":data['fieldWorkersStatus']['sucess'],
            "FailureFieldLogs": data['fieldWorkersStatus']['failure']
          });
          finalFieldLog.add({FormattedFieldLogs});

          // Total Logs
          FormattedAllLogs =[
            ...FormattedFieldLogs,
            ...FormattedFactoryLogs
          ];
          finalTotalLog.add({
            "TotalLogs": data['totalCount'],
            "SucessCount":data['sucessCount'],
            "FailureCount": data['failureCount']
          });
          finalTotalLog.add({FormattedAllLogs});

          //final Response
          finalResponse.add({finalTotalLog});
          finalResponse.add({finalFieldLog});
          finalResponse.add({finalFactoryLog});


        }

        printFunc("DEMO ALL LOGS : ${finalResponse}");

      }
  );
  return finalResponse;
}