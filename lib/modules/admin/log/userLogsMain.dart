import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/all_log.dart';
import 'package:tracker_firmware/modules/admin/log/factory_log.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';

class UserLogsMain extends StatelessWidget {
  var allLogs = getAllLogs();
  var factoryLogs = getFactoryLogs();
  var fieldLogs = getFeildLogs();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Logs",
          style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
        ),
        toolbarHeight: size.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: lightBg,
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              printFunc("Inside All logs");
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => all_Logs()));
            },
            child: Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: second_lightBg,
                  border: Border.all(color: darkBg, width: 1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: darkBg, blurRadius: 0.8)]),
              child: Column(
                children: [
                  Text(
                    " Total Number of Devices flashed :",
                    style: TextStyle(
                        color: darkBg, fontSize: 18, fontWeight: FontWeight.w500, fontFamily: baseFont),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.on_device_training_outlined,
                        color: darkBg,
                        shadows: [Shadow(color: darkBg, blurRadius: 0.8)],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        ": ${allLogs.length}",
                        style: TextStyle(
                            color: darkBg, fontSize: 20, fontWeight: FontWeight.w500, fontFamily: baseFont),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              printFunc("Inside Factory user ");
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => FactoryLog()));
            },
            child: Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: second_lightBg,
                  border: Border.all(color: darkBg, width: 1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: darkBg, blurRadius: 0.8)]),
              child: Column(
                children: [
                  Text(
                    "No.of Devices flashed by Factory user :",
                    style: TextStyle(
                        color: darkBg, fontSize: 18, fontWeight: FontWeight.w500, fontFamily: baseFont),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.on_device_training_outlined,
                        color: darkBg,
                        shadows: [Shadow(color: darkBg, blurRadius: 0.8)],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        ": ${factoryLogs.length}",
                        style: TextStyle(
                            color: darkBg, fontSize: 20, fontWeight: FontWeight.w500, fontFamily: baseFont),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              printFunc("Inside Field user ");
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => FieldLogs()));
            },
            child: Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: second_lightBg,
                  border: Border.all(color: darkBg, width: 1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: darkBg, blurRadius: 0.8)]),
              child: Column(
                children: [
                  Text(
                    "No.of Devices flashed by Field user :",
                    style: TextStyle(
                        color: darkBg, fontSize: 18, fontWeight: FontWeight.w500, fontFamily: baseFont),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.on_device_training_outlined,
                        color: darkBg,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        ": ${fieldLogs.length}",
                        style: TextStyle(
                            color: darkBg, fontSize: 20, fontWeight: FontWeight.w500, fontFamily: baseFont),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
