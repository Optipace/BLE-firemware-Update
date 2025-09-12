import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/FirmwareSettings/addFirmware.dart';
import 'package:tracker_firmware/modules/admin/ListOverview/api/api.dart';
import 'package:tracker_firmware/modules/admin/api/api.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/services/apiCall/deviceType.dart';
import 'package:tracker_firmware/services/apiCall/firmware.dart';
import 'package:tracker_firmware/services/apiCall/profile.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

import '../../factoryUser/api/hardWareNumber.dart';

TextStyle CardText(
    {required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

TextStyle tileTextStyle = TextStyle(
    color: darkBg,
    fontFamily: baseFont,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    shadows: [
      Shadow(
        color: Colors.black,
        blurRadius: 0.2,
      )
    ]);

TextStyle titleTileStyle = TextStyle(
    color: darkBg,
    fontFamily: baseFont,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    shadows: [
      Shadow(
        color: Colors.black,
        blurRadius: 0.2,
      )
    ]);

class listOverview extends StatefulWidget {
  @override
  State<listOverview> createState() => listOverviewState();
}

class listOverviewState extends State<listOverview> {
  Map<String, dynamic> firmList = {};
  Map<String, dynamic> batteryList = {};
  List<Map<String, dynamic>> allConfigList = [{}];

  DataController SelectedBatch = DataController();
  String macID = "DB:66:15:AE:7E:51";

  Map<String, List<Map<String, dynamic>>> profileListMap = {};

  List<Map<String, dynamic>> batchList = [{}];

  //List for Clients
  List<Map<String, dynamic>> clientList = [];
  Map<String, dynamic> AllClient = {};

  // Controleers for New Battery
  TextEditingController _newbname = TextEditingController();
  TextEditingController _batteryDescription = TextEditingController();
  bool batteryValidator = false;

  // DataController for New configure
  DataController _batterySeries = DataController();

  // Controllers for New Client
  TextEditingController _clientName = TextEditingController();
  TextEditingController _clientAddress = TextEditingController();
  TextEditingController _clientPhno = TextEditingController();
  TextEditingController _clientEmail = TextEditingController();
  TextEditingController _clientContactPerson = TextEditingController();
  TextEditingController _clientDiscription = TextEditingController();
  TextEditingController _clientCode = TextEditingController();
  bool clientValidator = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      clientList = await getAllClients(context);
      clientListIntoMap();
      firmList = await getFirmwareList(context, active: "A");
      allConfigList = await getAllConfigurationList(context, active: "A");
      batteryList = {for (var item in allConfigList) item['deviceName']: item};
      batchList = await getBatchList(context, Status: "A");
      printFunc("batteryList $batteryList");
      for (var key in batteryList.keys) {
        int batteryId = batteryList[key]!["id"];
        printFunc("Battry id : $batteryId");
        printFunc("Battry key : $key");
        //   final profiles = await getProfileByID(context, batteryId.toString());
        //   profileListMap[key] = profiles;
        setState(() {});
      }
      printFunc("DEMO DEMO DEMO : ${batchList}");
      setState(() {});
    });
    setState(() {
      // SelectedBatch.setobj = obj;
    });
    // printFunc("DEMO SELECTED BATCH : ${SelectedBatch.obj}");
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
          toolbarHeight: screenSize.height / 13,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: Colors.white, //Color(0xFFEAF1FB)
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of firmware
                Container(
                  width: screenSize.width,
                  child: ExpansionTile(
                    backgroundColor: backgroundColorTile,
                    collapsedBackgroundColor: collapsedBackgroundColorTile,
                    iconColor: iconColorTile,
                    textColor: textColorTile,
                    collapsedTextColor: collapsedTextColorTile,
                    collapsedIconColor: collapsedIconColorTile,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: borderTile, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(color: borderTile, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                    expandedAlignment: Alignment.center,
                    title: Text(
                      "Firmware",
                      style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 0.2)
                        ],
                      ),
                    ),
                    children: [
                      Divider(
                        color: Colors.grey,
                        thickness: 1.5,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                          child: Text(
                            "Number of FirmWare : ${firmList.length}",
                            style: TextStyle(
                              color: darkBg,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 0.2)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1.5,
                        ),
                      ),
                      ...firmList.entries.map((entry) {
                        printFunc("FirmWAre df : ${entry.value["active"]}");
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                            side: BorderSide(
                                                width: 0.5, color: darkBg)),
                                        child: Container(
                                          width: screenSize.width * 0.8,
                                          height: screenSize.height / 2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              //Title
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(vertical: 10),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(top: 20),
                                                      child: Text(
                                                        "Firmware Details",
                                                        style: TextStyle(
                                                            fontFamily:
                                                            baseFont,
                                                            fontWeight:
                                                            FontWeight
                                                                .w800,
                                                            fontSize: 28,
                                                            color: darkBg),
                                                      ),
                                                    ),
                                                    Divider(
                                                      color: darkBg,
                                                      thickness: 1.5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //main content
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                              width: 60,
                                                              child: Text(
                                                                  "Id :",
                                                                  style:
                                                                  titleTileStyle)),
                                                          Container(
                                                              width: screenSize
                                                                  .width *
                                                                  0.4,
                                                              child: Text(
                                                                  "${entry.value["id"]}",
                                                                  style:
                                                                  tileTextStyle)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 60,
                                                            child: Text(
                                                              "Name :",
                                                              style:
                                                              titleTileStyle,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: screenSize
                                                                .width *
                                                                0.4,
                                                            child: Text(
                                                              "${entry.value["version"]}",
                                                              style:
                                                              tileTextStyle,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 65,
                                                            child: Text(
                                                              "Status : ",
                                                              style:
                                                              titleTileStyle,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: screenSize
                                                                .width *
                                                                0.4,
                                                            child: Text(
                                                              "${entry.value["active"] == 'Y' ? "Active" : "Inactive"}",
                                                              style:
                                                              tileTextStyle,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              "Relase Note : ",
                                                              style:
                                                              titleTileStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Padding(
                                                              padding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                  15,
                                                                  0,
                                                                  0,
                                                                  0),
                                                              child: Text(
                                                                "${entry.value["releaseNote"]}",
                                                                style:
                                                                tileTextStyle,
                                                                softWrap:
                                                                true,
                                                                overflow:
                                                                TextOverflow
                                                                    .visible,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              //Btns
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                        MaterialStateProperty
                                                            .all(darkBg),
                                                        minimumSize:
                                                        MaterialStateProperty
                                                            .all(Size(100,
                                                            40)), // width: 80, height: 40
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Back",
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white,
                                                            fontFamily:
                                                            baseFont,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            shadows: [
                                                              Shadow(
                                                                color: Colors
                                                                    .white,
                                                                blurRadius:
                                                                0.2,
                                                              )
                                                            ]),
                                                      )),
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                        MaterialStateProperty
                                                            .all(darkBg),
                                                        minimumSize:
                                                        MaterialStateProperty
                                                            .all(Size(100,
                                                            40)), // width: 80, height: 40
                                                      ),
                                                      onPressed: () async {
                                                        entry.value["active"] ==
                                                            'Y'
                                                            ? await setFirmwareStatus(
                                                            context,
                                                            id: entry
                                                                .value[
                                                            "id"]
                                                                .toString(),
                                                            status: "N")
                                                            : await setFirmwareStatus(
                                                            context,
                                                            id: entry
                                                                .value[
                                                            "id"]
                                                                .toString(),
                                                            status: "Y");
                                                        firmList =
                                                        await getFirmwareList(
                                                            context,
                                                            active: "A");
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: entry.value[
                                                      "active"] ==
                                                          'Y'
                                                          ? Text(
                                                        "Deactive",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontFamily:
                                                            baseFont,
                                                            fontSize:
                                                            18,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            shadows: [
                                                              Shadow(
                                                                color: Colors
                                                                    .white,
                                                                blurRadius:
                                                                0.2,
                                                              )
                                                            ]),
                                                      )
                                                          : Text(
                                                        "Active",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontFamily:
                                                            baseFont,
                                                            fontSize:
                                                            18,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            shadows: [
                                                              Shadow(
                                                                color: Colors
                                                                    .white,
                                                                blurRadius:
                                                                0.2,
                                                              )
                                                            ]),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.all(1.5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: darkBg),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.folder_open_outlined,
                                          color: darkBg,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${entry.value["version"]}",
                                          style: TextStyle(
                                              color: darkBg,
                                              fontSize: 20,
                                              fontFamily: baseFont,
                                              fontWeight: FontWeight.w500,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 0.2)
                                              ]),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      CupertinoIcons.chevron_right_2,
                                      color: darkBg,
                                      weight: 40,
                                      size: 28,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }).toList(),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (_) => AddNewFirmware(
                                selectedBtn: 1,
                              )));
                          firmList =
                          await getFirmwareList(context, active: "A");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: darkBg),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                              padding: EdgeInsets.only(right: 5, left: 15),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add_rounded,
                                        color: darkBg,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "ADD FIRMWARE",
                                        style: TextStyle(
                                            color: darkBg,
                                            fontFamily: baseFont,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 0.2)
                                            ]),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),

                // List of config
                ExpansionTile(
                  backgroundColor: backgroundColorTile,
                  collapsedBackgroundColor: collapsedBackgroundColorTile,
                  iconColor: iconColorTile,
                  textColor: textColorTile,
                  collapsedTextColor: collapsedTextColorTile,
                  collapsedIconColor: collapsedIconColorTile,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: borderTile, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: borderTile, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tilePadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  childrenPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  title: Text(
                    "Config",
                    style: TextStyle(
                      color: darkBg,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                    ),
                  ),
                  children: [
                    Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                        child: Text(
                          "Number of Batteries : ${batteryList.length}",
                          style: TextStyle(
                            color: darkBg,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 0.2)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1.5,
                      ),
                    ),
                    ...batteryList.entries.map((e) {
                      printFunc("...batteryList.entries.map((e) { ->\n$e");
                      final profiles = e.value["configuration"] ?? [];

                      return Column(
                        children: [
                          ExpansionTile(
                            backgroundColor: second_lightBg.withOpacity(0.5),
                            collapsedBackgroundColor: Colors.transparent,
                            iconColor: darkBg,
                            textColor: Colors.black,
                            collapsedIconColor: darkBg,
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: darkBg)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: darkBg)),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.battery_charging_full_rounded,
                                  color: darkBg,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  e.key,
                                  style: TextStyle(
                                      color: darkBg,
                                      fontFamily: baseFont,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 0.2)
                                      ]),
                                ),
                              ],
                            ),
                            children: [
                              Column(
                                children: [
                                  Divider(
                                    color: darkBg,
                                    thickness: 2,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Id :",
                                              style: tileTextStyle,
                                            ),
                                            Text(
                                              "${e.value['id']}",
                                              style: tileTextStyle,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Name : ",
                                              style: tileTextStyle,
                                            ),
                                            Text(
                                              "${e.value['deviceName']}",
                                              style: tileTextStyle,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Battery-Code : ",
                                              style: tileTextStyle,
                                            ),
                                            Container(
                                              width: screenSize.width / 2.5,
                                              child: Text(
                                                "${e.value['discription']}",
                                                style: tileTextStyle,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    child: ExpansionTile(
                                      title: Text(
                                        "View Config's",
                                        style: TextStyle(
                                            color: darkBg,
                                            fontFamily: baseFont,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 0.2)
                                            ]),
                                      ),
                                      backgroundColor: Colors.white,
                                      collapsedBackgroundColor: Colors.white,
                                      iconColor: darkBg,
                                      textColor: Colors.black,
                                      collapsedIconColor: darkBg,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: darkBg, width: 0.3),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      collapsedShape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          side: BorderSide(color: darkBg)),
                                      tilePadding: EdgeInsets.symmetric(
                                          horizontal: 20),
                                      childrenPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      children: [
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 1.5,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                15, 10, 0, 10),
                                            child: Text(
                                              "Number of Config's : ${profiles.length}",
                                              style: TextStyle(
                                                color: darkBg,
                                                fontFamily: baseFont,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 0.2)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 10),
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1.5,
                                          ),
                                        ),
                                        ...profiles.map((profile) {
                                          printFunc(
                                              "PROFILE df ${profile["active"]}");
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        barrierDismissible:
                                                        false,
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    15),
                                                                side: BorderSide(
                                                                    width:
                                                                    0.5,
                                                                    color:
                                                                    darkBg)),
                                                            child: Container(
                                                              width: screenSize
                                                                  .width *
                                                                  0.95,
                                                              height: screenSize
                                                                  .height /
                                                                  1.5,
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    15),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  //Title
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                        10),
                                                                    child:
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                          const EdgeInsets.only(top: 20),
                                                                          child:
                                                                          Text(
                                                                            "Config Details",
                                                                            style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 28, color: darkBg),
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          color:
                                                                          darkBg,
                                                                          thickness:
                                                                          1.5,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  //main content
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                "Id:",
                                                                                style: titleTileStyle,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Text(
                                                                                "${profile['id']}",
                                                                                style: tileTextStyle,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                "Name : ",
                                                                                style: titleTileStyle,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Text(
                                                                                "${profile['name']}",
                                                                                style: tileTextStyle,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                "Status : ",
                                                                                style: titleTileStyle,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Text(
                                                                                "${profile['active'] == "Y" ? "Active" : "Inactive"}",
                                                                                style: tileTextStyle,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                        10,
                                                                      ),
                                                                      SizedBox(
                                                                        child:
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Divider(
                                                                              color: Colors.black26,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin:
                                                                        EdgeInsets.only(left: 20),
                                                                        child:
                                                                        Align(
                                                                          alignment:
                                                                          Alignment.centerLeft,
                                                                          child:
                                                                          Column(
                                                                            children: [
                                                                              Text(
                                                                                "Description : ",
                                                                                style: titleTileStyle,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Container(
                                                                                width: screenSize.width * 0.8,
                                                                                child: Text(
                                                                                  "${profile['discription']}",
                                                                                  style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, fontFamily: baseFont, fontSize: 14, shadows: [
                                                                                    Shadow(color: Colors.black)
                                                                                  ]),
                                                                                ),
                                                                              )
                                                                            ],
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        child:
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Divider(
                                                                              color: Colors.black26,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left: 20,
                                                                            right: 20),
                                                                        child:
                                                                        FittedBox(
                                                                          child:
                                                                          Column(
                                                                            children: [
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                                                                      Text("U. Threshold", style: titleTileStyle),

                                                                                      // Upper Threshold
                                                                                      SizedBox(height: 5),
                                                                                      Row(
                                                                                        children: [
                                                                                          Icon(Icons.battery_charging_full_outlined, size: 18, color: secondaryText),
                                                                                          SizedBox(width: 5),
                                                                                          Text(
                                                                                            "${profile['upperThreshold']} V",
                                                                                            style: tileTextStyle,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(width: 20),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                                                                      Text(
                                                                                        "U.Volt",
                                                                                        style: titleTileStyle,
                                                                                      ),
                                                                                      // Upper Voltage
                                                                                      SizedBox(height: 5),
                                                                                      Row(
                                                                                        children: [
                                                                                          Icon(Icons.battery_6_bar_outlined, size: 18, color: secondaryText),
                                                                                          SizedBox(width: 5),
                                                                                          Text("${profile['upperVoltage']} V", style: tileTextStyle),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(width: 20),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                                                                      Text(
                                                                                        "L.Threshold",
                                                                                        style: titleTileStyle,
                                                                                      ),
                                                                                      // Lower Threshold
                                                                                      SizedBox(height: 5),
                                                                                      Row(
                                                                                        children: [
                                                                                          Icon(Icons.battery_alert_outlined, size: 18, color: secondaryText),
                                                                                          SizedBox(width: 5),
                                                                                          Text(
                                                                                            "${profile['lowerThreshold']} V",
                                                                                            style: tileTextStyle,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(width: 20),
                                                                                  Column(
                                                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Icon(Icons.battery_2_bar, size: 18, color: secondaryText), // Lower Voltage
                                                                                      Text(
                                                                                        "L. Volt",
                                                                                        style: titleTileStyle,
                                                                                      ),
                                                                                      SizedBox(height: 5),
                                                                                      Row(
                                                                                        children: [
                                                                                          Icon(Icons.battery_1_bar_rounded, size: 18, color: secondaryText),
                                                                                          SizedBox(width: 5),
                                                                                          Text(
                                                                                            "${profile['lowerVoltage']} V",
                                                                                            style: tileTextStyle,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                                                                      Text("N. Voltage", style: titleTileStyle),

                                                                                      // Upper Threshold
                                                                                      SizedBox(height: 5),
                                                                                      Row(
                                                                                        children: [
                                                                                          Icon(Icons.battery_charging_full_outlined, size: 18, color: secondaryText),
                                                                                          SizedBox(width: 5),
                                                                                          Text(
                                                                                            "${profile['normalVoltage']} V",
                                                                                            style: tileTextStyle,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(width: 20),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                                                                      Text(
                                                                                        "U.Temp",
                                                                                        style: titleTileStyle,
                                                                                      ),
                                                                                      // Upper Voltage
                                                                                      SizedBox(height: 5),
                                                                                      Text("${profile['upperTemperature']}", style: tileTextStyle),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(width: 20),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                                                                      Text(
                                                                                        "L.Temp",
                                                                                        style: titleTileStyle,
                                                                                      ),
                                                                                      // Lower Threshold
                                                                                      SizedBox(height: 5),
                                                                                      Text(
                                                                                        "${profile['lowerTemperature']}",
                                                                                        style: tileTextStyle,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                        20,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  //Btns
                                                                  SizedBox(
                                                                    height:
                                                                    10,
                                                                  ),

                                                                  Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                    children: [
                                                                      ElevatedButton(
                                                                          style:
                                                                          ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(darkBg),
                                                                            minimumSize: MaterialStateProperty.all(Size(100, 40)), // width: 80, height: 40
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                          Text(
                                                                            "Back",
                                                                            style: TextStyle(color: Colors.white, fontFamily: baseFont, fontSize: 18, fontWeight: FontWeight.w500, shadows: [
                                                                              Shadow(
                                                                                color: Colors.white,
                                                                                blurRadius: 0.2,
                                                                              )
                                                                            ]),
                                                                          )),
                                                                      ElevatedButton(
                                                                          style:
                                                                          ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(darkBg),
                                                                            minimumSize: MaterialStateProperty.all(Size(100, 40)), // width: 80, height: 40
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            profile["active"] == 'Y' ? await setconfigStatus(context, id: profile["id"].toString(), status: "N") : await setconfigStatus(context, id: profile["id"].toString(), status: "Y");
                                                                            allConfigList = await getAllConfigurationList(context, active: "A");
                                                                            batteryList = {
                                                                              for (var item in allConfigList) item['deviceName']: item
                                                                            };
                                                                            setState(() {});
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: profile["active"] == 'Y'
                                                                              ? Text(
                                                                            "Deactive",
                                                                            style: TextStyle(color: Colors.white, fontFamily: baseFont, fontSize: 18, fontWeight: FontWeight.w500, shadows: [
                                                                              Shadow(
                                                                                color: Colors.white,
                                                                                blurRadius: 0.2,
                                                                              )
                                                                            ]),
                                                                          )
                                                                              : Text(
                                                                            "Active",
                                                                            style: TextStyle(color: Colors.white, fontFamily: baseFont, fontSize: 18, fontWeight: FontWeight.w500, shadows: [
                                                                              Shadow(
                                                                                color: Colors.white,
                                                                                blurRadius: 0.2,
                                                                              )
                                                                            ]),
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    margin:
                                                    EdgeInsets.all(1.5),
                                                    padding:
                                                    EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: darkBg),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.memory,
                                                                color: darkBg,
                                                                size: 18,
                                                                weight: 50),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              profile['name'],
                                                              style: TextStyle(
                                                                  color:
                                                                  darkBg,
                                                                  fontFamily:
                                                                  baseFont,
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.w500,
                                                                  shadows: [
                                                                    Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        blurRadius:
                                                                        0.2)
                                                                  ]),
                                                            ),
                                                          ],
                                                        ),
                                                        Icon(
                                                            CupertinoIcons
                                                                .chevron_right_2,
                                                            color: darkBg,
                                                            weight: 40,
                                                            size: 22)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          );
                                        }).toList(),
                                        GestureDetector(
                                          onTap: () {
                                            _batterySeries.cleardata();
                                            setState(() {
                                              _batterySeries.setText = e.key;
                                              _batterySeries.setobj = e.value;
                                            });

                                            printFunc(
                                                "DEMO Battery series in lists - ${_batterySeries.getText}");
                                            Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                    builder: (_) =>
                                                        AddNewFirmware(
                                                          selectedBtn: 2,
                                                          batterySeries:
                                                          _batterySeries,
                                                        )));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                                border:
                                                Border.all(color: darkBg),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5, left: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.add_rounded,
                                                          color: darkBg,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "ADD CONFIG",
                                                          style: TextStyle(
                                                              color: darkBg,
                                                              fontFamily:
                                                              baseFont,
                                                              fontSize: 22,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              shadows: [
                                                                Shadow(
                                                                    color: Colors
                                                                        .black,
                                                                    blurRadius:
                                                                    0.2)
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    }).toList(),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await BottomSheet_Widget(context, color: lightBg, [
                          StatefulBuilder(builder:
                              (thisLowerContext, checkListBatteryState) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(thisLowerContext)
                                    .viewInsets
                                    .bottom,
                              ),
                              child: SingleChildScrollView(
                                child: Container(
                                  height: screenSize.height / 1.5,
                                  width: screenSize.width,
                                  color: lightBg,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Enter Battery Details!",
                                            style: TextStyle(
                                                fontFamily: baseFont,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 24,
                                                color: darkBg,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 0.5,
                                                      offset:
                                                      Offset(0.5, 0.5))
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                // Battery Name
                                                LabelText(
                                                    text: "Battery Name :"),
                                                TextFeildNewUser(
                                                  hintText:
                                                  "Enter Battery Name",
                                                  Controller: _newbname,
                                                  onChanged: (value) {},
                                                  enable: true,
                                                  etext: batteryValidator &&
                                                      _newbname.text
                                                          .trim()
                                                          .isEmpty
                                                      ? "Please Enter Battery Name"
                                                      : "",
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                // Relase Note
                                                LabelText(
                                                    text: "Battery Code"),
                                                TextFeildNewUser(
                                                  hintText:
                                                  "Enter Battery Code",
                                                  Controller:
                                                  _batteryDescription,
                                                  onChanged: (value) {},
                                                  type: TextInputType.number,
                                                  maxLength: 2,
                                                  enable: true,
                                                  etext: batteryValidator &&
                                                      _batteryDescription
                                                          .text
                                                          .trim()
                                                          .isEmpty
                                                      ? "Please Enter Battery Code"
                                                      : "",
                                                ),

                                                SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Add Btn
                                          manageUserBtn(
                                              text: "Add Battery",
                                              onPress: () async {
                                                printFunc("DEMODEMO");
                                                printFunc(batteryValidator);
                                                printFunc(_newbname.text
                                                    .trim()
                                                    .isEmpty);
                                                checkListBatteryState(() {
                                                  ValidateBatteryFields();
                                                });
                                                Future.delayed(
                                                    Duration(seconds: 3))
                                                    .then((_) {
                                                  checkListBatteryState(() {
                                                    batteryValidator = false;
                                                  });
                                                });

                                                if (!batteryValidator) {
                                                  printFunc("Inside IF COND");
                                                  if (await addNewDeviceType(
                                                    context,
                                                    name:
                                                    _newbname.text.trim(),
                                                    description:
                                                    _batteryDescription
                                                        .text
                                                        .trim(),
                                                  )) {
                                                    allConfigList =
                                                    await getAllConfigurationList(
                                                        context,
                                                        active: "A");
                                                    batteryList = {
                                                      for (var item
                                                      in allConfigList)
                                                        item['deviceName']:
                                                        item
                                                    };
                                                    clearConfig();
                                                    // Navigator.of(context,rootNavigator: true).pop();//(MaterialPageRoute(builder: (_) => AdminMain()));
                                                  }
                                                }

                                                setState(() {});
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                        ]);
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: darkBg),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: EdgeInsets.only(right: 5, left: 15),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: darkBg,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "ADD BATTERY",
                                      style: TextStyle(
                                          color: darkBg,
                                          fontFamily: baseFont,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 0.2)
                                          ]),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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

                // List of Batches
                ExpansionTile(
                  backgroundColor: backgroundColorTile,
                  collapsedBackgroundColor: collapsedBackgroundColorTile,
                  iconColor: iconColorTile,
                  textColor: textColorTile,
                  collapsedIconColor: collapsedIconColorTile,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: borderTile, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: borderTile, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tilePadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                  title: Text(
                    "Batches",
                    style: TextStyle(
                      color: darkBg,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                    ),
                  ),
                  children: [
                    Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                        child: Text(
                          "Number of Batches : ${batchList.length}",
                          style: TextStyle(
                            color: darkBg,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 0.2)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1.5,
                      ),
                    ),
                    ...batchList.map((batch) {
                      printFunc("DEMO BATCH : ${batch}");
                      // batch
                      final batchId = batch['id'] ?? '';
                      final batchname = batch['name'] ?? '';
                      final batchActive =
                      batch['active'].toString().toUpperCase() == 'Y'
                          ? "Active"
                          : "Inactive";

                      // Profile
                      final configName = batch['profile']?['name'] ?? 'N/A';
                      final configUpThershold =
                          batch['profile']?['uT'] ?? 'N/A';
                      final configLowThershold =
                          batch['profile']?['lT'] ?? 'N/A';
                      final configUpVolt = batch['profile']?['uV'] ?? 'N/A';
                      final configLowVolt = batch['profile']?['lV'] ?? 'N/A';
                      final configNominalVolt =
                          batch['profile']?['nV'] ?? 'N/A';
                      final configUpperTemp =
                          batch['profile']?['uTemp'] ?? 'N/A';
                      final configLowerTemp =
                          batch['profile']?['lTemp'] ?? 'N/A';

                      // Firmware
                      final firmwareId = batch['firmware']?['id'] ?? 'N/A';
                      final firmwareVersion =
                          batch['firmware']?['versionName'] ?? 'N/A';
                      final firmwareRelaseNote = batch['firmware']
                      ?['releaseDate']
                          .toString()
                          .split("T")[0] ??
                          'N/A';

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          side: BorderSide(
                                              width: 0.5, color: darkBg)),
                                      child: Container(
                                        width: screenSize.width * 0.8,
                                        height: screenSize.height / 1.3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            //Title
                                            Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 20),
                                                    child: Text(
                                                      "${batchname}",
                                                      style: TextStyle(
                                                          fontFamily:
                                                          baseFont,
                                                          fontWeight:
                                                          FontWeight.w800,
                                                          fontSize: 28,
                                                          color: darkBg),
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: darkBg,
                                                    thickness: 1.5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //main content
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 5, 20, 10),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Batch ",
                                                              style: TextStyle(
                                                                  color:
                                                                  darkBg,
                                                                  fontFamily:
                                                                  baseFont,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  shadows: [
                                                                    Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        blurRadius:
                                                                        0.2)
                                                                  ]),
                                                            ),
                                                            SizedBox(
                                                                width: 10),
                                                            // spacing before line
                                                            Expanded(
                                                              child:
                                                              Container(
                                                                height: 1,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                    darkBg,
                                                                    border: Border.all(
                                                                        width:
                                                                        1.5,
                                                                        color:
                                                                        darkBg)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  "Id : ",
                                                                  style:
                                                                  titleTileStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  "${batchId}",
                                                                  style:
                                                                  tileTextStyle,
                                                                )
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  "Name : ",
                                                                  style:
                                                                  titleTileStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  "${batchname}",
                                                                  style:
                                                                  tileTextStyle,
                                                                )
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  "Status : ",
                                                                  style:
                                                                  titleTileStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  "${batchActive}",
                                                                  style:
                                                                  tileTextStyle,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Firmware",
                                                              style: TextStyle(
                                                                  color:
                                                                  darkBg,
                                                                  fontFamily:
                                                                  baseFont,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  shadows: [
                                                                    Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        blurRadius:
                                                                        0.2)
                                                                  ]),
                                                            ),
                                                            SizedBox(
                                                                width: 10),
                                                            // spacing before line
                                                            Expanded(
                                                              child:
                                                              Container(
                                                                height: 1,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                    darkBg,
                                                                    border: Border.all(
                                                                        width:
                                                                        1.5,
                                                                        color:
                                                                        darkBg)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(" Id : ",
                                                                    style:
                                                                    titleTileStyle),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  "${firmwareId}",
                                                                  style:
                                                                  tileTextStyle,
                                                                )
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  "Version : ",
                                                                  style:
                                                                  titleTileStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  "${firmwareVersion}",
                                                                  style:
                                                                  tileTextStyle,
                                                                )
                                                              ],
                                                            ),
                                                            //Release Note
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  "Relase Date : ",
                                                                  style:
                                                                  titleTileStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  "${firmwareRelaseNote}",
                                                                  style:
                                                                  tileTextStyle,
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Config : ${configName} ",
                                                              style: TextStyle(
                                                                  color:
                                                                  darkBg,
                                                                  fontFamily:
                                                                  baseFont,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  shadows: [
                                                                    Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        blurRadius:
                                                                        0.2)
                                                                  ]),
                                                            ),
                                                            SizedBox(
                                                                width: 10),
                                                            // spacing before line
                                                            Expanded(
                                                              child:
                                                              Container(
                                                                height: 1,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                    darkBg,
                                                                    border: Border.all(
                                                                        width:
                                                                        1.5,
                                                                        color:
                                                                        darkBg)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 3.0,
                                                              right: 3),
                                                          child: FittedBox(
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                      children: [
                                                                        // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                                                        Text(
                                                                          "U. Threshold",
                                                                          style:
                                                                          titleTileStyle,
                                                                        ),

                                                                        // Upper Threshold
                                                                        SizedBox(
                                                                            height: 5),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.battery_charging_full_outlined, size: 18, color: darkBg),
                                                                            SizedBox(width: 5),
                                                                            Text(
                                                                              "${configUpThershold} V",
                                                                              style: tileTextStyle,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                        20),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                      children: [
                                                                        // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                                                        Text(
                                                                          "U.Volt",
                                                                          style:
                                                                          titleTileStyle,
                                                                        ),
                                                                        // Upper Voltage
                                                                        SizedBox(
                                                                            height: 5),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.battery_6_bar_outlined, size: 18, color: darkBg),
                                                                            SizedBox(width: 5),
                                                                            Text(
                                                                              "${configUpVolt} V",
                                                                              style: tileTextStyle,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                        20),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                      children: [
                                                                        // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                                                        Text(
                                                                          "L.Threshold",
                                                                          style:
                                                                          titleTileStyle,
                                                                        ),
                                                                        // Lower Threshold
                                                                        SizedBox(
                                                                            height: 5),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.battery_alert_outlined, size: 18, color: darkBg),
                                                                            SizedBox(width: 5),
                                                                            Text(
                                                                              "${configLowThershold} V",
                                                                              style: tileTextStyle,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                        20),
                                                                    Column(
                                                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        // Icon(Icons.battery_2_bar, size: 18, color: secondaryText), // Lower Voltage
                                                                        Text(
                                                                          "L. Volt",
                                                                          style:
                                                                          titleTileStyle,
                                                                        ),
                                                                        SizedBox(
                                                                            height: 5),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.battery_1_bar_rounded, size: 18, color: darkBg),
                                                                            SizedBox(width: 5),
                                                                            Text(
                                                                              "${configLowVolt} V",
                                                                              style: tileTextStyle,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                      children: [
                                                                        // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                                                        Text(
                                                                          "N. Volt",
                                                                          style:
                                                                          titleTileStyle,
                                                                        ),

                                                                        // Upper Threshold
                                                                        SizedBox(
                                                                            height: 5),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.battery_charging_full_outlined, size: 18, color: darkBg),
                                                                            SizedBox(width: 5),
                                                                            Text(
                                                                              "${configNominalVolt} V",
                                                                              style: tileTextStyle,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                        20),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                      children: [
                                                                        // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                                                        Text(
                                                                          "U.Temp",
                                                                          style:
                                                                          titleTileStyle,
                                                                        ),
                                                                        // Upper Voltage
                                                                        SizedBox(
                                                                            height: 5),
                                                                        Text(
                                                                          "${configUpperTemp}",
                                                                          style:
                                                                          tileTextStyle,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                        20),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                      children: [
                                                                        // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                                                        Text(
                                                                          "L.Temp",
                                                                          style:
                                                                          titleTileStyle,
                                                                        ),
                                                                        // Lower Threshold
                                                                        SizedBox(
                                                                            height: 5),
                                                                        Text(
                                                                          "${configLowerTemp}",
                                                                          style:
                                                                          tileTextStyle,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //Btns
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty
                                                          .all(darkBg),
                                                      minimumSize:
                                                      MaterialStateProperty
                                                          .all(Size(100,
                                                          40)), // width: 80, height: 40
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Back",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                          baseFont,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors
                                                                  .white,
                                                              blurRadius: 0.2,
                                                            )
                                                          ]),
                                                    )),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty
                                                          .all(darkBg),
                                                      minimumSize:
                                                      MaterialStateProperty
                                                          .all(Size(100,
                                                          40)), // width: 80, height: 40
                                                    ),
                                                    onPressed: () async {
                                                      batchActive == "Active"
                                                          ? await setBacthesStatus(
                                                          context,
                                                          id: batchId,
                                                          status: "N")
                                                          : await setBacthesStatus(
                                                          context,
                                                          id: batchId,
                                                          status: "Y");
                                                      batchList =
                                                      await getBatchList(
                                                          context,
                                                          Status: "A");
                                                      setState(() {});
                                                      Navigator.of(context)
                                                          .pop();
                                                      batchActive == "Active"
                                                          ? ShowSnackBarMessage(
                                                          context,
                                                          'Batch De-activated successfully!',
                                                          true)
                                                          : ShowSnackBarMessage(
                                                          context,
                                                          'Batch Activated successfully!',
                                                          true);
                                                    },
                                                    child: batchActive ==
                                                        "Active"
                                                        ? Text(
                                                      "Deactive",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          baseFont,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors
                                                                  .white,
                                                              blurRadius:
                                                              0.2,
                                                            )
                                                          ]),
                                                    )
                                                        : Text(
                                                      "Active",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          baseFont,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors
                                                                  .white,
                                                              blurRadius:
                                                              0.2,
                                                            )
                                                          ]),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.all(1.5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: darkBg),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.computer,
                                        color: darkBg,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        batchname,
                                        style: TextStyle(
                                            color: darkBg,
                                            fontFamily: baseFont,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 0.2)
                                            ]),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    CupertinoIcons.chevron_right_2,
                                    color: darkBg,
                                    weight: 40,
                                    size: 28,
                                  )
                                ],
                              ),
                            ),
                          ),

                          /*ExpansionTile(
                              backgroundColor: Colors.white,
                              collapsedBackgroundColor: second_lightBg,
                              iconColor: darkBg,
                              textColor: Colors.black,
                              collapsedIconColor: darkBg,
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: darkBg)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: darkBg)),
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.computer,
                                    color: darkBg,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    batchname,
                                    style: TextStyle(
                                        color: darkBg,
                                        fontFamily: baseFont,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 0.2)
                                        ]),
                                  ),
                                ],
                              ),
                              children: [
                                Divider(
                                  color: darkBg,
                                  thickness: 2,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.computer,
                                                      color: darkBg,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Batch Details ",
                                                      style: TextStyle(
                                                          color: darkBg,
                                                          fontFamily: baseFont,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          shadows: [
                                                            Shadow(
                                                                color:
                                                                    Colors.black,
                                                                blurRadius: 0.2)
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: darkBg,
                                                  thickness: 0.8,
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Id : ",
                                                      style: titleTileStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "${batchId}",
                                                      style: tileTextStyle,
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Name : ",
                                                      style: titleTileStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "${batchname}",
                                                      style: tileTextStyle,
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Status : ",
                                                      style: titleTileStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "${batchActive}",
                                                      style: tileTextStyle,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.folder_open_outlined,
                                                      color: darkBg,
                                                      size: 22,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Firmware Details",
                                                      style: TextStyle(
                                                          color: darkBg,
                                                          fontFamily: baseFont,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          shadows: [
                                                            Shadow(
                                                                color:
                                                                    Colors.black,
                                                                blurRadius: 0.2)
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: darkBg,
                                                  thickness: 0.8,
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(" Id : ",
                                                        style: titleTileStyle),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "${firmwareId}",
                                                      style: tileTextStyle,
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Version : ",
                                                      style: titleTileStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "${firmwareVersion}",
                                                      style: tileTextStyle,
                                                    )
                                                  ],
                                                ),
                                                //Release Note
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Relase Date : ",
                                                      style: titleTileStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "${firmwareRelaseNote}",
                                                      style: tileTextStyle,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.memory,
                                                        color: darkBg,
                                                        size: 18,
                                                        weight: 50),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Config : ${configName} ",
                                                      style: TextStyle(
                                                          color: darkBg,
                                                          fontFamily: baseFont,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          shadows: [
                                                            Shadow(
                                                                color:
                                                                    Colors.black,
                                                                blurRadius: 0.2)
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: darkBg,
                                                  thickness: 0.8,
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0, right: 3),
                                              child: FittedBox(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                                            Text(
                                                              "U. Threshold",
                                                              style:
                                                                  titleTileStyle,
                                                            ),

                                                            // Upper Threshold
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .battery_charging_full_outlined,
                                                                    size: 18,
                                                                    color:
                                                                        darkBg),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  "${configUpThershold} V",
                                                                  style:
                                                                      tileTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 20),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                                            Text(
                                                              "U.Volt",
                                                              style:
                                                                  titleTileStyle,
                                                            ),
                                                            // Upper Voltage
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .battery_6_bar_outlined,
                                                                    size: 18,
                                                                    color:
                                                                        darkBg),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  "${configUpVolt} V",
                                                                  style:
                                                                      tileTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 20),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                                            Text(
                                                              "L.Threshold",
                                                              style:
                                                                  titleTileStyle,
                                                            ),
                                                            // Lower Threshold
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .battery_alert_outlined,
                                                                    size: 18,
                                                                    color:
                                                                        darkBg),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  "${configLowThershold} V",
                                                                  style:
                                                                      tileTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 20),
                                                        Column(
                                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            // Icon(Icons.battery_2_bar, size: 18, color: secondaryText), // Lower Voltage
                                                            Text(
                                                              "L. Volt",
                                                              style:
                                                                  titleTileStyle,
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .battery_1_bar_rounded,
                                                                    size: 18,
                                                                    color:
                                                                        darkBg),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  "${configLowVolt} V",
                                                                  style:
                                                                      tileTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ), */

                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    }).toList(),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => AddNewFirmware(
                              selectedBtn: 3,
                            )));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: darkBg),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: EdgeInsets.only(right: 5, left: 15),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: darkBg,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "ADD BATCH",
                                      style: TextStyle(
                                          color: darkBg,
                                          fontFamily: baseFont,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black26,
                                                blurRadius: 0.4)
                                          ]),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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

                // List of Clients
                Container(
                  width: screenSize.width,
                  child: ExpansionTile(
                    backgroundColor: backgroundColorTile,
                    collapsedBackgroundColor: collapsedBackgroundColorTile,
                    iconColor: iconColorTile,
                    textColor: textColorTile,
                    collapsedTextColor: collapsedTextColorTile,
                    collapsedIconColor: collapsedIconColorTile,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: borderTile, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(color: borderTile, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                    expandedAlignment: Alignment.center,
                    title: Text(
                      "Clients",
                      style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 0.2)
                        ],
                      ),
                    ),
                    children: [
                      Divider(
                        color: Colors.grey,
                        thickness: 1.5,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                          child: Text(
                            "Number of Clients : ${AllClient.length}",
                            style: TextStyle(
                              color: darkBg,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 0.2)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1.5,
                        ),
                      ),
                      ...AllClient.entries.map((entry) {
                        printFunc("FirmWAre df : ${entry.value["active"]}");
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                            side: BorderSide(
                                                width: 0.5, color: darkBg)),
                                        child: Container(
                                          width: screenSize.width * 0.8,
                                          height: screenSize.height / 1.6,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              //Title
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20),
                                                  child: CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor: darkBg,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.person,
                                                        color: lightBg,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  )

                                                /* Icon(CupertinoIcons.person_circle_fill,color: darkBg,size: 100,shadows: [
                      Shadow(color: Colors.black,blurRadius: 0.5,offset: Offset(0.4, 0.4))
                    ])*/
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),

                                              // Name
                                              Text(
                                                "Client Details",
                                                style: TextStyle(
                                                    fontFamily: baseFont,
                                                    fontWeight:
                                                    FontWeight.w800,
                                                    fontSize: 28,
                                                    color: darkBg),
                                              ),
                                              Divider(color: darkBg),

                                              //Main Content
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    20, 10, 10, 10),
                                                // left:20, right:10
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Table(
                                                    columnWidths: {
                                                      0: IntrinsicColumnWidth(),
                                                      // heading
                                                      1: FixedColumnWidth(10),
                                                      // colon
                                                      2: FlexColumnWidth(),
                                                      // value
                                                    },
                                                    defaultVerticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                    children: [
                                                      TableRow(
                                                        children: [
                                                          Text("Customer-ID",
                                                              style:
                                                              titleTileStyle),
                                                          Text(":",
                                                              style:
                                                              titleTileStyle),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                "${entry.value["code"]}",
                                                                style:
                                                                tileTextStyle),
                                                          ),
                                                        ],
                                                      ),
                                                      TableRow(children: [
                                                        SizedBox(height: 10),
                                                        SizedBox(),
                                                        SizedBox()
                                                      ]),
                                                      TableRow(
                                                        children: [
                                                          Text(
                                                              "Customer Name",
                                                              style:
                                                              titleTileStyle),
                                                          Text(":",
                                                              style:
                                                              titleTileStyle),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                "${entry.value["name"]}",
                                                                style:
                                                                tileTextStyle),
                                                          ),
                                                        ],
                                                      ),
                                                      TableRow(children: [
                                                        SizedBox(height: 10),
                                                        SizedBox(),
                                                        SizedBox()
                                                      ]),
                                                      TableRow(
                                                        children: [
                                                          Text(
                                                              "Customer Mail",
                                                              style:
                                                              titleTileStyle),
                                                          Text(":",
                                                              style:
                                                              titleTileStyle),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  "${entry.value["email"]}",
                                                                  style:
                                                                  tileTextStyle),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      TableRow(children: [
                                                        SizedBox(height: 10),
                                                        SizedBox(),
                                                        SizedBox()
                                                      ]),
                                                      TableRow(
                                                        children: [
                                                          Text(
                                                              "Contact Number",
                                                              style:
                                                              titleTileStyle),
                                                          Text(":",
                                                              style:
                                                              titleTileStyle),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            // force left align
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  "${entry.value["contactNumber"]}",
                                                                  style:
                                                                  tileTextStyle),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      TableRow(children: [
                                                        SizedBox(height: 10),
                                                        SizedBox(),
                                                        SizedBox()
                                                      ]),
                                                      TableRow(
                                                        children: [
                                                          Text(
                                                              "Contact Person",
                                                              style:
                                                              titleTileStyle),
                                                          Text(":",
                                                              style:
                                                              titleTileStyle),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                "${entry.value["contactPerson"]}",
                                                                style:
                                                                tileTextStyle),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              //Btns
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                        MaterialStateProperty
                                                            .all(darkBg),
                                                        minimumSize:
                                                        MaterialStateProperty
                                                            .all(Size(100,
                                                            40)), // width: 80, height: 40
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Back",
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white,
                                                            fontFamily:
                                                            baseFont,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            shadows: [
                                                              Shadow(
                                                                color: Colors
                                                                    .white,
                                                                blurRadius:
                                                                0.2,
                                                              )
                                                            ]),
                                                      )),
                                                  /* ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                          MaterialStateProperty
                                                              .all(darkBg),
                                                          minimumSize:
                                                          MaterialStateProperty
                                                              .all(Size(100,
                                                              40)), // width: 80, height: 40
                                                        ),
                                                        onPressed: () async {
                                                          entry.value["active"] == 'Y'
                                                              ? await setFirmwareStatus(context, id: entry.value["id"].toString(), status: "N")
                                                              : await setFirmwareStatus(context, id: entry.value["id"].toString(), status: "Y");
                                                          firmList = await getFirmwareList(context, active: "A");
                                                          setState(() {});
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: entry.value["active"] == 'Y'
                                                            ? Text(
                                                          "Deactive",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontFamily:
                                                              baseFont,
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              shadows: [
                                                                Shadow(
                                                                  color: Colors
                                                                      .white,
                                                                  blurRadius:
                                                                  0.2,
                                                                )
                                                              ]),
                                                        )
                                                            : Text(
                                                          "Active",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontFamily:
                                                              baseFont,
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              shadows: [
                                                                Shadow(
                                                                  color: Colors
                                                                      .white,
                                                                  blurRadius:
                                                                  0.2,
                                                                )
                                                              ]),
                                                        )
                                                    ), */
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.all(1.5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: darkBg),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.person,
                                          color: darkBg,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "${entry.value["name"]}",
                                            style: TextStyle(
                                                color: darkBg,
                                                fontSize: 20,
                                                fontFamily: baseFont,
                                                fontWeight: FontWeight.w500,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 0.2)
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      CupertinoIcons.chevron_right_2,
                                      color: darkBg,
                                      weight: 40,
                                      size: 28,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }).toList(),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Add Client
                          clearClient();
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            // important for keyboard handling
                            backgroundColor: lightBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10.0)),
                            ),
                            builder: (context) {
                              return StatefulBuilder(
                                builder:
                                    (thisLowerContext, checkClientState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(thisLowerContext)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: Container(
                                      height: screenSize.height / 1.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          width: screenSize.width,
                                          color: lightBg,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 16),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize
                                                .min, // wrap content
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text(
                                                  "Enter Client Details!",
                                                  style: TextStyle(
                                                    fontFamily: baseFont,
                                                    fontWeight:
                                                    FontWeight.w800,
                                                    fontSize: 28,
                                                    color: darkBg,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black,
                                                        blurRadius: 0.5,
                                                        offset:
                                                        Offset(0.5, 0.5),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              LabelText(
                                                  text: "Client Name :"),
                                              TextFeildNewUser(
                                                hintText: "Enter Client Name",
                                                Controller: _clientName,
                                                onChanged: (value) {},
                                                enable: true,
                                                etext: clientValidator &&
                                                    _clientName.text
                                                        .trim()
                                                        .isEmpty
                                                    ? "Please Enter Client Name"
                                                    : "",
                                              ),
                                              const SizedBox(height: 8),
                                              LabelText(
                                                  text: "Client Address"),
                                              TextFeildNewUser(
                                                hintText:
                                                "Enter Client Address",
                                                Controller: _clientAddress,
                                                onChanged: (value) {},
                                                enable: true,
                                                etext: clientValidator &&
                                                    _clientAddress.text
                                                        .trim()
                                                        .isEmpty
                                                    ? "Please Enter Client Address"
                                                    : "",
                                              ),
                                              const SizedBox(height: 8),
                                              LabelText(
                                                  text:
                                                  "Client Phone-Number"),
                                              TextFeildNewUser(
                                                hintText:
                                                "Enter Client Phone-Number",
                                                Controller: _clientPhno,
                                                onChanged: (value) {},
                                                maxLength: 10,
                                                enable: true,
                                                etext: clientValidator &&
                                                    _clientPhno.text
                                                        .trim()
                                                        .isEmpty
                                                    ? "Please Enter Client Phone-Number"
                                                    : "",
                                              ),
                                              const SizedBox(height: 8),
                                              LabelText(
                                                  text: "Client E-mail"),
                                              TextFeildNewUser(
                                                hintText:
                                                "Enter Client E-mail",
                                                Controller: _clientEmail,
                                                onChanged: (value) {},
                                                enable: true,
                                                etext: clientValidator &&
                                                    _clientEmail.text
                                                        .trim()
                                                        .isEmpty
                                                    ? "Please Enter Client E-mail"
                                                    : "",
                                              ),
                                              const SizedBox(height: 8),
                                              LabelText(
                                                  text:
                                                  "Client's Contact Person"),
                                              TextFeildNewUser(
                                                hintText:
                                                "Enter Client's Contact Person",
                                                Controller:
                                                _clientContactPerson,
                                                onChanged: (value) {},
                                                maxLength: 10,
                                                enable: true,
                                                etext: clientValidator &&
                                                    _clientContactPerson
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? "Please Enter Client's Contact Person"
                                                    : "",
                                              ),
                                              const SizedBox(height: 8),
                                              LabelText(text: "Description"),
                                              TextFeildNewUser(
                                                hintText: "Enter Description",
                                                Controller:
                                                _clientDiscription,
                                                onChanged: (value) {},
                                                enable: true,
                                                etext: clientValidator &&
                                                    _clientDiscription
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? "Please Enter Description"
                                                    : "",
                                              ),
                                              const SizedBox(height: 8),
                                              LabelText(
                                                  text: "Client's code"),
                                              TextFeildNewUser(
                                                hintText:
                                                "Enter Client's code",
                                                Controller: _clientCode,
                                                onChanged: (value) {},
                                                enable: true,
                                                etext: clientValidator &&
                                                    _clientCode.text
                                                        .trim()
                                                        .isEmpty
                                                    ? "Please Enter Client's code"
                                                    : "",
                                              ),
                                              const SizedBox(height: 20),
                                              Center(
                                                child: manageUserBtn(
                                                  text: "Add Client",
                                                  onPress: () async {
                                                    checkClientState(() {
                                                      ValidateClientFields();
                                                    });
                                                    if (!clientValidator) {
                                                      if (await saveClient(
                                                        context,
                                                        name: _clientName.text
                                                            .trim(),
                                                        address:
                                                        _clientAddress
                                                            .text
                                                            .trim(),
                                                        contactNumber:
                                                        _clientPhno.text
                                                            .trim(),
                                                        email: _clientEmail
                                                            .text
                                                            .trim(),
                                                        contactPerson:
                                                        _clientContactPerson
                                                            .text
                                                            .trim(),
                                                        discription:
                                                        _clientDiscription
                                                            .text
                                                            .trim(),
                                                        code: _clientCode.text
                                                            .trim(),
                                                      )) {
                                                        clearClient();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: darkBg),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                              padding: EdgeInsets.only(right: 5, left: 15),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add_rounded,
                                        color: darkBg,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "ADD CLIENT",
                                        style: TextStyle(
                                            color: darkBg,
                                            fontFamily: baseFont,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black26,
                                                  blurRadius: 0.4)
                                            ]),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
        ),
    );
  }

  void clientListIntoMap() {
    AllClient = {
      for (var client in clientList) client['name'].toString(): client
    };
    setState(() {
      printFunc("AllClient demo :$AllClient");
    });
  }

  void ValidateBatteryFields() {
    final Controllers = [
      _newbname,
      _batteryDescription,
    ];

    bool hasEmpty =
        Controllers.any((controller) => controller.text.trim().isEmpty);
    printFunc("has Next : $hasEmpty");
    setState(() {
      batteryValidator = hasEmpty;
    });
    // Future Delayed
    printFunc("DEMOMMOMO : ${batteryValidator}");
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        batteryValidator = false;
      });
    });
  }

  void clearConfig() {
    _batteryDescription.clear();
    _newbname.clear();
  }

  void ValidateClientFields() {
    final Controllers = [
      _clientName,
      _clientAddress,
      _clientPhno,
      _clientEmail,
      _clientContactPerson,
      _clientDiscription,
      _clientCode
    ];

    bool hasEmpty =
        Controllers.any((controller) => controller.text.trim().isEmpty);
    printFunc("has Next : $hasEmpty");
    setState(() {
      clientValidator = hasEmpty;
    });
    // Future Delayed
    printFunc("DEMOMMOMO clientValidator: ${clientValidator}");
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        clientValidator = false;
      });
    });
  }

  void clearClient() {
    _clientName.clear();
    _clientAddress.clear();
    _clientPhno.clear();
    _clientEmail.clear();
    _clientContactPerson.clear();
    _clientDiscription.clear();
    _clientCode.clear();
    setState(() {});
  }
}
