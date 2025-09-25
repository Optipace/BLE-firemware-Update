import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/API/allLogAPI.dart';
import 'package:tracker_firmware/modules/admin/log/API/daysAPI.dart';
import 'package:tracker_firmware/modules/admin/log/bacthLogsMain.dart';
import 'package:tracker_firmware/modules/admin/log/monthly_logs/day_log.dart';
import 'package:tracker_firmware/modules/admin/log/monthly_logs/monthly_log.dart';
import 'package:tracker_firmware/modules/admin/log/monthly_logs/week_log.dart';
import 'package:tracker_firmware/modules/admin/log/userLogsMain.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/widgets/pie_chart_widget.dart';

class AdminLogs extends StatefulWidget {
  @override
  State<AdminLogs> createState() => AdminLogsState();
}

class AdminLogsState extends State<AdminLogs> {
  List<Map<String, dynamic>> batchList = [{}];
  List<Map<String, dynamic>> factoryLogs = [{}];
  List<Map<String, dynamic>> fieldLogs = [{}];
  List<Map<String, dynamic>> allLogs = [{}];

  //  User logs
  List<Category> UserLogs = [];
  late final List<Color> UserColor;

  // Batch Logs
  List<Category> BatchLogs = [];
  List<Color> BatchColors = [];

  // List for logs by Days
  List<dynamic> dayLogs = [];
  List<dynamic> weekLogs = [];
  List<dynamic> monthlylogs = [];
  List<dynamic> emptyList = [
    {
      "TotalCount": 0,
      "SuccessCount": 0,
      "FailureCount": 0,
    },
    <Map<String, dynamic>>[{}]
  ];

  //List for logs by user
  List<dynamic> userlogs = [];

  //Counts
  int totalMonthlyCount = 0;
  int totalWeeklyCount = 0;
  int totalDailyCount = 0;
  int totalAllCount = 0;
  double factoryCount = 0;
  double fieldCount = 0;

  //Maps For Counts
  Map<String, dynamic> AllLogsCounts = {};
  Map<String, dynamic> FactoryLogsCounts = {};
  Map<String, dynamic> FieldLogsCounts = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      batchList = await getBatchList(context, Status: "A");

      // logs API's

      //Days
      dayLogs = await getLogsByDays(context, days: 1);
      weekLogs = await getLogsByDays(context, days: 7);
      monthlylogs = await getLogsByDays(context, days: 30);

      // By users
      userlogs = await getAllCount(context);

      if (monthlylogs.isNotEmpty) {
        totalMonthlyCount = monthlylogs[0]['TotalCount'];
      } else {
        totalMonthlyCount = 0;
        monthlylogs = emptyList;
      }

      if (weekLogs.isNotEmpty) {
        totalWeeklyCount = weekLogs[0]['TotalCount'];
      } else {
        totalWeeklyCount = 0;
        weekLogs = emptyList;
      }
      if (dayLogs.isNotEmpty) {
        totalDailyCount = dayLogs[0]['TotalCount'];
      } else {
        totalDailyCount = 0;
        dayLogs = emptyList;
      }

      //For PIECHART
      totalAllCount = userlogs[0].first[0]['TotalLogs'];
      allLogs.clear();
      allLogs = userlogs[0].first[1].first;
      fieldLogs.clear();
      fieldLogs = userlogs[1].first[1].first;
      factoryLogs.clear();
      factoryLogs = userlogs[2].first[1].first;
      factoryCount = factoryLogs.length.toDouble();
      fieldCount = fieldLogs.length.toDouble();
      setState(() {});

      //  USER LOGS PIE CHART
      UserLogs = [
        Category("Fatory User", false, amount: factoryCount),
        Category("Field User", false, amount: fieldCount)
      ];

      //Maps for Counts
      AllLogsCounts = {
        "TotalLogs": userlogs[0].first[0]['TotalLogs'],
        "SucessCount": userlogs[0].first[0]['SucessCount'],
        "FailureCount": userlogs[0].first[0]['FailureCount']
      };
      FieldLogsCounts = {
        "TotalFieldLogs": userlogs[1].first[0]['TotalFieldLogs'],
        "SuccessFieldLogs": userlogs[1].first[0]['SuccessFieldLogs'],
        "FailureFieldLogs": userlogs[1].first[0]['FailureFieldLogs']
      };
      FactoryLogsCounts = {
        "TotalFactLogs": userlogs[2].first[0]['TotalFactLogs'],
        "SuccessFactLogs": userlogs[2].first[0]['SuccessFactLogs'],
        "FailureFactLogs": userlogs[2].first[0]['FailureFactLogs']
      };

      // BACTH LOGS PIE CHART
      BatchLogs = [
        for (int i = 0; i < batchList.length; i++)
          Category(batchList[i]["name"].toString(), false,
              amount: allLogs
                  .where((log) => log["Batch"] == batchList[i]["name"])
                  .length
                  .toDouble())
      ];
      BatchColors = generateBrightColors(batchList.length);
      // printFunc("demo batch ${batchList[1]['name']}");

