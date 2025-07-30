import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';
import 'package:tracker_firmware/modules/admin/log/sortByStatus.dart';



List<Widget> monthlylogs(){
  List <Widget> monthlyLogList = [];
  List<Map<String, dynamic>> sortedMonthlyLogs =
  [
    {
      "empId": "EMP124",
      "Name": "Emma Clark",
      "status": "Success",
      "mac_Id": "03:1A:2B:3C:4D:5E",
      "DeviceID": "548",
      "Batch": "airbird 100",
      "Config": "air01",
      "firm_version": "2.2.9",
      "Date-Time": "2025-05-26 12:45:00",
      "reason": "Success"
    },
    {
      "empId": "EMP123",
      "Name": "David Stone",
      "status": "Failure",
      "mac_Id": "03:1A:2B:3C:4D:5E",
      "DeviceID": "547",
      "Batch": "airbird batches",
      "Config": "a34",
      "firm_version": "2.3.1",
      "Date-Time": "2025-05-26 12:00:00",
      "reason": "Failure due to device not found"
    },
    {
      "empId": "EMP123",
      "Name": "David Stone",
      "status": "Failure",
      "mac_Id": "03:1A:2B:3C:4D:5E",
      "DeviceID": "547",
      "Batch": "airBird batch01",
      "Config": "ar001",
      "firm_version": "2.3.1",
      "Date-Time": "2025-05-26 12:00:00",
      "reason": "Failed due to MAC ID not found"
    }
  ];

  for(int index =0;index<sortedMonthlyLogs.length;index++){
    ValueNotifier moreInfo = ValueNotifier<bool>(false);
    monthlyLogList.add(ValueListenableBuilder(
        valueListenable: moreInfo,
        builder: (ctx, value, child) {
          return log_pop_up(SortedLogs: sortedMonthlyLogs, index: index);
        }));
  }
  return monthlyLogList;
}


class Monthly_log extends StatefulWidget {
  List<dynamic> monthlyLogs;
  Monthly_log({super.key,required this.monthlyLogs});

  @override
  State<Monthly_log> createState() => _Monthly_logState();
}

class _Monthly_logState extends State<Monthly_log> {
  var sortedMontlyLogs;
  int totalCount=0;
  int sucessCount=0;
  int failCount=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sortedMontlyLogs = sortByStatus(widget.monthlyLogs[1]);
    totalCount = widget.monthlyLogs[0]['TotalCount'];
    sucessCount = widget.monthlyLogs[0]['SuccessCount'];
    failCount = widget.monthlyLogs[0]['FailureCount'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title:  Text(
          "Monthly Logs",
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
                            Text(totalCount.toString(),
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
                                Text(sucessCount.toString(),
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
                                Text(failCount.toString(),
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



              ...List.generate(sortedMontlyLogs.length, (index) {
                ValueNotifier<bool> moreInfo = ValueNotifier<bool>(false);
                return ValueListenableBuilder(
                  valueListenable: moreInfo,
                  builder: (ctx, value, child) {
                    return log_pop_up(SortedLogs: sortedMontlyLogs, index: index);
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


