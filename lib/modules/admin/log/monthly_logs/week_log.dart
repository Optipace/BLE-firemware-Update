import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';

List<Widget> weeklylogs(){
  List<Widget> weeklyLogList = [];
  List<Map<String,dynamic>> sortedWeeklyLogs =
  [
    {
      "empId": "EMP124",
      "Name": "Emma Clark",
      "status": "Success",
      "mac_Id": "03:1A:2B:3C:4D:5E",
      "DeviceID": "548",
      "Batch": "airbird 100",
      "Config": "air01",
      "firm_version": "2.2.9",
      "Date-Time": "2025-05-26 12:45:00",
      "reason": "Success"
    },
    {
      "empId": "EMP123",
      "Name": "David Stone",
      "status": "Failure",
      "mac_Id": "03:1A:2B:3C:4D:5E",
      "DeviceID": "547",
      "Batch": "airbird batches",
      "Config": "a34",
      "firm_version": "2.3.1",
      "Date-Time": "2025-05-26 12:00:00",
      "reason": "Failure due to device not found"
    },
    {
      "empId": "EMP123",
      "Name": "David Stone",
      "status": "Failure",
      "mac_Id": "03:1A:2B:3C:4D:5E",
      "DeviceID": "547",
      "Batch": "airBird batch01",
      "Config": "ar001",
      "firm_version": "2.3.1",
      "Date-Time": "2025-05-26 12:00:00",
      "reason": "Failed due to MAC ID not found"
    }
  ];

  for(int index =0;index<sortedWeeklyLogs.length;index++){
    ValueNotifier moreInfo = ValueNotifier<bool>(false);
    weeklyLogList.add(ValueListenableBuilder(
        valueListenable: moreInfo,
        builder: (ctx, value, child) {
          return log_pop_up(SortedLogs: sortedWeeklyLogs, index: index);
        }));
  }
  return weeklyLogList;
}

class Week_logs extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Monthly Logs",
          style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
        ),
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...weeklylogs(),
            ],
          ),
        ),
      ),
    );
  }
}