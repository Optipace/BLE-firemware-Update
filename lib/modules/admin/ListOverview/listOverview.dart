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
  bool firmware = false;
  bool config = false;
  bool battery = false;
  Map<String, dynamic> firmList = {};
  Map<String, dynamic> batteryList = {};



  Map<String, List<Map<String, dynamic>>> profileListMap = {};

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
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
        "B12": {
          "id": 3,
          "name": "B12",
          "priority": 3
        },
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
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // List of firmware
              GestureDetector(
                onTap: _firmwareSelection,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("List of firmware"),
                      firmware
                          ? Icon(Icons.keyboard_arrow_up)
                          : Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
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
              // ----- List of FirmWare -----
              Visibility(
                visible: firmware,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width : size.width/5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("ID"),
                            ),
                            SizedBox(width: 20,),
                            Container(
                              width : size.width/5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("version"),
                            ),
                            SizedBox(width: 20,),
                            Container(
                              width : size.width/5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("releaseNote"),
                            ),
                          ],
                        ),
                        ...firmList.entries.map((entry) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width : size.width/5,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text("${entry.value["id"]}"),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width : size.width/5,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text("${entry.value["version"]}"),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width : size.width/5,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text("${entry.value["releaseNote"]}"),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  )
              ),
              Visibility(
                  visible: firmware,
                  child: Divider()
              ),



              // List of Batteries
              GestureDetector(
                onTap: _batterySelection,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("List of Batteries"),
                      battery
                          ? Icon(Icons.keyboard_arrow_up)
                          : Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
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
              Visibility(
                  visible: battery,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width : size.width/5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("ID"),
                            ),
                            SizedBox(width: 20,),
                            Container(
                              width : size.width/5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("name"),
                            ),
                            SizedBox(width: 20,),
                            Container(
                              width : size.width/5,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("priority"),
                            ),
                          ],
                        ),
                        ...batteryList.entries.map((entry) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width : size.width/5,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text("${entry.value["id"]}"),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width : size.width/5,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text("${entry.value["name"]}"),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width : size.width/5,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text("${entry.value["priority"]}"),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  )
              ),
              Visibility(
                  visible: battery,
                  child: Divider()
              ),


              // List of config
              GestureDetector(
                onTap: _configSelection,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("List of config"),
                      config
                          ? Icon(Icons.keyboard_arrow_up)
                          : Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
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
              Visibility(
                  visible: config,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        // from here i got the flag thing
                        ... batteryList.entries.map((e)  {
                          final profiles = profileListMap[e.key] ?? [];

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical:0),
                            child:Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey)
                                )
                              ),
                              child:  ExpansionTile(
                                backgroundColor: Colors.transparent,
                                collapsedBackgroundColor: Colors.transparent,
                                iconColor: Colors.black,
                                textColor: Colors.black,
                                collapsedIconColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.transparent)
                                ),
                                tilePadding: EdgeInsets.only(left: 10),
                                childrenPadding: EdgeInsets.zero,
                                title: Text(e.key),

                                children: [
                                  Divider(color: Colors.grey,thickness: 1),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width : size.width/5,
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text("ID"),
                                        ),
                                        Container(
                                          width : size.width/5,
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text("name"),
                                        ),
                                        Container(
                                          width : size.width/5,
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text("releaseNote"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...profiles.map((profile) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: size.width / 5,
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: Text("${profile['id']}"),
                                          ),
                                          Container(
                                            width: size.width / 5,
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: Text("${profile['name']}"),
                                          ),
                                          Container(
                                            width: size.width / 5,
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: Text("${profile['releaseNote']}"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),

                                ],
                              ),
                            )
                          );
                        }).toList(),
                        Divider()
                      ],
                    ),
                  )
              ),

            ],
          ),
        ));
  }

  void _firmwareSelection() {
    // printFunc("DEMO FIRMWARE : $firmList");
    setState(() {
      firmware = !firmware;
      battery = false;
      config = false; // Toggle the boolean value
    });
  }

  void _configSelection() {
    printFunc("DEMO BATTERY LIST : $batteryList");
    setState(() {
      firmware = false;
      config = !config;
      battery = false;
    });
  }

  void _batterySelection() {
    setState(() {
      firmware = false;
      config = false;
      battery = !battery;
    });
  }
}
