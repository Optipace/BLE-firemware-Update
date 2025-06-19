import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/bacthLogsMain.dart';
import 'package:tracker_firmware/modules/admin/log/userLogsMain.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/widgets/pie_chart_widget.dart';

class AdminLogs extends StatefulWidget {
  @override
  State<AdminLogs> createState() => AdminLogsState();
}

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
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
      batchList = await getBatchList(context);
      // BACTH LOGS PIE CHART
      BatchLogs = [
        for (int i = 0; i < batchList.length; i++)
          Category(batchList![i]["name"].toString(), false, amount: countLogs(batchList[i]).toDouble())
      ];
      BatchColors = generateBrightColors(batchList.length);
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
          toolbarHeight: size.height / 11.5,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: lightBg,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Text(
                      "User Logs : ",
                      style: TextStyle(
                        color: darkBg,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        shadows: [Shadow(color: Colors.black, blurRadius: 0.5)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Center(
                      child: PieChartView(
                        categories: UserLogs,
                        colors: UserColor,
                        onTap: () {
                          printFunc("User Logs");
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserLogsMain()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Text(
                      "Batch Logs : ",
                      style: TextStyle(
                        color: darkBg,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        shadows: [Shadow(color: Colors.black, blurRadius: 0.5)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Center(
                      child: PieChartView(
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
            ],
          ),
        )
    );
  }
}
