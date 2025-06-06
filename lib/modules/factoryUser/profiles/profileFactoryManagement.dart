import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileSeriesModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/services/apiCall/profile.dart';
import 'package:tracker_firmware/services/profiles/methods.dart';

class ProfileFactoryManagement extends StatefulWidget {
  const ProfileFactoryManagement({super.key});

  @override
  State<ProfileFactoryManagement> createState() => ProfileFactoryManagementState();
}

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

class ProfileFactoryManagementState extends State<ProfileFactoryManagement> {
  int selectedbutton = 1;
  List<Map<String, dynamic>> profileList = [];
  var seriesSixData;
  var seriesNineData;
  var seriesTwelveData;
  var profileBox;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      profileBox = await Hive.openBox<ProfileSeriesModel>('$serviceHiveBox');
      await profileBox.clear();
      profileList = await getProfileList(context);
      await saveProfileListToHive(profileList);
      printFunc("Profile list :-> $profileList");
      seriesSixData = await getSeriesData(1);
      seriesNineData = await getSeriesData(2);
      seriesTwelveData = await getSeriesData(3);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Inside Logs Page");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Profiles",
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
                          color: selectedbutton == 3 ? darkBg : lightBg,
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
                              color: selectedbutton == 3 ? lightBg : darkBg,
                              shadows: [
                                Shadow(
                                  offset: Offset(0.3, 0.3),
                                  color: selectedbutton == 3 ? lightBg : darkBg,
                                ),
                                Shadow(
                                  offset: Offset(-0.3, 0.3),
                                  color: selectedbutton == 3 ? lightBg : darkBg,
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

    for (int index = 0; index < ((seriesSixData != null) ? seriesSixData.length : 0); index++) {
      printFunc("DEMO DEMO Profile logs : ${seriesSixData[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(seriesSixData[index]['saved']);
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
                // key: ValueKey('b6_$index'),
                key: ValueKey(
                    'b6_${index}_${seriesSixData[index]['id'].toString()}_${seriesSixData[index]['saved'].toString()}'),

                tilePadding: EdgeInsets.all(5),
                backgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
                collapsedBackgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
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
                          Text("Profile : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesSixData[index]["name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText)),
                        ],
                      ),
                      // EmpID
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Release Note : ",
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesSixData[index]["releaseNote"],
                            style:
                                CardText(font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText),
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
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesSixData[index]['deviceType'],
                            style:
                                CardText(font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText),
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
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                      Row(
                                        children: [
                                          Icon(Icons.battery_charging_full_outlined,
                                              size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesSixData[index]['uT']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Upper Threshold
                                      SizedBox(height: 5),

                                      Text(
                                        "U. Threshold",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                      Row(
                                        children: [
                                          Icon(Icons.battery_6_bar_outlined, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesSixData[index]['uV']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Upper Voltage
                                      SizedBox(height: 5),

                                      Text(
                                        "U.Volt",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                      Row(
                                        children: [
                                          Icon(Icons.battery_alert_outlined, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesSixData[index]['lT']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Lower Threshold
                                      SizedBox(height: 5),

                                      Text(
                                        "L.Threshold",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.battery_2_bar, size: 18, color: secondaryText), // Lower Voltage
                                      Row(
                                        children: [
                                          Icon(Icons.battery_1_bar_rounded, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesSixData[index]['lV']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
// Lower Voltage
                                      Text(
                                        "L. Volt",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
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
    printFunc("Serice six Data : $seriesNineData");
    List<Widget> seriesNineWidgetList = [];

    for (int index = 0; index < ((seriesNineData != null) ? seriesNineData.length : 0); index++) {
      printFunc("DEMO DEMO Profile logs : ${seriesNineData[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(seriesNineData[index]['saved']);
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
                // key: ValueKey('b6_$index'),
                key: ValueKey(
                    'b9_${index}_${seriesNineData[index]['id'].toString()}_${seriesNineData[index]['saved'].toString()}'),

                tilePadding: EdgeInsets.all(5),
                backgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
                collapsedBackgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
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
                          Text("Profile : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesNineData[index]["name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText)),
                        ],
                      ),
                      // EmpID
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Release Note : ",
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesNineData[index]["releaseNote"],
                            style:
                                CardText(font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText),
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
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesNineData[index]['deviceType'],
                            style:
                                CardText(font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText),
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
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                      Row(
                                        children: [
                                          Icon(Icons.battery_charging_full_outlined,
                                              size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesNineData[index]['uT']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Upper Threshold
                                      SizedBox(height: 5),

                                      Text(
                                        "U. Threshold",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                      Row(
                                        children: [
                                          Icon(Icons.battery_6_bar_outlined, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesNineData[index]['uV']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Upper Voltage
                                      SizedBox(height: 5),

                                      Text(
                                        "U.Volt",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                      Row(
                                        children: [
                                          Icon(Icons.battery_alert_outlined, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesNineData[index]['lT']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Lower Threshold
                                      SizedBox(height: 5),

                                      Text(
                                        "L.Threshold",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.battery_2_bar, size: 18, color: secondaryText), // Lower Voltage
                                      Row(
                                        children: [
                                          Icon(Icons.battery_1_bar_rounded, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesNineData[index]['lV']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
// Lower Voltage
                                      Text(
                                        "L. Volt",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
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
    printFunc("Serice six Data : $seriesTwelveData");
    List<Widget> seriesTwelveWidgetList = [];

    for (int index = 0; index < ((seriesTwelveData != null) ? seriesTwelveData.length : 0); index++) {
      printFunc("DEMO DEMO Profile logs : ${seriesTwelveData[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(seriesTwelveData[index]['saved']);
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
                // key: ValueKey('b6_$index'),
                key: ValueKey(
                    'b6_${index}_${seriesTwelveData[index]['id'].toString()}_${seriesTwelveData[index]['saved'].toString()}'),

                tilePadding: EdgeInsets.all(5),
                backgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
                collapsedBackgroundColor: (moreInfo.value) ? SuccessCard : FailureCard,
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
                          Text("Profile : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(seriesTwelveData[index]["name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText)),
                        ],
                      ),
                      // EmpID
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Release Note : ",
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesTwelveData[index]["releaseNote"],
                            style:
                                CardText(font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText),
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
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            seriesTwelveData[index]['deviceType'],
                            style:
                                CardText(font_Weight: FontWeight.w800, size: 19, FontColor: SuccessCardText),
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
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                      Row(
                                        children: [
                                          Icon(Icons.battery_charging_full_outlined,
                                              size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesTwelveData[index]['uT']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Upper Threshold
                                      SizedBox(height: 5),

                                      Text(
                                        "U. Threshold",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                      Row(
                                        children: [
                                          Icon(Icons.battery_6_bar_outlined, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesTwelveData[index]['uV']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Upper Voltage
                                      SizedBox(height: 5),

                                      Text(
                                        "U.Volt",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                      Row(
                                        children: [
                                          Icon(Icons.battery_alert_outlined, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesTwelveData[index]['lT']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Lower Threshold
                                      SizedBox(height: 5),

                                      Text(
                                        "L.Threshold",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.battery_2_bar, size: 18, color: secondaryText), // Lower Voltage
                                      Row(
                                        children: [
                                          Icon(Icons.battery_1_bar_rounded, size: 18, color: secondaryText),
                                          SizedBox(width: 5),
                                          Text(
                                            "${seriesTwelveData[index]['lV']} V",
                                            style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 18,
                                              FontColor: SuccessCardText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
// Lower Voltage
                                      Text(
                                        "L. Volt",
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
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
    List<Map<String, dynamic>> totalProfileList = [];
    final profileFromHive = profileBox.get("$id");

    if (profileFromHive != null) {
      for (var fw in profileFromHive.profile) {
        totalProfileList.add(fw.toJson());
      }
    }
    printFunc("Series B6 Data $totalProfileList");
    return totalProfileList;
  }
}
