import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/services/apiCall/firmware.dart';
import 'package:tracker_firmware/services/apiCall/profile.dart';


TextStyle tileTextStyle  =TextStyle(
    color: darkBg,
    fontFamily: baseFont,
    fontSize: 18,
    fontWeight:FontWeight.w800,
    shadows: [
      Shadow(
        color: Colors.black,
        blurRadius: 0.2,
      )
    ]
);

TextStyle titleTileStyle = TextStyle(
    color: darkBg,
    fontFamily: baseFont,
    fontSize: 16,
    fontWeight:FontWeight.w500,
    shadows: [
      Shadow(
        color: Colors.black,
        blurRadius: 0.2,
      )
    ]
);


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
      batchList = await getBatchList(context);
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
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: darkBg
                                  )
                              ),
                              tilePadding: EdgeInsets.symmetric(horizontal: 20),
                              childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: darkBg
                                  )
                              ),
                              title:Row(
                                children: [
                                  Icon(Icons.folder_open_outlined,color: darkBg,size: 22,),
                                  SizedBox(width: 10,),
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
                                Divider(color: darkBg,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("ID :", style:titleTileStyle),
                                              Text("${entry.value["id"]}", style:tileTextStyle),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("Name :", style: titleTileStyle,),
                                              Text("${entry.value["version"]}", style: tileTextStyle,),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("Active : ", style:titleTileStyle,),
                                              Text("${entry.value["active"]}", style: tileTextStyle,),
                                            ],
                                          )

                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox( height: 5,),
                                          Divider(color: darkBg,),
                                          SizedBox(height: 5,),
                                        ],
                                      ),
                                      // Relase NOTE
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Relase Note : ",
                                            style: TextStyle(
                                                color: darkBg,
                                                fontFamily: baseFont,
                                                fontSize: 16,
                                                fontWeight:FontWeight.w500,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 0.2,
                                                  )
                                                ]
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                              child: Text("${entry.value["releaseNote"]}",
                                                style: TextStyle(
                                                    color: darkBg,
                                                    fontFamily: baseFont,
                                                    fontSize: 16,
                                                    fontWeight:FontWeight.w500,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black,
                                                        blurRadius: 0.2,
                                                      )
                                                    ]
                                                ),
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
                            SizedBox(height: 10,)
                          ],
                        );
                      }).toList(),
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
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: darkBg
                                )
                            ),
                            shape : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: darkBg
                                )
                            ),
                            tilePadding: EdgeInsets.symmetric(horizontal: 20),
                            childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                            title: Row(
                              children: [
                                Icon(Icons.battery_charging_full_rounded,color: darkBg,size: 18,),
                                SizedBox(width: 5,),
                                Text(
                                  "${entry.value["name"]}",
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
                              Divider(color: darkBg,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text("ID : ", style: titleTileStyle,),
                                            Text("${entry.value["id"]}",style: tileTextStyle,),
                                          ],

                                        ),
                                        Column(
                                          children: [
                                            Text("Name : ", style: titleTileStyle,),
                                            Text("${entry.value["name"]}",style: tileTextStyle,),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Priority :", style: titleTileStyle,),
                                            Text("${entry.value["priority"]}",style: tileTextStyle,),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,)
                        ],
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
                    side: BorderSide(color: darkBg, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 20),
                  childrenPadding: EdgeInsets.symmetric(horizontal: 5, ),
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
                      final profiles = profileListMap[e.key] ?? [];

                      return Column(
                        children: [
                          ExpansionTile(
                            backgroundColor: second_lightBg,
                            collapsedBackgroundColor: Colors.transparent,
                            iconColor: darkBg,
                            textColor: Colors.black,
                            collapsedIconColor: darkBg,
                              collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: darkBg
                                )
                              ),
                              shape : RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: darkBg
                                  )
                              ),
                              title: Row(
                                children: [
                                  Icon(Icons.battery_charging_full_rounded,color: darkBg,size: 18,),
                                  SizedBox(width: 5,),
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
                                  Divider(color: darkBg,thickness: 2,),
                                  ...profiles.map((profile) {
                                    return Column(
                                      children: [
                                       Padding(
                                           padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                           child:  ExpansionTile(
                                             backgroundColor: second_lightBg,
                                             collapsedBackgroundColor: Colors.transparent,
                                             iconColor: darkBg,
                                             textColor: Colors.black,
                                             collapsedIconColor: darkBg,
                                             collapsedShape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(10),
                                                 side: BorderSide(
                                                     color: darkBg
                                                 )
                                             ),
                                             shape : RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(10),
                                                 side: BorderSide(
                                                     color: darkBg
                                                 )
                                             ),
                                             title: Row(
                                               children: [
                                                 Icon(Icons.memory,color: darkBg,size: 18,weight:50 ),
                                                 SizedBox(width: 5,),
                                                 Text(
                                                   profile['name'],
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
                                               Divider(color: darkBg,),
                                               SizedBox(height: 15,),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                 children: [
                                                   Column(
                                                     children: [
                                                       Text("Id : ", style: titleTileStyle,),
                                                       SizedBox(height: 2,),
                                                       Text("${profile['id']}",style: tileTextStyle,)
                                                     ],
                                                   ),
                                                   Column(
                                                     children: [
                                                       Text("Name : ", style: titleTileStyle,),
                                                       SizedBox(height: 2,),
                                                       Text("${profile['name']}",style: tileTextStyle,),
                                                     ],
                                                   ),
                                                   Column(
                                                     children: [
                                                       Text("Release Date : ", style: titleTileStyle,),
                                                       SizedBox(height: 2,),
                                                       Text("${profile['releaseNote']}",style: tileTextStyle,)
                                                     ],
                                                   ),
                                                 ],
                                               ),
                                               SizedBox(height: 15,)
                                             ],
                                           ),
                                       ),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  }).toList(),

                                ],
                              )
                            ],

                          ),
                          SizedBox(height: 10,)

                        ],
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
                      final batchname = batch['name'] ?? '';

                      // Profile
                      final profileId = batch['profile']?['id'] ?? 'N/A';
                      final profileName = batch['profile']?['name'] ?? 'N/A';
                      final profileRealseNote = batch['profile']?['releaseNote'] ?? 'N/A';



                      // Firmware
                      final firmwareId = batch['firmware']?['id'] ?? 'N/A';
                      final firmwareVersion = batch['firmware']?['version'] ?? 'N/A';
                      final firmwareRelaseNote = batch['firmware']?['releaseNote'] ?? 'N/A';

                      return Column(
                        children: [
                          ExpansionTile(
                            backgroundColor: second_lightBg,
                            collapsedBackgroundColor: Colors.transparent,
                            iconColor: darkBg,
                            textColor: Colors.black,
                            collapsedIconColor: darkBg,
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: darkBg
                                )
                            ),
                            shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: darkBg
                                )
                            ),
                            title:Row(
                              children: [
                                Icon(Icons.computer,color: darkBg,size: 20,),
                                SizedBox(width: 10,),
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
                                Divider(color: darkBg,thickness: 2,),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.computer,color: darkBg,size: 20,),
                                                      SizedBox(width: 10,),
                                                      Text("Batch Details ",
                                                        style: TextStyle(
                                                            color: darkBg,
                                                            fontFamily: baseFont,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700,
                                                            shadows: [
                                                              Shadow(
                                                                  color: Colors.black,
                                                                  blurRadius: 0.2
                                                              )
                                                            ]
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(color: darkBg,thickness: 0.8,),
                                                  SizedBox(height: 2,)

                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("  Id : ", style: titleTileStyle,),
                                                      SizedBox(height: 2,),
                                                      Text("${batchId}",style: tileTextStyle,)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Name : ", style: titleTileStyle,),
                                                      SizedBox(height: 2,),
                                                      Text("${batchname}",style: tileTextStyle,)
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
                                                      Icon(Icons.memory,color: darkBg,size: 18,weight:50 ),
                                                      SizedBox(width: 10,),
                                                      Text("Config Details ",
                                                        style: TextStyle(
                                                            color: darkBg,
                                                            fontFamily: baseFont,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700,
                                                            shadows: [
                                                              Shadow(
                                                                  color: Colors.black,
                                                                  blurRadius: 0.2
                                                              )
                                                            ]
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(color: darkBg,thickness: 0.8,),
                                                  SizedBox(height: 2,)
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text("  Id : ", style:titleTileStyle,),
                                                      SizedBox(height: 2,),
                                                      Text("${profileId}",style: tileTextStyle,)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Name : ", style: titleTileStyle,),
                                                      SizedBox(height: 2,),
                                                      Text("${profileName}",style: tileTextStyle,)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Relase Date : ", style: titleTileStyle,),
                                                      SizedBox(height: 2,),
                                                      Text("${profileRealseNote}",style: tileTextStyle,)
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
                                                      Icon(Icons.folder_open_outlined,color: darkBg,size: 22,),
                                                      SizedBox(width: 10,),
                                                      Text("Firmware Details",
                                                        style: TextStyle(
                                                            color: darkBg,
                                                            fontFamily: baseFont,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700,
                                                            shadows: [
                                                              Shadow(
                                                                  color: Colors.black,
                                                                  blurRadius: 0.2
                                                              )
                                                            ]
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(color: darkBg,thickness: 0.8,),
                                                  SizedBox(height: 2,)
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(" Id : ", style: titleTileStyle),
                                                      SizedBox(height: 2,),
                                                      Text("${firmwareId}",style: tileTextStyle,)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Version : ", style:titleTileStyle,),
                                                      SizedBox(height: 2,),
                                                      Text("${firmwareVersion}",style: tileTextStyle,)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Relase Date : ", style: titleTileStyle,),
                                                      SizedBox(height: 2,),
                                                      Text("${firmwareRelaseNote}",style: tileTextStyle,)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                            ],
                          ),
                          SizedBox(height: 10,)

                        ],
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
              ],
            ),
          ),
        ));
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