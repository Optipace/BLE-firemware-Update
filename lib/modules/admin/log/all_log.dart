import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';

import 'sortByStatus.dart';


List<Widget> allLogs() {
  var allLogs = getAllLogs();
  var sortedAllLogs = sortByStatus(allLogs);
  List<Widget> allLogsList = [];

  for (int index = 0; index < sortedAllLogs.length; index++) {
    printFunc("DEMO DEMO Factory logs : ${sortedAllLogs[index]}");
    ValueNotifier moreInfo = ValueNotifier<bool>(false);
    allLogsList.add(ValueListenableBuilder(
        valueListenable: moreInfo,
        builder: (ctx, value, child) {
          return log_pop_up(SortedLogs: sortedAllLogs, index: index);
        }));
  }

  return allLogsList;
}

class all_Logs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "All Logs",
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
              ...allLogs(),
            ],
          ),
        ),
      ),
    );
  }
}
