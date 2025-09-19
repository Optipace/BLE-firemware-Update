import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareSeriesModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/services/apiCall/firmware.dart';
import 'package:tracker_firmware/services/firmware/methods.dart';

//////////////////// NOT IN USED {DISABLED THE FEATURE TO SHOW ALL THE FIRMWARE IN FACTORY USER DASHBOARD}//////////////////

class FirmwareFactoryManagement extends StatefulWidget {
  const FirmwareFactoryManagement({super.key});

  @override
  State<FirmwareFactoryManagement> createState() =>
      FirmwareFactoryManagementState();
}

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

class FirmwareFactoryManagementState extends State<FirmwareFactoryManagement> {
  int selectedbutton = 1;
  Map<String, dynamic> firmwareList = {};
  var seriesSixData;
  var seriesNineData;
  var seriesTwelveData;
  var firmwareBox;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      firmwareBox = await Hive.openBox<FirmwareSeriesModel>('$firmwareHiveBox');
      // await firmwareBox.clear();
      firmwareList = await getFirmwareList(context, active: "Y");
      printFunc("Firmware list :-> $firmwareList");
      seriesSixData = await getSeriesData(1);
      seriesNineData = await getSeriesData(2);
      seriesTwelveData = await getSeriesData(3);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    printFunc("Inside Logs Page");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Firmwares",
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              // Card desgn for demo
              ...firmwareList.entries.map((entry) {
                return Container(
                  margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                        )
                      ]),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.all(5),
                    backgroundColor: SuccessCard,
                    collapsedBackgroundColor: SuccessCard,
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
                          // Firm id
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Firmware Id",
                                style: CardText(
                                    font_Weight: FontWeight.w300,
                                    FontColor: secondaryText),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "${entry.value["id"]}",
                                style: CardText(
                                    font_Weight: FontWeight.w800,
                                    size: 19,
                                    FontColor: FailureCardText),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          // Version
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Version : ",
                                  style: CardText(
                                      font_Weight: FontWeight.w300,
                                      FontColor: secondaryText)),
                              SizedBox(
                                height: 3,
                              ),
                              Text("${entry.value["version"]} ",
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: FailureCardText)),
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
                            FittedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Release Note
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Release Note : ",
                                        style: CardText(
                                            font_Weight: FontWeight.w300,
                                            FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "${entry.value["releaseNote"]}",
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FailureCardText),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  // vertion name
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Version Name",
                                        style: CardText(
                                            font_Weight: FontWeight.w300,
                                            FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "${entry.value["versionName"]}",
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FailureCardText),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),

                                  // DeviceType
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Series : ",
                                        style: CardText(
                                            font_Weight: FontWeight.w300,
                                            FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "${entry.value["deviceType"]}",
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FailureCardText),
                                      )
                                    ],
                                  ),

                                  //Download icon
                                  /*Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon:
                                          Icon(Icons.download_done_outlined,
                                              color: darkBg, size: 40)),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text("Download",
                                        style: CardText(
                                            font_Weight: FontWeight.w300,
                                            FontColor: FailureCardText),
                                      ),
                                    ],
                                  ),*/
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // CARD DESIGN
                );
              }).toList(),
            ],
          ),
        ));
  }

  List<Widget> seriesSix() {
    printFunc("Serice six Data : $seriesSixData");
    List<Widget> seriesSixWidgetList = [];

    for (int index = 0;
        index < ((seriesSixData != null) ? seriesSixData.length : 0);
        index++) {
      printFunc("DEMO DEMO Firmware logs : ${seriesSixData[index]}");
      ValueNotifier moreInfo =
          ValueNotifier<bool>(seriesSixData[index]['saved']);
      seriesSixWidgetList.add(ValueListenableBuilder(
          valueListenable: moreInfo,
          builder: (ctx, value, child) {
            return Container(
              margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                    )
                  ]),
              child: ExpansionTile(
                // key: ValueKey('b6_$index'),
                key: ValueKey(
                    'b6_${index}_${seriesSixData[index]['id'].toString()}_${seriesSixData[index]['saved'].toString()}'),

                tilePadding: EdgeInsets.all(5),
                backgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
                collapsedBackgroundColor:
                    (moreInfo.value) ? SuccessCard : FailureCard,
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
                          Text("Version : ",
                              style: CardText(
                                  font_Weight: FontWeight.w300,
                                  FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesSixData[index]["version"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 19,
                                  FontColor: !(moreInfo.value)
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
                            "Release Note : ",
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesSixData[index]["releaseNote"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: !(moreInfo.value)
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
                            "Series : ",
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesSixData[index]['deviceType'],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: !(moreInfo.value)
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
                        FittedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // vertion name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Version Name",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: secondaryText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    seriesSixData[index]['versionName'],
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // Firm id
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Firmware Id",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: secondaryText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    seriesSixData[index]['id'].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // download
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        if (!seriesSixData[index]['saved']) {
                                          await addFirmware(
                                              FirmwareModel.fromJson(
                                                  seriesSixData[index]));

                                          setState(() {});
                                        }
                                        // seriesSixData.clear();

                                        seriesSixData = await getSeriesData(1);
                                        moreInfo.value(
                                            seriesSixData[index]['saved']);
                                        setState(() {});
                                      },
                                      icon: (!seriesSixData[index]['saved'])
                                          ? Icon(
                                              Icons
                                                  .download_for_offline_outlined,
                                              color: SuccessCardText,
                                              size: 40)
                                          : Icon(Icons.download_done_outlined,
                                              color: darkBg, size: 40)),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    !(moreInfo.value) ? "Saved" : "Download",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
    printFunc("Serice Nine Data : $seriesNineData");
    List<Widget> seriesNineWidgetList = [];

    for (int index = 0;
        index < ((seriesNineData != null) ? seriesNineData.length : 0);
        index++) {
      printFunc("DEMO DEMO Firmware logs : ${seriesNineData[index]}");
      ValueNotifier moreInfo =
          ValueNotifier<bool>(seriesNineData[index]['saved']);
      seriesNineWidgetList.add(ValueListenableBuilder(
          valueListenable: moreInfo,
          builder: (ctx, value, child) {
            return Container(
              margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                    )
                  ]),
              child: ExpansionTile(
                // key: ValueKey('b6_$index'),
                key: ValueKey(
                    'b6_${index}_${seriesNineData[index]['id'].toString()}_${seriesNineData[index]['saved'].toString()}'),

                tilePadding: EdgeInsets.all(5),
                backgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
                collapsedBackgroundColor:
                    (moreInfo.value) ? SuccessCard : FailureCard,
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
                          Text("Version : ",
                              style: CardText(
                                  font_Weight: FontWeight.w300,
                                  FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesNineData[index]["version"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 19,
                                  FontColor: !(moreInfo.value)
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
                            "Release Note : ",
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesNineData[index]["releaseNote"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: !(moreInfo.value)
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
                            "Series : ",
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesNineData[index]['deviceType'],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: !(moreInfo.value)
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
                        FittedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // vertion name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Version Name",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: secondaryText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    seriesNineData[index]['versionName'],
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // Firm id
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Firmware Id",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: secondaryText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    seriesNineData[index]['id'].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // download
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        if (!seriesNineData[index]['saved']) {
                                          await addFirmware(
                                              FirmwareModel.fromJson(
                                                  seriesNineData[index]));

                                          setState(() {});
                                        }
                                        // seriesNineData.clear();

                                        seriesNineData = await getSeriesData(2);
                                        moreInfo.value(
                                            seriesNineData[index]['saved']);
                                        setState(() {});
                                      },
                                      icon: (!seriesNineData[index]['saved'])
                                          ? Icon(
                                              Icons
                                                  .download_for_offline_outlined,
                                              color: SuccessCardText,
                                              size: 40)
                                          : Icon(Icons.download_done_outlined,
                                              color: darkBg, size: 40)),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    !(moreInfo.value) ? "Saved" : "Download",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
    printFunc("Serice Twelve Data : $seriesTwelveData");
    List<Widget> seriesTwelveWidgetList = [];

    for (int index = 0;
        index < ((seriesTwelveData != null) ? seriesTwelveData.length : 0);
        index++) {
      printFunc("DEMO DEMO Firmware logs : ${seriesTwelveData[index]}");
      ValueNotifier moreInfo =
          ValueNotifier<bool>(seriesTwelveData[index]['saved']);
      seriesTwelveWidgetList.add(ValueListenableBuilder(
          valueListenable: moreInfo,
          builder: (ctx, value, child) {
            return Container(
              margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                    )
                  ]),
              child: ExpansionTile(
                // key: ValueKey('b6_$index'),
                key: ValueKey(
                    'b6_${index}_${seriesTwelveData[index]['id'].toString()}_${seriesTwelveData[index]['saved'].toString()}'),

                tilePadding: EdgeInsets.all(5),
                backgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
                collapsedBackgroundColor:
                    (moreInfo.value) ? SuccessCard : FailureCard,
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
                          Text("Version : ",
                              style: CardText(
                                  font_Weight: FontWeight.w300,
                                  FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesTwelveData[index]["version"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 19,
                                  FontColor: !(moreInfo.value)
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
                            "Release Note : ",
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesTwelveData[index]["releaseNote"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: !(moreInfo.value)
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
                            "Series : ",
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesTwelveData[index]['deviceType'],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: !(moreInfo.value)
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
                        FittedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // vertion name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Version Name",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: secondaryText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    seriesTwelveData[index]['versionName'],
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // Firm id
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Firmware Id",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: secondaryText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    seriesTwelveData[index]['id'].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // download
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        if (!seriesTwelveData[index]['saved']) {
                                          await addFirmware(
                                              FirmwareModel.fromJson(
                                                  seriesTwelveData[index]));

                                          setState(() {});
                                        }
                                        // seriesTwelveData.clear();

                                        seriesTwelveData =
                                            await getSeriesData(3);
                                        moreInfo.value(
                                            seriesTwelveData[index]['saved']);
                                        setState(() {});
                                      },
                                      icon: (!seriesTwelveData[index]['saved'])
                                          ? Icon(
                                              Icons
                                                  .download_for_offline_outlined,
                                              color: SuccessCardText,
                                              size: 40)
                                          : Icon(Icons.download_done_outlined,
                                              color: darkBg, size: 40)),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    !(moreInfo.value) ? "Saved" : "Download",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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

  Future<List<Map<String, dynamic>>> getSeriesData(int id) async {
    List<Map<String, dynamic>> totalFirmwareList = [];

    // firmwareBox = await Hive.openBox<FirmwareSeriesModel>('$firmwareHiveBox');

// Get B6 from firmwareList
    /*
    final firmwareFromList = firmwareList
        .firstWhere((series) => series['id'] == "$id", orElse: () => null);
    printFunc("firmwareFromList : $firmwareFromList");
    */

// Get stored B6 from Hive
    final firmwareFromHive = firmwareBox.get("$id");
    printFunc("storedB6 $firmwareFromHive");
// Convert stored firmware to a Set of IDs or versions
    final existingFirmwareIds = <int>{};
    if (firmwareFromHive != null) {
      for (var fw in firmwareFromHive.firmware) {
        totalFirmwareList.add(fw.toJson());
        existingFirmwareIds.add(fw.id); // Track existing firmware IDs
      }
    }

    /*
    if (firmwareFromList != null) {
      for (var fw in firmwareFromList['firmware']) {
        if (!existingFirmwareIds.contains(fw['id'])) {
          totalFirmwareList.add(fw);
        }
      }
    }
    printFunc("Series B6 Data $totalFirmwareList");
    */

    return totalFirmwareList;
  }
}
