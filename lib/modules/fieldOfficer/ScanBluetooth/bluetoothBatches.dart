import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';

import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/batchModel.dart';

// import 'package:tracker_firmware/Const_TermAndFunction/entity/batchModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/bluetoothMain.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/services/batch/methods.dart';

class BlueetoothBatches extends StatefulWidget {
  const BlueetoothBatches({super.key});

  @override
  State<BlueetoothBatches> createState() => BlueetoothBatchesState();
}

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

class BlueetoothBatchesState extends State<BlueetoothBatches> {
  int selectedbutton = 1;
  List<BatchModel> batchList = [];
  var getAllseriesData;
  var batchBox;

  final DataController BatchSelected = DataController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      batchBox = await Hive.openBox<BatchModel>('$batchHiveBox');
      // await batchBox.clear();
      // batchList = await getBatchList(context);
      printFunc("Batch list/ :-> $batchList");
      getAllseriesData = await getSeriesData();
      // addBatch(BatchModel.fromJson(batchList[0]));

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
            "Batch's",
            style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
          ),
          toolbarHeight: size.height / 11.5,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: lightBg,
        body: Container(
            child: SingleChildScrollView(
          child: Column(children: seriesSix()),
        )));
  }

  List<Widget> seriesSix() {
    printFunc("Serice six Data : $getAllseriesData");
    List<Widget> seriesWidgetList = [];

    for (int index = 0; index < ((getAllseriesData != null) ? getAllseriesData.length : 0); index++) {
      printFunc("DEMO DEMO Firmware logs : ${getAllseriesData[index]["saved"]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(getAllseriesData[index]['saved'] ?? false);
      seriesWidgetList.add(ValueListenableBuilder(
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
                    '${getAllseriesData[index]['id'].toString()}_${getAllseriesData[index]['saved'].toString()}'),

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
                          Text("Batch : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(getAllseriesData[index]["name"].toString(),
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 19,
                                  FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText)),
                        ],
                      ),
                      // EmpID
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description : ",
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            getAllseriesData[index]["description"].toString(),
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
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
                            getAllseriesData[index]["profile"]['deviceType'].toString(),
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
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
                              // Firm version
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Firmware Version",
                                    style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    getAllseriesData[index]["firmware"]['version'].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // firmware name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Firmware Name",
                                    style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    getAllseriesData[index]["firmware"]['versionName'].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
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
                                  Text(
                                    "Flash",
                                    style: CardText(font_Weight: FontWeight.w300, FontColor: SuccessCardText),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        printFunc("Which Data is : ${getAllseriesData[index]}");
                                        BatchSelected.cleardata();
                                        var batchObj = getAllseriesData[index];
                                        setState(() {});

                                        BatchSelected.setobj = getAllseriesData[index];

                                        FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

                                        Navigator.of(context).push(MaterialPageRoute<void>(
                                            builder: (_) => FlutterBlueApp(
                                                  SelectedBatch: BatchSelected,
                                                )));
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.flash_on_outlined, color: darkBg, size: 34)),
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
                        Container(
                          width: size.width * 0.8,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Text("Config : ",
                                      style:
                                          CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                                  Text(getAllseriesData[index]["profile"]["name"],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText)),
                                ],
                              ),
                              SizedBox(width: 10), // spacing before line
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.black26,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: FittedBox(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
// Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                        Row(
                                          children: [
                                            Icon(Icons.battery_charging_full_outlined,
                                                size: 18, color: secondaryText),
                                            SizedBox(width: 5),
                                            Text(
                                              "${getAllseriesData[index]["profile"]['uT']} V",
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
                                            Icon(Icons.battery_6_bar_outlined,
                                                size: 18, color: secondaryText),
                                            SizedBox(width: 5),
                                            Text(
                                              "${getAllseriesData[index]["profile"]['uV']} V",
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
                                            Icon(Icons.battery_alert_outlined,
                                                size: 18, color: secondaryText),
                                            SizedBox(width: 5),
                                            Text(
                                              "${getAllseriesData[index]["profile"]['lT']} V",
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
                                              "${getAllseriesData[index]["profile"]['lV']} V",
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
    return seriesWidgetList;
  }

  Future<List<Map<String, dynamic>>> getSeriesData() async {
    List<Map<String, dynamic>> totalBatchList = [];
    final allBatches = batchBox.values.toList(); // List<BatchModel>
    final allBatchMap = batchBox.toMap(); // Map<dynamic, BatchModel>
    printFunc("allBatches : ${allBatches}");
    printFunc("allBatchMap : ${allBatchMap}");
    for (var entry in allBatchMap.entries) {
      final key = entry.key;
      final batch = entry.value;

      printFunc("Key: $key");
      printFunc("Batch Name: ${batch.batchName}");
      printFunc("Batch saved: ${batch.saved}");
      printFunc("Firmware Version: ${batch.firmware.version}");
      printFunc("Profile Name: ${batch.profile.name}");
    }
    final allBatchesWithKeys = batchBox.keys.map((key) {
      final batch = batchBox.get(key);
      return {'key': key, 'value': batch};
    }).toList();
    // final batchFromHive = batchBox.get("$id");

    allBatchMap.forEach((key, batch) {
      totalBatchList.add({
        'id': batch.batchId,
        'name': batch.batchName,
        'description': batch.batchDescription,
        'firmware': batch.firmware.toJson(),
        'profile': batch.profile.toJson(),
        'saved': true,
      });
    });

    return totalBatchList;
  }
}
