import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';

import 'sortByStatus.dart';

class all_Logs extends StatefulWidget {
  List<Map<String, dynamic>> AllLogs;
  Map<String, dynamic> AllLogsCount;

  all_Logs({super.key, required this.AllLogs, required this.AllLogsCount});

  @override
  State<all_Logs> createState() => _all_LogsState();
}

class _all_LogsState extends State<all_Logs> {
  var sortedAllLogs;
  int totalCount = 0;
  int successCount = 0;
  int FailureCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      totalCount = widget.AllLogsCount['TotalLogs'];
      successCount = widget.AllLogsCount['SucessCount'];
      FailureCount = widget.AllLogsCount['FailureCount'];
      sortedAllLogs = sortByStatus(widget.AllLogs);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "All Logs",
          style: TextStyle(
              fontFamily: baseFont,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: lightBg),
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
                            SizedBox(width: 10,),
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
                        SizedBox(height: 5,),
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
                                  successCount.toString(),
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
                              "Total Successful Devices",
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
                                  FailureCount.toString(),
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
                              "Total Failed Devices",
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
              Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Divider(
                    color: darkBg.withOpacity(0.5),
                  )),
              ...List.generate(totalCount, (index) {
                ValueNotifier<bool> moreInfo = ValueNotifier<bool>(false);
                return ValueListenableBuilder(
                  valueListenable: moreInfo,
                  builder: (ctx, value, child) {
                    return log_pop_up(
                        SortedLogs: sortedAllLogs, index: index);
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
