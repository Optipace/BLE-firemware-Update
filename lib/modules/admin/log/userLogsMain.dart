import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/all_log.dart';
import 'package:tracker_firmware/modules/admin/log/factory_log.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';

class UserLogsMain extends StatefulWidget {

  //Lists of Logs
  List<Map<String, dynamic>> AllLogs;
  List<Map<String, dynamic>> FactoryLogs;
  List<Map<String, dynamic>> FieldLogs;

  Map<String, dynamic> AllLogsCount;
  Map<String, dynamic> FactoryLogsCount;
  Map<String, dynamic> FieldLogsCount;



  UserLogsMain({
    super.key,
    required this.AllLogs,
    required this.FieldLogs,
    required this.FactoryLogs,
    required this.AllLogsCount,
    required this.FactoryLogsCount,
    required this.FieldLogsCount
  });

  @override
  State<UserLogsMain> createState() => _UserLogsMainState();
}

class _UserLogsMainState extends State<UserLogsMain> {

  List<Map<String, dynamic>> allLogs=[{}];
  List<Map<String, dynamic>> factoryLogs =[{}];
  List<Map<String, dynamic>> fieldLogs =[{}];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      allLogs = widget.AllLogs;
      factoryLogs = widget.FactoryLogs;
      fieldLogs = widget.FieldLogs;
      setState(() { });
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
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              printFunc("Inside All logs");
              Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                  all_Logs(
                    AllLogs: allLogs,
                    AllLogsCount: widget.AllLogsCount,

                  )
                )
              );
            },
            child: Container(
                width: screenSize.width,
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
              Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                  FactoryLog(
                    FactoryLogs: widget.FactoryLogs,
                    FactoryLogsCounts: widget.FactoryLogsCount,
                  )
                )
              );
            },
            child: Container(
                width: screenSize.width,
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
              Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                  FieldLogs(
                    FieldListLogs: widget.FieldLogs,
                    FieldLogsCounts: widget.FieldLogsCount,
                  )
                )
              );
            },
            child: Container(
                width: screenSize.width,
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


