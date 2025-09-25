import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';
import 'package:tracker_firmware/modules/admin/log/sortByStatus.dart';

class Week_logs extends StatefulWidget {
  List<dynamic> weeklogs = [];

  Week_logs({super.key, required this.weeklogs});

  @override
  State<Week_logs> createState() => _Week_logsState();
}

class _Week_logsState extends State<Week_logs> {
  var sortedWeeklyLogs;
  int totalCount = 0;
  int suceesCount = 0;

  int failCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sortedWeeklyLogs = sortByStatus(widget.weeklogs[1]);
    totalCount = widget.weeklogs[0]['TotalCount'];
    suceesCount = widget.weeklogs[0]['SuccessCount'];
    failCount = widget.weeklogs[0]['FailureCount'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Weekly Logs",
          style: TextStyle(
              fontFamily: baseFont,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: lightBg),
        ),
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: UpdatedBG,
      body:  SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: BoxDecoration(
                    border: Border.all(color: darkBg, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.devices,
                              color: darkBg,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              totalCount.toString(),
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: darkBg,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black, blurRadius: 0.5)
                                  ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Total Devices Flashed",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: darkBg,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 0.5)
                              ]),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: darkBg,
                          ),
                          SizedBox(
                            height: 10,
                          )
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
                                Icon(
                                  CupertinoIcons.device_phone_portrait,
                                  size: 22,
                                  color: SuccessCardText,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  suceesCount.toString(),
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: SuccessCardText,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 0.5)
                                      ]),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Successful Devices",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: SuccessCardText,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black, blurRadius: 0.5)
                                  ]),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.device_unknown,
                                  size: 24,
                                  color: FailureCardText,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  failCount.toString(),
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: FailureCardText,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 0.5)
                                      ]),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Failed Devices",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: FailureCardText,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black, blurRadius: 0.5)
                                  ]),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              ...List.generate(sortedWeeklyLogs.length, (index) {
                ValueNotifier<bool> moreInfo = ValueNotifier<bool>(false);
                return ValueListenableBuilder(
                  valueListenable: moreInfo,
                  builder: (ctx, value, child) {
                    return log_pop_up(
                        SortedLogs: sortedWeeklyLogs, index: index);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
