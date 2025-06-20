import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/FirmwareSettings/addFirmware.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/services/apiCall/deviceType.dart';
import 'package:tracker_firmware/services/apiCall/firmware.dart';
import 'package:tracker_firmware/services/apiCall/profile.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

TextStyle tileTextStyle =
    TextStyle(color: darkBg, fontFamily: baseFont, fontSize: 18, fontWeight: FontWeight.w800, shadows: [
  Shadow(
    color: Colors.black,
    blurRadius: 0.2,
  )
]);

TextStyle titleTileStyle =
    TextStyle(color: darkBg, fontFamily: baseFont, fontSize: 16, fontWeight: FontWeight.w500, shadows: [
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

  Map<String, List<Map<String, dynamic>>> profileListMap = {};

  bool _showInfo = false;
  List<Map<String, dynamic>> batchList = [{}];

  // Controleers for New Battery
  TextEditingController _newbname = TextEditingController();
  TextEditingController _batteryDescription = TextEditingController();
  bool batteryValidator = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      firmList = await getFirmwareList(context);
      final allConfigList = await getAllConfigurationList(context);
      batteryList = {for (var item in allConfigList) item['deviceName']: item};
      batchList = await getBatchList(context);
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "List Overview",
            style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
          ),
          toolbarHeight: size.height / 13,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: lightBg,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of firmware
                Container(
                  width: size.width,
                  child: ExpansionTile(
                    backgroundColor: second_lightBg,
                    collapsedBackgroundColor: Colors.transparent,
                    iconColor: darkBg,
                    textColor: Colors.black,
                    collapsedIconColor: darkBg,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: darkBg, width: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent, width: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tilePadding: EdgeInsets.symmetric(horizontal: 20),
                    childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                    expandedAlignment: Alignment.center,
                    title: Text(
                      "Firmware",
                      style: TextStyle(
                        color: darkBg,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                      ),
                    ),
                    children: [
                      ...firmList.entries.map((entry) {
                        return Column(
                          children: [
                            ExpansionTile(
                              backgroundColor: second_lightBg,
                              collapsedBackgroundColor: Colors.transparent,
                              iconColor: darkBg,
                              textColor: Colors.black,
                              collapsedIconColor: darkBg,
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), side: BorderSide(color: darkBg)),
                              tilePadding: EdgeInsets.symmetric(horizontal: 20),
                              childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), side: BorderSide(color: darkBg)),
                              title: Row(
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
                                        shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                                  ),
                                ],
                              ),
                              children: [
                                Divider(
                                  color: darkBg,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("ID :", style: titleTileStyle),
                                              Text("${entry.value["id"]}", style: tileTextStyle),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Name :",
                                                style: titleTileStyle,
                                              ),
                                              Text(
                                                "${entry.value["version"]}",
                                                style: tileTextStyle,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Active : ",
                                                style: titleTileStyle,
                                              ),
                                              Text(
                                                "${entry.value["active"]}",
                                                style: tileTextStyle,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
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
                                      // Relase NOTE
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Relase Note : ",
                                            style: TextStyle(
                                                color: darkBg,
                                                fontFamily: baseFont,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 0.2,
                                                  )
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            child: Text(
                                              "${entry.value["releaseNote"]}",
                                              style: TextStyle(
                                                  color: darkBg,
                                                  fontFamily: baseFont,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 0.2,
                                                    )
                                                  ]),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }).toList(),
                      SizedBox(height: 5,),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AddNewFirmware(selectedBtn: 1,)));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: darkBg),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                              padding: EdgeInsets.only( right: 5, left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.add_rounded,color: darkBg,),
                                      SizedBox(width: 10,),
                                      Text("ADD FIRMWARE",
                                        style:TextStyle(
                                            color: darkBg,
                                            fontFamily: baseFont,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                                      ),
                                    ],
                                  ),

                                ],
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
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

                // List of Batteries
                ExpansionTile(
                  backgroundColor: second_lightBg,
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: darkBg,
                  textColor: Colors.black,
                  collapsedIconColor: darkBg,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: darkBg, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 20),
                  childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                  title: Text(
                    "Batteries",
                    style: TextStyle(
                      color: darkBg,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                    ),
                  ),
                  children: [
                    ...batteryList.entries.map((entry) {
                      return Column(
                        children: [
                          ExpansionTile(
                            backgroundColor: second_lightBg,
                            collapsedBackgroundColor: Colors.transparent,
                            iconColor: darkBg,
                            textColor: Colors.black,
                            collapsedIconColor: darkBg,
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), side: BorderSide(color: darkBg)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), side: BorderSide(color: darkBg)),
                            tilePadding: EdgeInsets.symmetric(horizontal: 20),
                            childrenPadding: EdgeInsets.symmetric(horizontal: 5),
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
                                  "${entry.value["deviceName"]}",
                                  style: TextStyle(
                                      color: darkBg,
                                      fontSize: 20,
                                      fontFamily: baseFont,
                                      fontWeight: FontWeight.w500,
                                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                                )
                              ],
                            ),
                            children: [
                              Divider(
                                color: darkBg,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "ID : ",
                                              style: titleTileStyle,
                                            ),
                                            Text(
                                              "${entry.value["id"]}",
                                              style: tileTextStyle,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              child: Text(
                                                "Name : ",
                                                style: titleTileStyle,
                                              ),
                                              onTap: () {
                                                printFunc("Selectged value of Batery: ${entry.value}");
                                              },
                                            ),
                                            Text(
                                              "${entry.value["deviceName"]}",
                                              style: tileTextStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 5,),
                                          Divider(
                                            color: darkBg,
                                          ),
                                          SizedBox(height: 5,),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Discription :",
                                          style: titleTileStyle,
                                        ),
                                        Text(
                                          "${entry.value["discription"]}",
                                          style: tileTextStyle,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    }).toList(),
                    SizedBox(height: 5,),
                    GestureDetector(
                      onTap: () async {
                        await BottomSheet_Widget(context, color: lightBg, [
                          Container(
                            height: size.height / 1.5,
                            width: size.width,
                            color: lightBg,
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                offset: Offset(0.5, 0.5))
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Battery Name
                                          LabelText(text: "Battery Name :"),
                                          TextFeildNewUser(
                                            hintText: "Enter Battery Name",
                                            Controller: _newbname,
                                            onChanged: (value) {},
                                            enable: true,
                                            etext: batteryValidator && _newbname.text.trim().isEmpty
                                                ? "Please Enter Battery Name"
                                                : "",
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          // Relase Note
                                          LabelText(text: "Description"),
                                          TextFeildNewUser(
                                            hintText: "Enter Information",
                                            Controller: _batteryDescription,
                                            onChanged: (value) {},
                                            enable: true,
                                            etext: batteryValidator &&
                                                _batteryDescription.text.trim().isEmpty
                                                ? "Please Enter Information"
                                                : "",
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
                                          printFunc(_newbname.text.trim().isEmpty);
                                          ValidateBatteryFields();

                                          if (!batteryValidator) {
                                            printFunc("Inside IF COND");
                                            if (await addNewDeviceType(
                                              context,
                                              name: _newbname.text.trim(),
                                              description: _batteryDescription.text.trim(),
                                            )) {
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
                          )
                        ]);
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: darkBg),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                            padding: EdgeInsets.only( right: 5, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.add_rounded,color: darkBg,),
                                    SizedBox(width: 10,),
                                    Text("ADD BATTERY",
                                      style:TextStyle(
                                          color: darkBg,
                                          fontFamily: baseFont,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                                    ),
                                  ],
                                ),

                              ],
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
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
                    side: BorderSide(color: darkBg, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 20),
                  childrenPadding: EdgeInsets.symmetric(
                    horizontal: 5,
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
                    ...batteryList.entries.map((e) {
                      printFunc("...batteryList.entries.map((e) { ->\n$e");
                      final profiles = e.value["configuration"] ?? [];

                      return Column(
                        children: [
                          ExpansionTile(
                            backgroundColor: second_lightBg,
                            collapsedBackgroundColor: Colors.transparent,
                            iconColor: darkBg,
                            textColor: Colors.black,
                            collapsedIconColor: darkBg,
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), side: BorderSide(color: darkBg)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), side: BorderSide(color: darkBg)),
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
                                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
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
                                  ...profiles.map((profile) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: ExpansionTile(
                                            backgroundColor: second_lightBg,
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
                                                Icon(Icons.memory, color: darkBg, size: 18, weight: 50),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  profile['name'],
                                                  style: TextStyle(
                                                      color: darkBg,
                                                      fontFamily: baseFont,
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.w500,
                                                      shadows: [
                                                        Shadow(color: Colors.black, blurRadius: 0.2)
                                                      ]),
                                                ),
                                              ],
                                            ),
                                            children: [
                                              Divider(
                                                color: darkBg,
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Id : ",
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
                                                    children: [
                                                      Text(
                                                        "Status : ",
                                                        style: titleTileStyle,
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                        "${profile['active'] == "Y" ? "Active" : "Suspended"}",
                                                        style: tileTextStyle,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Divider(
                                                color: Colors.black26,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Description : ",
                                                    style: titleTileStyle,
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    "${profile['discription']}",
                                                    style: TextStyle(
                                                        color: darkBg,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: baseFont,
                                                        fontSize: 14,
                                                        shadows: [Shadow(color: Colors.black)]),
                                                  )
                                                ],
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                              ),
                                              Divider(
                                                color: Colors.black26,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 3.0, right: 3),
                                                child: FittedBox(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                                              Text(
                                                                "U. Threshold",
                                                                style: CardText(
                                                                  font_Weight: FontWeight.w800,
                                                                  size: 16,
                                                                  FontColor: SuccessCardText,
                                                                ),
                                                              ),

                                                              // Upper Threshold
                                                              SizedBox(height: 5),
                                                              Row(
                                                                children: [
                                                                  Icon(Icons.battery_charging_full_outlined,
                                                                      size: 18, color: secondaryText),
                                                                  SizedBox(width: 5),
                                                                  Text(
                                                                    "${profile['upperThreshold']} V",
                                                                    style: CardText(
                                                                      font_Weight: FontWeight.w800,
                                                                      size: 18,
                                                                      FontColor: SuccessCardText,
                                                                    ),
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
                                                                style: CardText(
                                                                  font_Weight: FontWeight.w800,
                                                                  size: 16,
                                                                  FontColor: SuccessCardText,
                                                                ),
                                                              ),
                                                              // Upper Voltage
                                                              SizedBox(height: 5),
                                                              Row(
                                                                children: [
                                                                  Icon(Icons.battery_6_bar_outlined,
                                                                      size: 18, color: secondaryText),
                                                                  SizedBox(width: 5),
                                                                  Text(
                                                                    "${profile['upperVoltage']} V",
                                                                    style: CardText(
                                                                      font_Weight: FontWeight.w800,
                                                                      size: 18,
                                                                      FontColor: SuccessCardText,
                                                                    ),
                                                                  ),
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
                                                                style: CardText(
                                                                  font_Weight: FontWeight.w800,
                                                                  size: 16,
                                                                  FontColor: SuccessCardText,
                                                                ),
                                                              ),
                                                              // Lower Threshold
                                                              SizedBox(height: 5),
                                                              Row(
                                                                children: [
                                                                  Icon(Icons.battery_alert_outlined,
                                                                      size: 18, color: secondaryText),
                                                                  SizedBox(width: 5),
                                                                  Text(
                                                                    "${profile['lowerThreshold']} V",
                                                                    style: CardText(
                                                                      font_Weight: FontWeight.w800,
                                                                      size: 18,
                                                                      FontColor: SuccessCardText,
                                                                    ),
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
                                                                style: CardText(
                                                                  font_Weight: FontWeight.w800,
                                                                  size: 16,
                                                                  FontColor: SuccessCardText,
                                                                ),
                                                              ),
                                                              SizedBox(height: 5),
                                                              Row(
                                                                children: [
                                                                  Icon(Icons.battery_1_bar_rounded,
                                                                      size: 18, color: secondaryText),
                                                                  SizedBox(width: 5),
                                                                  Text(
                                                                    "${profile['lowerVoltage']} V",
                                                                    style: CardText(
                                                                      font_Weight: FontWeight.w800,
                                                                      size: 18,
                                                                      FontColor: SuccessCardText,
                                                                    ),
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
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    );
                                  }).toList(),
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
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AddNewFirmware(selectedBtn: 2,)));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: darkBg),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                            padding: EdgeInsets.only( right: 5, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.add_rounded,color: darkBg,),
                                    SizedBox(width: 10,),
                                    Text("ADD CONFIG",
                                      style:TextStyle(
                                          color: darkBg,
                                          fontFamily: baseFont,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                                    ),
                                  ],
                                ),

                              ],
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),

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
                  backgroundColor: second_lightBg,
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: darkBg,
                  textColor: Colors.black,
                  collapsedIconColor: darkBg,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: darkBg, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 20),
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
                    ...batchList.map((batch) {
                      printFunc("DEMO BATCH : ${batch}");
                      // batch
                      final batchId = batch['id'] ?? '';
                      final batchname = batch['batchName'] ?? '';
                      final batchActive = batch['active'].toString().toUpperCase() == 'Y' ? "Active" : "Inactive";

                      // Profile
                      final configName = batch['configuration']?['name'] ?? 'N/A';
                      final configUpThershold = batch['configuration']?['upperThreshold'] ?? 'N/A';
                      final configLowThershold = batch['configuration']?['lowerThreshold'] ?? 'N/A';
                      final configUpVolt = batch['configuration']?['upperVoltage'] ?? 'N/A';
                      final configLowVolt = batch['configuration']?['lowerVoltage'] ?? 'N/A';

                      // Firmware
                      final firmwareId = batch['firmware']?['id'] ?? 'N/A';
                      final firmwareVersion = batch['firmware']?['versionName'] ?? 'N/A';
                      final firmwareRelaseNote = batch['firmware']?['versionReleasedDate'].split("T")[0] ?? 'N/A';

                      return Column(
                        children: [
                          ExpansionTile(
                            backgroundColor: Colors.white,
                            collapsedBackgroundColor: second_lightBg,
                            iconColor: darkBg,
                            textColor: Colors.black,
                            collapsedIconColor: darkBg,
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), side: BorderSide(color: darkBg)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), side: BorderSide(color: darkBg)),
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
                                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                                ),
                              ],
                            ),
                            children: [
                              Divider(
                                color: darkBg,
                                thickness: 2,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        fontWeight: FontWeight.w700,
                                                        shadows: [
                                                          Shadow(color: Colors.black, blurRadius: 0.2)
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
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        fontWeight: FontWeight.w700,
                                                        shadows: [
                                                          Shadow(color: Colors.black, blurRadius: 0.2)
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
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(" Id : ", style: titleTileStyle),
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
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.memory, color: darkBg, size: 18, weight: 50),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Config : ${configName} ",
                                                    style: TextStyle(
                                                        color: darkBg,
                                                        fontFamily: baseFont,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w700,
                                                        shadows: [
                                                          Shadow(color: Colors.black, blurRadius: 0.2)
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
                                            padding: const EdgeInsets.only(left: 3.0, right: 3),
                                            child: FittedBox(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                                          Text(
                                                            "U. Threshold",
                                                            style: titleTileStyle,
                                                          ),

                                                          // Upper Threshold
                                                          SizedBox(height: 5),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.battery_charging_full_outlined,
                                                                  size: 18, color: darkBg),
                                                              SizedBox(width: 5),
                                                              Text(
                                                                "${configUpThershold} V",
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
                                                              Icon(Icons.battery_6_bar_outlined,
                                                                  size: 18, color: darkBg),
                                                              SizedBox(width: 5),
                                                              Text(
                                                                "${configUpVolt} V",
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
                                                          // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                                          Text(
                                                            "L.Threshold",
                                                            style: titleTileStyle,
                                                          ),
                                                          // Lower Threshold
                                                          SizedBox(height: 5),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.battery_alert_outlined,
                                                                  size: 18, color: darkBg),
                                                              SizedBox(width: 5),
                                                              Text(
                                                                "${configLowThershold} V",
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
                                                              Icon(Icons.battery_1_bar_rounded,
                                                                  size: 18, color: darkBg),
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
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    }).toList(),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AddNewFirmware(selectedBtn: 3,)));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: darkBg),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                            padding: EdgeInsets.only( right: 5, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.add_rounded,color: darkBg,),
                                    SizedBox(width: 10,),
                                    Text("ADD BATCH",
                                      style:TextStyle(
                                          color: darkBg,
                                          fontFamily: baseFont,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black26,
                                                blurRadius: 0.4
                                            )
                                          ]
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),

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
        ));
  }
  void ValidateBatteryFields() {
    final Controllers = [
      _newbname,
      _batteryDescription,
    ];

    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);
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




}

