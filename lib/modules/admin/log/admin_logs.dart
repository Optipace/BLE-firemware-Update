import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/bacthLogsMain.dart';
import 'package:tracker_firmware/modules/admin/log/monthly_logs/monthly_log.dart';
import 'package:tracker_firmware/modules/admin/log/monthly_logs/week_log.dart';
import 'package:tracker_firmware/modules/admin/log/userLogsMain.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/widgets/pie_chart_widget.dart';

class AdminLogs extends StatefulWidget {
  @override
  State<AdminLogs> createState() => AdminLogsState();
}



class AdminLogsState extends State<AdminLogs> {
  List<Map<String, dynamic>> batchList = [{}];
  var factoryLogs;
  var fieldLogs;
  var allLogs;

  //  User logs
  late final List<Category> UserLogs;
  late final List<Color> UserColor;

  // Batch Logs
  List<Category> BatchLogs = [];
  List<Color> BatchColors = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      batchList = await getBatchList(context, Status: "A");
      // BACTH LOGS PIE CHART
      BatchLogs = [
        for (int i = 0; i < batchList.length; i++)
          Category(batchList![i]["name"].toString(), false, amount: countLogs(batchList[i]).toDouble())
      ];

      BatchColors = generateBrightColors(batchList.length);
      printFunc("demo batch ${batchList[1]['name']}");

      // Printing Batch logs
      /*
      printFunc("Batch Logs : ${BatchLogs.toString()}");
      printFunc("Batch logs Colors : ${BatchColors.toString()}");
      */
      setState(() {});
    });
    factoryLogs = getFactoryLogs();
    fieldLogs = getFeildLogs();
    allLogs = getAllLogs();

    //  USER LOGS PIE CHART
    UserLogs = [
      Category("Fatory User", false, amount: this.factoryLogs.length.toDouble()),
      Category("Field User", false, amount: this.fieldLogs.length.toDouble())
    ];
    UserColor = [Color(0xFF5262FF), Color(0xFF2EC6FF)];

    setState(() {});
    printFunc("Logs length : ${factoryLogs.length}");
  }

  //Counting of batches Logs
  int countLogs(Map<String, dynamic> item) {
    int count = 0;
    for (int index = 0; index < allLogs.length; index++) {
      if (item["name"] == allLogs[index]["Batch"]) {
        count++;
      }
    }
    return count;
  }

  // To generate the different Colors
  List<Color> generateBrightColors(int count) {
    return List<Color>.generate(count, (i) {
      final hue = 200 + 40 * (i / count);
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
            style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
          ),
          toolbarHeight: screenSize.height / 11.5,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: lightBg,
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Analytics Overview
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      color: Colors.white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Analytics Overview : ",
                          style: TextStyle(
                            color: darkBg,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            shadows: [Shadow(color: Colors.black, blurRadius: 0.5)],
                          ),
                        ),
                        SizedBox(height: 20,),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Month
                            GestureDetector(
                              onTap :(){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> Monthly_log()));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: screenSize.width/4,
                                    height: screenSize.height/7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: screenSize.width/4,
                                        height: screenSize.height/7.1,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFB2EBF2).withOpacity(0.8)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: screenSize.width/4,
                                            height: screenSize.height/9,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:Colors.white
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: screenSize.width/4,
                                                height: screenSize.height/9.1,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    width: screenSize.width/4,
                                                    height: screenSize.height/9.4,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white
                                                    ),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child:Text("123",
                                                        style: TextStyle(
                                                            color: Color(0xFF212121),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 24
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
                                  ),
                                  SizedBox(height: 12,),
                                  Text("This Month",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Week
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> Week_logs()));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: screenSize.width/4,
                                    height: screenSize.height/7,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: screenSize.width/4,
                                        height: screenSize.height/7.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFFFE0B2)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: screenSize.width/4,
                                            height: screenSize.height/9,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:Colors.white
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: screenSize.width/4,
                                                height: screenSize.height/9.1,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    width: screenSize.width/4,
                                                    height: screenSize.height/9.4,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white
                                                    ),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child:Text("123",
                                                        style: TextStyle(
                                                            color: Color(0xFF212121),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 24
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
                                  ),
                                  SizedBox(height: 12,),
                                  Text("This Week",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //day
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> Week_logs()));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: screenSize.width/4,
                                    height: screenSize.height/7,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: screenSize.width/4,
                                        height: screenSize.height/7.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFFFF9C4)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: screenSize.width/4,
                                            height: screenSize.height/9,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:Colors.white
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: screenSize.width/4,
                                                height: screenSize.height/9.1,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    width: screenSize.width/4,
                                                    height: screenSize.height/9.4,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white
                                                    ),
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child:Text("123",
                                                        style: TextStyle(
                                                            color: Color(0xFF212121),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 24
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
                                  ),
                                  SizedBox(height: 12,),
                                  Text("Today",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 5,),
                        Divider(color: darkBg,),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                SizedBox(width: 5,),
                                Text("Number of devices failed to flash : 23 ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16
                                  ),
                                ),
                              ],
                            ),
                          )
                        ),
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
                    onTap: () {
                      printFunc("User Logs ${UserLogs[1].name}");
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserLogsMain()));
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
        ));
  }
}
