import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/login/api/api.dart';
import 'package:tracker_firmware/services/apiCall/firmware.dart';
import 'package:tracker_firmware/services/apiCall/profile.dart';

class listOverview extends StatefulWidget {
  @override
  State<listOverview> createState() => listOverviewState();
}

class listOverviewState extends State<listOverview> {
  Map<String, dynamic> firmList = {};
  Map<String, dynamic> batteryList = {};

  Map<String, List<Map<String, dynamic>>> profileListMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      batteryList = {
        "B6": {
          "id": 1,
          "name": "B6",
          "priority": 1,
        },
        "B9": {
          "id": 2,
          "name": "B9",
          "priority": 2,
        },
        "B12": {"id": 3, "name": "B12", "priority": 3},
      };
      for (var key in batteryList.keys) {
        int batteryId = batteryList[key]!["id"];
        final profiles = await getProfileByID(context, batteryId.toString());
        profileListMap[key] = profiles;
        setState(() {});
      }
      firmList = await getFirmwareList(context);
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
            "List Overview",
            style: TextStyle(
                fontFamily: baseFont,
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: lightBg),
          ),
          toolbarHeight: size.height / 13,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: lightBg,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of firmware
                ExpansionTile(
                  backgroundColor: second_lightBg,
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: darkBg,
                  textColor: Colors.black,
                  collapsedIconColor: darkBg,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: darkBg,width: 0.3),
                    borderRadius: BorderRadius.circular(20),

                  ),
                  collapsedShape:  RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent,width: 0.3),
                    borderRadius: BorderRadius.circular(20),

                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 20),
                  childrenPadding: EdgeInsets.symmetric(horizontal: 35),
                  title: Text("Firmware",
                    style: TextStyle(
                      color: darkBg,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],

                    ),
                  ),

                  children: [
                    Divider(color: darkBg),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width / 5.6,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Id",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],

                              ),
                            ),
                          ),
                          Container(
                            width: size.width /5.4,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Version",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],

                              ),
                            ),
                          ),
                          Container(
                            width: size.width / 4,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Release Note",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          Divider(color: darkBg, thickness: 1),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    ...firmList.entries.map((entry) {
                      return Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: size.width / 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width / 5,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("${entry.value["id"]}",
                                style: TextStyle(
                                  color: darkBg,
                                  fontSize: 18,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.w500,
                                  shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                ) ,
                              ),
                            ),
                            Container(
                              width: size.width / 5.4,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("${entry.value["version"]}",
                                style: TextStyle(
                                    color: darkBg,
                                    fontSize: 18,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w500,
                                    shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                ) ,

                              ),
                            ),
                            Container(
                              width: size.width / 5,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("${entry.value["releaseNote"]}",
                                style: TextStyle(
                                    color: darkBg,
                                    fontSize: 18,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w500,
                                    shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                ) ,

                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
                SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: darkBg,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),

                // List of Batteries
                ExpansionTile(
                  backgroundColor: second_lightBg,
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: darkBg,
                  textColor: Colors.black,
                  collapsedIconColor: darkBg,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: darkBg,width: 0.3),
                      borderRadius: BorderRadius.circular(20),

                  ),
                  collapsedShape:  RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent,width: 0.3),
                    borderRadius: BorderRadius.circular(20),

                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 20),
                  childrenPadding: EdgeInsets.symmetric(horizontal: 35),
                  title: Text("Batteries",
                    style: TextStyle(
                      color: darkBg,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],

                    ),
                  ),

                  children: [
                    Divider(color: Colors.grey, thickness: 1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width / 5,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Id",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],

                              ),
                            ),
                          ),
                          Container(
                            width: size.width / 5,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Name",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],

                              ),
                            ),
                          ),
                          Container(
                            width: size.width / 5.4,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Priority",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],

                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          Divider(color: darkBg, thickness: 1),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    ...batteryList.entries.map((entry) {
                      return Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: size.width / 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width / 5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("${entry.value["id"]}",
                                style: TextStyle(
                                    color: darkBg,
                                    fontSize: 18,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w500,
                                    shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                ) ,
                              ),
                            ),
                            Container(
                              width: size.width / 5.4,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("${entry.value["name"]}",
                                style: TextStyle(
                                    color: darkBg,
                                    fontSize: 18,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w500,
                                    shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                ) ,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              width: size.width / 5.4,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Text("${entry.value["priority"]}",
                                  style: TextStyle(
                                      color: darkBg,
                                      fontSize: 18,
                                      fontFamily: baseFont,
                                      fontWeight: FontWeight.w500,
                                      shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                  ) ,
                                ),
                              )
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
                SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: darkBg,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),


                // List of config
                ExpansionTile(
                  backgroundColor: second_lightBg,
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: darkBg,
                  textColor: Colors.black,
                  collapsedIconColor: darkBg,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: darkBg,width: 0.3),
                    borderRadius: BorderRadius.circular(20),

                  ),
                  collapsedShape:  RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent,width: 0.3),
                    borderRadius: BorderRadius.circular(20),

                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 20),
                  childrenPadding: EdgeInsets.symmetric(horizontal: 35,vertical: 10),
                  title: Text("Config",
                    style: TextStyle(
                      color: darkBg,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      shadows: [Shadow(color: Colors.black,blurRadius: 0.2)],

                    ),
                  ),

                  children: [
                    Divider(color: darkBg),
                    ...batteryList.entries.map((e) {
                      final profiles = profileListMap[e.key] ?? [];

                      return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(color: darkBg,width: 0.5))),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: ExpansionTile(
                              backgroundColor: second_lightBg,
                              collapsedBackgroundColor: Colors.transparent,
                              iconColor: darkBg,
                              textColor: Colors.black,
                              collapsedIconColor: darkBg,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: darkBg,width: 0.3),
                                borderRadius: BorderRadius.circular(20),

                              ),
                              collapsedShape:  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.transparent,width: 0.3),
                                borderRadius: BorderRadius.circular(20),

                              ),
                              tilePadding: EdgeInsets.symmetric(horizontal: 20),
                              childrenPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              title: Text(e.key,
                                style: TextStyle(
                                  color: darkBg,
                                  fontFamily: baseFont,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  shadows: [Shadow(
                                    color: Colors.black,blurRadius: 0.2
                                  )]
                                ),
                              ),
                              children: [
                                Divider(color: darkBg),
                                Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width / 5,
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text("Id",
                                          style: TextStyle(
                                            color: darkBg,
                                            fontFamily: baseFont,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                            shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                          ),
                                        ),

                                      ),
                                      Container(
                                        width: size.width / 4.5,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text("Name",
                                          style: TextStyle(
                                              color: darkBg,
                                              fontFamily: baseFont,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        color: darkBg,
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                ...profiles.map((profile) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width / 5,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text("${profile['id']}",
                                            style: TextStyle(
                                              color: darkBg,
                                              fontFamily: baseFont,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: size.width / 5,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text("${profile['name']}",
                                            style: TextStyle(
                                                color: darkBg,
                                                fontFamily: baseFont,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                shadows: [Shadow(color: Colors.black,blurRadius: 0.2)]
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ));
                    }).toList(),
                  ],
                ),
                SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: darkBg,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}
