import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';
import 'package:tracker_firmware/modules/admin/log/sortByStatus.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

List<Widget> factoryUserLog() {
  var factoryLogs = getFactoryLogs();
  var sortedFactoryLogs = sortByStatus(factoryLogs);
  List<Widget> factoryUsersList = [];

  for (int index = 0; index < sortedFactoryLogs.length; index++) {
    printFunc("DEMO DEMO Factory logs : ${sortedFactoryLogs[index]}");
    ValueNotifier moreInfo = ValueNotifier<bool>(false);
    factoryUsersList.add(ValueListenableBuilder(
        valueListenable: moreInfo,
        builder: (ctx, value, child) {
          return log_pop_up(SortedLogs: sortedFactoryLogs, index: index);
        }));
  }

  return factoryUsersList;
}

class FactoryLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Factory Logs",
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
              ...factoryUserLog(),
            ],
          ),
        ),
      ),
    );
  }
}
