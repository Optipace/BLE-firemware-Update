import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/API/batchAPI.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';
import 'package:tracker_firmware/modules/admin/log/sortByStatus.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';

TextStyle CardText(
    {required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

List<Widget> batchLogsList(String? name) {
  var batchLogs = getAllLogs();
  var sortedBatchLogs = sortByStatus(batchLogs);

  List<Widget> batchLogsList = [];

  for (int index = 0; index < sortedBatchLogs.length; index++) {
    if (name == sortedBatchLogs[index]["Batch"]) {
      ValueNotifier moreInfo = ValueNotifier<bool>(false);
      batchLogsList.add(ValueListenableBuilder(
          valueListenable: moreInfo,
          builder: (ctx, value, child) {
            return log_pop_up(SortedLogs: sortedBatchLogs, index: index);
          }));
    }
  }
  return batchLogsList;
}

class BatchLogs extends StatefulWidget {
  Map<String, dynamic> item;

  BatchLogs({super.key, required this.item});

  @override
  State<BatchLogs> createState() => _BatchLogsState();
}

class _BatchLogsState extends State<BatchLogs> {
  List<dynamic> getBatchLogs = [];
  int totalCount = 0;
  var successCount;
  var FailCount;
  List<Map<String, dynamic>> SortedLogs = [{}];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getBatchLogs =
          await getLogsByBatchId(context, bacthId: widget.item["id"]);
      totalCount = getBatchLogs.isNotEmpty ? getBatchLogs[0]['TotalCount'] : 0;
      successCount = getBatchLogs[0]['SuccessCount'] ?? 0;
      FailCount = getBatchLogs[0]['FailureCount'] ?? 0;
      SortedLogs.clear();
      SortedLogs = sortByStatus(getBatchLogs[1]);
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
            "${widget.item["name"]} Logs",
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
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${totalCount}",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: darkBg,
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
                                    "${successCount}",
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
                                          color: Colors.black,
                                          blurRadius: 0.5)
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
                                    "${FailCount}",
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
                                          color: Colors.black,
                                          blurRadius: 0.5)
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
                ...batchLogsList(widget.item["name"]),
                ...List.generate(totalCount, (index) {
                  ValueNotifier<bool> moreInfo = ValueNotifier<bool>(false);
                  return ValueListenableBuilder(
                    valueListenable: moreInfo,
                    builder: (ctx, value, child) {
                      return log_pop_up(SortedLogs: SortedLogs, index: index);
                    },
                  );
                }),
              ],
            ),
          ),
        ),);
  }
}

/*
* Widget logCard(Map<String, dynamic> batchLogs) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 2,
        )
      ]),
      child: ExpansionTile(
        key: ValueKey('batchlog_${batchLogs["empId"]}'),
        tilePadding: EdgeInsets.all(5),
        backgroundColor: batchLogs['status'] == 'Success' ? SuccessCard : FailureCard,
        collapsedBackgroundColor: batchLogs['status'] == 'Success' ? SuccessCard : FailureCard,
        iconColor: darkBg,
        collapsedIconColor: darkBg,
        collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.black, width: 0.3)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.black, width: 0.3)),
        title: Container(
          padding: EdgeInsets.all(5),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Name
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name : ", style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                  SizedBox(
                    height: 3,
                  ),
                  Text(batchLogs["Name"],
                      style: CardText(
                          font_Weight: FontWeight.w800,
                          size: 14,
                          FontColor: batchLogs['status'] == 'Success' ? SuccessCardText : FailureCardText)),
                ],
              ),
              // EmpID
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "EmpID : ",
                    style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    batchLogs["empId"],
                    style: CardText(
                        font_Weight: FontWeight.w800,
                        size: 14,
                        FontColor: batchLogs['status'] == 'Success' ? SuccessCardText : FailureCardText),
                  ),
                ],
              ),
              // Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status:",
                    style: CardText(
                      font_Weight: FontWeight.w300,
                      FontColor: secondaryText,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    batchLogs['status'],
                    style: CardText(
                      font_Weight: FontWeight.w800,
                      size: 16,
                      FontColor:
                      batchLogs['status'] == 'Success' ? SuccessCardText : FailureCardText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Divider(
                    color: Colors.black26,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // phone number
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone\nNumber : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  batchLogs['phone'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 16,
                                      FontColor: batchLogs['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //Service-Profile
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Service\nProfile:",
                                  style: CardText(
                                    font_Weight: FontWeight.w300,
                                    FontColor: secondaryText,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  batchLogs['Battery-profile'],
                                  style: CardText(
                                    font_Weight: FontWeight.w800,
                                    size: 16,
                                    FontColor:
                                        batchLogs['status'] == 'Success' ? SuccessCardText : FailureCardText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Firm Version
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Firm\nversion : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  batchLogs['firm_version'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 16,
                                      FontColor: batchLogs['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Date-Time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date\nTime:",
                                  style: CardText(
                                    font_Weight: FontWeight.w300,
                                    FontColor: secondaryText,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  batchLogs['Date-Time'].replaceFirst(' ', '\n'),
                                  style: CardText(
                                    font_Weight: FontWeight.w800,
                                    size: 16,
                                    FontColor:
                                        batchLogs['status'] == 'Success' ? SuccessCardText : FailureCardText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Battery-Service
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Battery\nService : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  batchLogs['Battery-Service'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 16,
                                      FontColor: batchLogs['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // DeviceID
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DeviceID : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  batchLogs['DeviceID'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 14,
                                      FontColor: batchLogs['status'] == 'Success' ? SuccessCardText : FailureCardText),
                                )
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }*/