// Battery LIst
/*Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Id",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Name",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Priority",
                              style: TextStyle(
                                color: darkBg,
                                fontFamily: baseFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "${entry.value["id"]}",
                                style: TextStyle(
                                    color: darkBg,
                                    fontSize: 18,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w500,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "${entry.value["name"]}",
                                style: TextStyle(
                                    color: darkBg,
                                    fontSize: 18,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w500,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "${entry.value["priority"]}",
                                style: TextStyle(
                                    color: darkBg,
                                    fontSize: 18,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w500,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),*/

// Config List
/*
*                     ...batteryList.entries.map((e) {
                      printFunc("DEMO config 1 : ${e}");
                      final profiles = profileListMap[e.key] ?? [];

                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Container(
                            decoration:
                                BoxDecoration(border: Border(bottom: BorderSide(color: darkBg, width: 0.5))),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: ExpansionTile(
                              backgroundColor: second_lightBg,
                              collapsedBackgroundColor: Colors.transparent,
                              iconColor: darkBg,
                              textColor: Colors.black,
                              collapsedIconColor: darkBg,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: darkBg, width: 0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              collapsedShape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.transparent, width: 0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              tilePadding: EdgeInsets.symmetric(horizontal: 20),
                              childrenPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              title: Text(
                                e.key,
                                style: TextStyle(
                                    color: darkBg,
                                    fontFamily: baseFont,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                              ),
                              children: [
                                Divider(color: darkBg),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          "Id",
                                          style: TextStyle(
                                              color: darkBg,
                                              fontFamily: baseFont,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          "Name",
                                          style: TextStyle(
                                              color: darkBg,
                                              fontFamily: baseFont,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
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
                                  printFunc("DEMO CONFIG 2 : ${profile}");
                                  return Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "${profile['id']}",
                                            style: TextStyle(
                                                color: darkBg,
                                                fontFamily: baseFont,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "${profile['name']}",
                                            style: TextStyle(
                                                color: darkBg,
                                                fontFamily: baseFont,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]),
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
*/

