import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';

import 'sortByStatus.dart';

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 14,
      shadows: [Shadow(color: Colors.black)]);
}

List<Widget> allLogs() {
  var allLogs = getAllLogs();
  var sortedAllLogs = sortByStatus(allLogs);
  List<Widget> allLogsList = [];

  for (int index = 0; index < sortedAllLogs.length; index++) {
    printFunc("DEMO DEMO Factory logs : ${sortedAllLogs[index]}");
    ValueNotifier moreInfo = ValueNotifier<bool>(false);
    allLogsList.add(ValueListenableBuilder(
        valueListenable: moreInfo,
        builder: (ctx, value, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
              )
            ]),
            child: ExpansionTile(
              key: ValueKey('factory_$index'),
              tilePadding: EdgeInsets.all(5),
              backgroundColor: sortedAllLogs[index]['status'] == 'Success' ? SuccessCard : FailureCard,
              collapsedBackgroundColor:
                  sortedAllLogs[index]['status'] == 'Success' ? SuccessCard : FailureCard,
              iconColor: darkBg,
              collapsedIconColor: darkBg,
              collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.black, width: 0.3)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.black, width: 0.3)),
              title: Container(
                padding: EdgeInsets.all(5),
                width: screenSize.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Name
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name : ",
                            style: CardText(font_Weight: FontWeight.w500, FontColor: secondaryText)),
                        SizedBox(
                          height: 3,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(sortedAllLogs[index]["Name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 16,
                                  FontColor: sortedAllLogs[index]['status'] == 'Success'
                                      ? SuccessCardText
                                      : FailureCardText)),
                        ),
                      ],
                    ),
                    // EmpID
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EmpID : ",
                          style: CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            sortedAllLogs[index]["empId"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 16,
                                FontColor: sortedAllLogs[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          ),
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
                            font_Weight: FontWeight.w500,
                            FontColor: secondaryText,
                          ),
                        ),
                        SizedBox(height: 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            sortedAllLogs[index]['status'],
                            style: CardText(
                              font_Weight: FontWeight.w800,
                              size: 16,
                              FontColor: sortedAllLogs[index]['status'] == 'Success'
                                  ? SuccessCardText
                                  : FailureCardText,
                            ),
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
                    width: screenSize.width,
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
                                        style:
                                            CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        sortedAllLogs[index]['phone'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor: sortedAllLogs[index]['status'] == 'Success'
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
                                        "Date Time:",
                                        style: CardText(
                                          font_Weight: FontWeight.w500,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        sortedAllLogs[index]['Date-Time'].replaceFirst(' ', '\n'),
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: sortedAllLogs[index]['status'] == 'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
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
                                        style:
                                            CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        sortedAllLogs[index]['firm_version'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor: sortedAllLogs[index]['status'] == 'Success'
                                                ? SuccessCardText
                                                : FailureCardText),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //Batch
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Batch : ",
                                        style: CardText(
                                          font_Weight: FontWeight.w500,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        sortedAllLogs[index]['Batch'],
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: sortedAllLogs[index]['status'] == 'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
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
                                        style:
                                            CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        sortedAllLogs[index]['Battery-Service'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor: sortedAllLogs[index]['status'] == 'Success'
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
                                        style:
                                            CardText(font_Weight: FontWeight.w500, FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        sortedAllLogs[index]['DeviceID'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 14,
                                            FontColor: sortedAllLogs[index]['status'] == 'Success'
                                                ? SuccessCardText
                                                : FailureCardText),
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
        }));
  }

  return allLogsList;
}

class all_Logs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "All Logs",
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
              ...allLogs(),
            ],
          ),
        ),
      ),
    );
  }
}
