import 'package:flutter/cupertino.dart';
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
              Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: darkBg,
                        width: 1.5
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.devices,color: darkBg,),
                            SizedBox(width: 10,),
                            Text("04",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: darkBg,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 0.5
                                    )
                                  ]
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text("Total Devices Flashed",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: darkBg,
                              shadows: [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 0.5
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Divider(color: darkBg,),
                          SizedBox(height: 10,)
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.device_phone_portrait,size: 22,color: SuccessCardText,),
                                SizedBox(width: 5,),
                                Text("01",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: SuccessCardText,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 0.5
                                        )
                                      ]
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("Total Successful Devices",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: SuccessCardText,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 0.5
                                    )
                                  ]
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.device_unknown,size: 24,color: FailureCardText,),
                                SizedBox(width: 5,),
                                Text("03",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: FailureCardText,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 0.5
                                        )
                                      ]
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("Total Failed Devices",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: FailureCardText,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 0.5
                                    )
                                  ]
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Divider(color: darkBg.withOpacity(0.5),)
              ),
              ...factoryUserLog(),
            ],
          ),
        ),
      ),
    );
  }
}
