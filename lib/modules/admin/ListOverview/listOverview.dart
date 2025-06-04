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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of firmware
                ExpansionTile(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent)),
                  tilePadding: EdgeInsets.only(left: 10),
                  childrenPadding: EdgeInsets.symmetric(horizontal: size.width/30),
                  title: Text("FirmWare"),
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
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("ID"),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: size.width / 5,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Version"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: size.width / 5,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Release Note"),
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
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("${entry.value["id"]}"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: size.width / 5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("${entry.value["version"]}"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: size.width / 5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("${entry.value["releaseNote"]}"),
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
                      Divider(),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),

                // List of Batteries
                ExpansionTile(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent)),
                  tilePadding: EdgeInsets.only(left: 10),
                  childrenPadding: EdgeInsets.symmetric(horizontal: size.width/30),
                  title: Text("Batteries"),

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
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("ID"),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: size.width / 5,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Name"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: size.width / 5,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("Priority"),
                          ),
                        ],
                      ),
                    ),
                    ...batteryList.entries.map((entry) {
                      return Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: size.width / 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width / 5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("${entry.value["id"]}"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: size.width / 5.4,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("${entry.value["name"]}"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: size.width / 5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("${entry.value["priority"]}"),
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
                      Divider(),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),


                // List of config
                ExpansionTile(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent)),
                  tilePadding: EdgeInsets.only(left: 10),
                  childrenPadding: EdgeInsets.symmetric(horizontal: size.width/30),
                  title: Text("Batteries"),

                  children: [
                    Divider(color: Colors.grey, thickness: 1),
                    ...batteryList.entries.map((e) {
                      final profiles = profileListMap[e.key] ?? [];

                      return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(color: Colors.grey))),
                            child: ExpansionTile(
                              backgroundColor: Colors.transparent,
                              collapsedBackgroundColor: Colors.transparent,
                              iconColor: Colors.black,
                              textColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.transparent)),
                              tilePadding: EdgeInsets.only(left: 10),
                              childrenPadding: EdgeInsets.zero,
                              title: Text(e.key),
                              children: [
                                Divider(color: Colors.grey, thickness: 1),
                                Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: size.width / 5,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text("ID"),
                                      ),
                                      Container(
                                        width: size.width / 5,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text("name"),
                                      ),
                                      Container(
                                        width: size.width / 5,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text("releaseNote"),
                                      ),
                                    ],
                                  ),
                                ),
                                ...profiles.map((profile) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: size.width / 5,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text("${profile['id']}"),
                                        ),
                                        Container(
                                          width: size.width / 5,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text("${profile['name']}"),
                                        ),
                                        Container(
                                          width: size.width / 5,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                              "${profile['releaseNote']}"),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ));
                    }).toList(),                  ],
                ),
                SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
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
