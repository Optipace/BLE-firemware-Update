import 'package:flutter/cupertino.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: second_lightBg,
                    border: Border.all(color: darkBg, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: darkBg, blurRadius: 0.8)]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All Logs ",
                          style: TextStyle(
                              color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Devices Flashed : ",
                              style: TextStyle(
                                  color: darkBg,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${allLogs.length}",
                              style: TextStyle(
                                  color: darkBg,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(
                      CupertinoIcons.chevron_right_2,
                      color: darkBg,
                      weight: 40,
                      size: 28,
                    )
                  ],
                )),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: second_lightBg,
                    border: Border.all(color: darkBg, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: darkBg, blurRadius: 0.8)]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Factory User Logs ",
                          style: TextStyle(
                              color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Devices Flashed : ",
                              style: TextStyle(
                                  color: darkBg,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${factoryLogs.length}",
                              style: TextStyle(
                                  color: darkBg,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(
                      CupertinoIcons.chevron_right_2,
                      color: darkBg,
                      weight: 40,
                      size: 28,
                    )
                  ],
                )),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: second_lightBg,
                    border: Border.all(color: darkBg, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: darkBg, blurRadius: 0.8)]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Field User Logs ",
                          style: TextStyle(
                              color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Devices Flashed : ",
                              style: TextStyle(
                                  color: darkBg,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${fieldLogs.length}",
                              style: TextStyle(
                                  color: darkBg,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(
                      CupertinoIcons.chevron_right_2,
                      color: darkBg,
                      weight: 40,
                      size: 28,
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