      setState(() {});
      printFunc("AlLLoGSCOUNTS : ${userlogs[1].first[0]}");
      printFunc("AlLLoGSCOUNTS : ${userlogs[2].first[0]}");
      printFunc("ALL LOGS DEMO : ${allLogs.length}");
    });

    UserColor = [Color(0xFF5262FF), Color(0xFF2EC6FF)];

    setState(() {});
  }

  // To generate the different Colors
  List<Color> generateBrightColors(int count) {
    return List<Color>.generate(count, (i) {
      final hue = 200 + 40 * (i / count);
      // final hue = (i * 360 / count) % 360;
      return HSLColor.fromAHSL(1.0, hue, 0.95, 0.5).toColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Logs",
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Analytics Overview
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Analytics Overview : ",
                          style: TextStyle(
                            color: darkBg,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 0.5)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Month
                            GestureDetector(
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => Monthly_log(
                                      monthlyLogs: monthlylogs,
                                    )));
                              },
                              child: Column(
                                children: [
                                  //circle
                                  Container(
                                    width: screenSize.width / 4,
                                    height: screenSize.height / 7,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: Center(
                                      child: Container(
                                        width: screenSize.width / 4,
                                        height: screenSize.height / 7.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFB2EBF2)
                                                .withOpacity(0.8)),
                                        child: Center(
                                          child: Container(
                                            width: screenSize.width / 4,
                                            height: screenSize.height / 9,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            child: Center(
                                              child: Container(
                                                width: screenSize.width / 4,
                                                height:
                                                screenSize.height / 9.1,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Container(
                                                    width:
                                                    screenSize.width / 4,
                                                    height:
                                                    screenSize.height /
                                                        9.4,
                                                    decoration: BoxDecoration(
                                                        shape:
                                                        BoxShape.circle,
                                                        color: Colors.white),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        totalMonthlyCount
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF212121),
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 24),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "This Month",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Week
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => Week_logs(
                                      weeklogs: weekLogs,
                                    )));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: screenSize.width / 4,
                                    height: screenSize.height / 7,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: Center(
                                      child: Container(
                                        width: screenSize.width / 4,
                                        height: screenSize.height / 7.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFFFE0B2)),
                                        child: Center(
                                          child: Container(
                                            width: screenSize.width / 4,
                                            height: screenSize.height / 9,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            child: Center(
                                              child: Container(
                                                width: screenSize.width / 4,
                                                height:
                                                screenSize.height / 9.1,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Container(
                                                    width:
                                                    screenSize.width / 4,
                                                    height:
                                                    screenSize.height /
                                                        9.4,
                                                    decoration: BoxDecoration(
                                                        shape:
                                                        BoxShape.circle,
                                                        color: Colors.white),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        totalWeeklyCount
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF212121),
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 24),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "This Week",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //day
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => Day_logs(
                                      dailyLogs: dayLogs,
                                    )));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: screenSize.width / 4,
                                    height: screenSize.height / 7,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: Center(
                                      child: Container(
                                        width: screenSize.width / 4,
                                        height: screenSize.height / 7.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFFFF9C4)),
                                        child: Center(
                                          child: Container(
                                            width: screenSize.width / 4,
                                            height: screenSize.height / 9,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            child: Center(
                                              child: Container(
                                                width: screenSize.width / 4,
                                                height:
                                                screenSize.height / 9.1,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Container(
                                                    width:
                                                    screenSize.width / 4,
                                                    height:
                                                    screenSize.height /
                                                        9.4,
                                                    decoration: BoxDecoration(
                                                        shape:
                                                        BoxShape.circle,
                                                        color: Colors.white),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        totalDailyCount
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF212121),
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 24),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Today",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: darkBg,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Number of devices Flashed : $totalAllCount",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
              //User logs pie-chart
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Center(
                  child: PieChartView(
                    titleText: "User Logs : ",
                    categories: UserLogs,
                    colors: UserColor,
                    total: 2,
                    totalText: "Users",
                    onTap: () {
                      printFunc("User Logs ${UserLogs[1].name}");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => UserLogsMain(
                            AllLogs: allLogs,
                            FieldLogs: fieldLogs,
                            FactoryLogs: factoryLogs,
                            AllLogsCount: AllLogsCounts,
                            FactoryLogsCount: FactoryLogsCounts,
                            FieldLogsCount: FieldLogsCounts,
                          )));
                    },
                  ),
                ),
              ),
              //Batch logs pie-chart
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Center(
                  child: PieChartView(
                    titleText: "Batch Logs : ",
                    categories: BatchLogs,
                    colors: BatchColors,
                    totalText: "Batches",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BatchLogsMain(
                            batchList: batchList,
                            allLogs: allLogs,
                          )));
                    },
                    total: batchList.length,
                  ),
                ),
              ),
            ],
          ),
        ),);
  }
}
