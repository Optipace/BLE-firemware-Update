import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entiry/firmwareSeriesModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/login/api/api.dart';
import 'package:tracker_firmware/services/apiCall/firmware.dart';

class FirmwareManagement extends StatefulWidget {
  const FirmwareManagement({super.key});

  @override
  State<FirmwareManagement> createState() => FirmwareManagementState();
}

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

class FirmwareManagementState extends State<FirmwareManagement> {
  int selectedbutton = 1;
  List firmwareList=[];
  var seriesSixData ;
  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      firmwareList=await getFirmwareList(context);
      seriesSixData=await getSeriesSix();
    });

  }  @override
  Widget build(BuildContext context) {
    print("Inside Logs Page");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Firmwares",
            style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
          ),
          toolbarHeight: size.height / 11.5,
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
            Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: darkBg,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(28))),
              color: lightBg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedbutton = 1;
                      });
                    },
                    child: Container(
                      width: size.width * 0.32,
                      height: 60,
                      decoration: BoxDecoration(
                          color: selectedbutton == 1 ? darkBg : lightBg,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28), bottomLeft: Radius.circular(28)),
                          border: Border.all(width: 0.5, color: darkBg),
                          boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                      child: Center(
                          heightFactor: 2,
                          child: Center(
                            child: Text(
                              "B-6",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: baseFont,
                                fontWeight: FontWeight.w600,
                                color: selectedbutton == 1 ? lightBg : darkBg,
                                shadows: [
                                  Shadow(
                                      offset: Offset(0.3, 0.3),
                                      color: selectedbutton == 1 ? lightBg : darkBg),
                                  Shadow(
                                      offset: Offset(-0.3, 0.3),
                                      color: selectedbutton == 1 ? lightBg : darkBg),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedbutton = 2;
                        });
                      },
                      child: Container(
                        // width: size.width * 0.3,
                        height: 60,
                        decoration: BoxDecoration(
                            color: selectedbutton == 2 ? darkBg : lightBg,
                            // borderRadius: const BorderRadius.only(
                            //     topRight: Radius.circular(28), bottomRight: Radius.circular(28)),
                            boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                        child: Center(
                          heightFactor: 2,
                          child: Center(
                            child: Text(
                              "B-9",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: baseFont,
                                fontWeight: FontWeight.w600,
                                color: selectedbutton == 2 ? lightBg : darkBg,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0.3, 0.3),
                                    color: selectedbutton == 2 ? lightBg : darkBg,
                                  ),
                                  Shadow(
                                    offset: Offset(-0.3, 0.3),
                                    color: selectedbutton == 2 ? lightBg : darkBg,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedbutton = 3;
                      });
                    },
                    child: Container(
                      width: size.width * 0.3,
                      height: 60,
                      decoration: BoxDecoration(
                          color: selectedbutton == 3 ?darkBg: lightBg ,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(28), bottomRight: Radius.circular(28)),
                          boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                      child: Center(
                        heightFactor: 2,
                        child: Center(
                          child: Text(
                            "B-12",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w600,
                              color: selectedbutton == 3 ?lightBg : darkBg,
                              shadows: [
                                Shadow(
                                  offset: Offset(0.3, 0.3),
                                  color: selectedbutton == 3 ? lightBg: darkBg ,
                                ),
                                Shadow(
                                  offset: Offset(-0.3, 0.3),
                                  color: selectedbutton == 3 ?lightBg: darkBg ,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (selectedbutton == 1) ...?seriesSix(),
                      if (selectedbutton == 2) ...?seriesNine(),
                      if (selectedbutton == 3) ...?seriesTwelve(),
                    ],
                  ),
                )),
          ],
        ));
  }

  List<Widget> seriesSix() {
printFunc("Serice six Data : $seriesSixData");
    List<Widget> seriesSixWidgetList = [];

    for (int index = 0; index < seriesSixData.length; index++) {
      printFunc("DEMO DEMO Firmware logs : ${seriesSixData[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(false);
      seriesSixWidgetList.add(ValueListenableBuilder(
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
                backgroundColor: seriesSixData[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                collapsedBackgroundColor:
                seriesSixData[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                iconColor: darkBg,
                collapsedIconColor: darkBg,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                title: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Name
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesSixData[index]["Name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 19,
                                  FontColor: seriesSixData[index]['status'] == 'Success'
                                      ? SuccessCardText
                                      : FailureCardText)),
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
                            seriesSixData[index]["empId"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: seriesSixData[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          ),
                        ],
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
                            seriesSixData[index]['DeviceID'],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: seriesSixData[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.black26,
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // phone number
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesSixData[index]['phone'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesSixData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // Firm Version
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Firm version : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesSixData[index]['firm_version'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesSixData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // Battery-Service
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Battery-Service : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesSixData[index]['Battery-Service'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesSixData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Service-Profile
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Service-Profile:",
                                    style: CardText(
                                      font_Weight: FontWeight.w300,
                                      FontColor: secondaryText,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    seriesSixData[index]['Battery-profile'],
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesSixData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              // Date-Time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date-Time:",
                                    style: CardText(
                                      font_Weight: FontWeight.w300,
                                      FontColor: secondaryText,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    seriesSixData[index]['Date-Time'].replaceFirst(' ', '\n'),
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesSixData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
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
                                    seriesSixData[index]['status'],
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesSixData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // CARD DESIGN
            );
          }));
    }

    setState(() {});
    return seriesSixWidgetList;
  }
  List<Widget> seriesNine() {
    var seriesNineData = getFactoryLogs();
    List<Widget> seriesNineWidgetList = [];

    for (int index = 0; index < seriesNineData.length; index++) {
      printFunc("DEMO DEMO Firmware logs : ${seriesNineData[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(false);
      seriesNineWidgetList.add(ValueListenableBuilder(
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
                backgroundColor: seriesNineData[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                collapsedBackgroundColor:
                seriesNineData[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                iconColor: darkBg,
                collapsedIconColor: darkBg,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                title: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Name
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesNineData[index]["Name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 19,
                                  FontColor: seriesNineData[index]['status'] == 'Success'
                                      ? SuccessCardText
                                      : FailureCardText)),
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
                            seriesNineData[index]["empId"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: seriesNineData[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          ),
                        ],
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
                            seriesNineData[index]['DeviceID'],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: seriesNineData[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.black26,
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // phone number
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesNineData[index]['phone'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesNineData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // Firm Version
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Firm version : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesNineData[index]['firm_version'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesNineData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // Battery-Service
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Battery-Service : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesNineData[index]['Battery-Service'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesNineData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Service-Profile
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Service-Profile:",
                                    style: CardText(
                                      font_Weight: FontWeight.w300,
                                      FontColor: secondaryText,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    seriesNineData[index]['Battery-profile'],
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesNineData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              // Date-Time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date-Time:",
                                    style: CardText(
                                      font_Weight: FontWeight.w300,
                                      FontColor: secondaryText,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    seriesNineData[index]['Date-Time'].replaceFirst(' ', '\n'),
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesNineData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
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
                                    seriesNineData[index]['status'],
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesNineData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // CARD DESIGN
            );
          }));
    }

    setState(() {});
    return seriesNineWidgetList;
  }

  List<Widget> seriesTwelve() {
    var seriesTwelveData = getFactoryLogs();
    List<Widget> seriesTwelveWidgetList = [];

    for (int index = 0; index < seriesTwelveData.length; index++) {
      printFunc("DEMO DEMO Firmware logs : ${seriesTwelveData[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(false);
      seriesTwelveWidgetList.add(ValueListenableBuilder(
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
                backgroundColor: seriesTwelveData[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                collapsedBackgroundColor:
                seriesTwelveData[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                iconColor: darkBg,
                collapsedIconColor: darkBg,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                title: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Name
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesTwelveData[index]["Name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 19,
                                  FontColor: seriesTwelveData[index]['status'] == 'Success'
                                      ? SuccessCardText
                                      : FailureCardText)),
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
                            seriesTwelveData[index]["empId"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: seriesTwelveData[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          ),
                        ],
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
                            seriesTwelveData[index]['DeviceID'],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: seriesTwelveData[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.black26,
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // phone number
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesTwelveData[index]['phone'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesTwelveData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // Firm Version
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Firm version : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesTwelveData[index]['firm_version'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesTwelveData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // Battery-Service
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Battery-Service : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  seriesTwelveData[index]['Battery-Service'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesTwelveData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Service-Profile
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Service-Profile:",
                                    style: CardText(
                                      font_Weight: FontWeight.w300,
                                      FontColor: secondaryText,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    seriesTwelveData[index]['Battery-profile'],
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesTwelveData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              // Date-Time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date-Time:",
                                    style: CardText(
                                      font_Weight: FontWeight.w300,
                                      FontColor: secondaryText,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    seriesTwelveData[index]['Date-Time'].replaceFirst(' ', '\n'),
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesTwelveData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
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
                                    seriesTwelveData[index]['status'],
                                    style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: seriesTwelveData[index]['status'] == 'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // CARD DESIGN
            );
          }));
    }

    setState(() {});
    return seriesTwelveWidgetList;
  }

  Future<List<Map<String, dynamic>>> getSeriesSix() async{
    List<Map<String, dynamic>> totalFirmwareB6 = [];

    final firmwareBox = await Hive.openBox<FirmwareSeriesModel>('$serviceBox');

// Get B6 from firmwareList
    final b6FromList = firmwareList.firstWhere((series) => series['id'] == "1", orElse: () => null);

// Get stored B6 from Hive
    final storedB6 = firmwareBox.get("1");

// Convert stored firmware to a Set of IDs or versions
    final existingFirmwareIds = storedB6 != null
        ? storedB6.firmware.map((fw) => fw.id).toSet()
        : <int>{};

// Add only firmware that is NOT already in Hive
    if (b6FromList != null) {
      for (var fw in b6FromList['firmware']) {
        if (!existingFirmwareIds.contains(fw['id'])) {
          totalFirmwareB6.add(fw);
        }
      }
    }
    return totalFirmwareB6;

  }
}