// Batches List
/*Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 28),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    color: darkBg,
                                    fontFamily: baseFont,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Config",
                                  style: TextStyle(
                                    color: darkBg,
                                    fontFamily: baseFont,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Firmware",
                                  style: TextStyle(
                                    color: darkBg,
                                    fontFamily: baseFont,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
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
                        ...batchList.map((batch) {
                          printFunc("DEMO BATCH LIST : ${batchList}");
                          final name = batch['name'] ?? '';
                          final firmwareVersion = batch['firmware']?['version'] ?? 'N/A';
                          final profileName = batch['profile']?['name'] ?? 'N/A';

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Container(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: darkBg,
                                      fontSize: 18,
                                      fontFamily: baseFont,
                                      fontWeight: FontWeight.w500,
                                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                                    ),
                                  ),
                                ),
                                // Firmware Version
                                Container(
                                  child: Text(
                                    firmwareVersion,
                                    style: TextStyle(
                                      color: darkBg,
                                      fontSize: 18,
                                      fontFamily: baseFont,
                                      fontWeight: FontWeight.w500,
                                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                                    ),
                                  ),
                                ),
                                // Profile Name
                                Container(
                                  child: Text(
                                    profileName,
                                    style: TextStyle(
                                      color: darkBg,
                                      fontSize: 18,
                                      fontFamily: baseFont,
                                      fontWeight: FontWeight.w500,
                                      shadows: [Shadow(color: Colors.black, blurRadius: 0.2)],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    )*/
