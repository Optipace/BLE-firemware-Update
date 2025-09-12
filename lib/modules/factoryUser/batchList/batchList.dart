import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/batchModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/services/batch/methods.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

class BatchFactoryManagement extends StatefulWidget {
  const BatchFactoryManagement({super.key});

  @override
  State<BatchFactoryManagement> createState() => BatchFactoryManagementState();
}

TextStyle CardText(
    {required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

class BatchFactoryManagementState extends State<BatchFactoryManagement> {
  int selectedbutton = 1;
  List<Map<String, dynamic>> batchList = [{}];
  var seriesSixData;
  var seriesNineData;
  var seriesTwelveData;
  var batchBox;
  List? result;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      batchBox = await Hive.openBox<BatchModel>('$batchHiveBox');
      // await batchBox.clear();
      sharedPreferences = await SharedPreferences.getInstance();
      UserData.instance.accessToken = "sdncondscpd";
      await sharedPreferences.setString("accessToken", "sdncondscpd");

      // Add request
      batchList = await getBatchList(context, Status: "Y");
      for (int i = 0; i < batchList.length; i++) {
        printFunc("DEMO BATCHES FROM API - ${batchList[i]['batteryDetails']}");
      }
      seriesSixData = await getSeriesData();
      printFunc("SERIES DATA : $seriesSixData");
      // addBatch(BatchModel.fromJson(batchList[0]));

      setState(() {});
    });
    printFunc("DEMO USERDATA : ${UserData.instance.status}");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    printFunc("Inside Logs Page");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Batch's",
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
        body: Container(
            child: SingleChildScrollView(
              child: Column(children: seriesSix()),
            )),);
  }

  List<Widget> seriesSix() {
    printFunc("Series six Data : $seriesSixData");
    List<Widget> seriesSixWidgetList = [];

    for (int index = 0;
        index < ((seriesSixData != null) ? seriesSixData.length : 0);
        index++) {
      printFunc("DEMO DEMO Firmware logs 23: ${seriesSixData[index]}");

      // Store the current item's ID for reference
      final currentItemId = seriesSixData[index]['id'];

      ValueNotifier moreInfo =
          ValueNotifier<bool>(seriesSixData[index]['saved'] ?? false);

      seriesSixWidgetList.add(ValueListenableBuilder(
          valueListenable: moreInfo,
          builder: (ctx, value, child) {
            // Find current item by ID instead of using index
            Map<String, dynamic>? currentItem;
            try {
              currentItem = seriesSixData.firstWhere(
                (item) => item['id'] == currentItemId,
              );
            } catch (e) {
              // If item not found, use a safe fallback
              if (index < seriesSixData.length) {
                currentItem = seriesSixData[index];
              } else {
                // Create a safe default item structure
                currentItem = {
                  'id': currentItemId,
                  'name': 'Loading...',
                  'description': 'Loading...',
                  'saved': false,
                  'firmware': {'version': 'N/A', 'versionName': 'N/A'},
                  'profile': {
                    'name': 'N/A',
                    'uT': '0',
                    'uV': '0',
                    'lT': '0',
                    'lV': '0',
                    'nV': '0',
                    'uTemp': '0',
                    'lTemp': '0'
                  },
                  'battery': {'batteryCode': 'N/A'}
                };
              }
            }

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
                key: ValueKey('${currentItem!['id']}_${currentItem['saved']}'),
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
                  child: FittedBox(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Batch : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText)),
                                ],
                              ),
                            ),
                            Container(
                              width: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Description : ",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: secondaryText),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Series : ",
                                    style: CardText(
                                        font_Weight: FontWeight.w300,
                                        FontColor: secondaryText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 90,
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentItem["name"].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentItem["description"].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    moreInfo.value
                                        ? currentItem["battery"]['batteryCode']
                                            .toString()
                                        : batchList.firstWhere(
                                                (b) => b['id'] == currentItemId,
                                                orElse: () => {
                                                      'batteryDetails': {
                                                        'Battery-Code': 'N/A'
                                                      }
                                                    })['batteryDetails']
                                            ['Battery-Code'],
                                    style: CardText(
                                        font_Weight: FontWeight.w800,
                                        size: 19,
                                        FontColor: !(moreInfo.value)
                                            ? SuccessCardText
                                            : FailureCardText),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        // Firmware section
                        Container(
                          width: screenSize.width * 0.8,
                          child: Row(
                            children: [
                              Text("Firmware Details  ",
                                  style: CardText(
                                      font_Weight: FontWeight.w500,
                                      FontColor: secondaryText)),
                              SizedBox(width: 5),
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
                        FittedBox(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Firmware Version",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Firmware Name",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (moreInfo.value)
                                              ? "Saved"
                                              : "Download",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: !(moreInfo.value)
                                                  ? SuccessCardText
                                                  : FailureCardText),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          currentItem["firmware"]['version']
                                              .toString(),
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 19,
                                              FontColor: !(moreInfo.value)
                                                  ? SuccessCardText
                                                  : FailureCardText),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          currentItem["firmware"]['versionName']
                                              .toString(),
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 19,
                                              FontColor: !(moreInfo.value)
                                                  ? SuccessCardText
                                                  : FailureCardText),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              if (!(currentItem!['saved'] ??
                                                  false)) {
                                                if (!(await addBatch(
                                                    BatchModel.fromJson(
                                                        currentItem))))
                                                  ShowSnackBarMessage(
                                                      context,
                                                      "Failed to save Batch",
                                                      false);
                                              }

                                              // Refresh the data and find the updated item
                                              seriesSixData =
                                                  await getSeriesData();

                                              // Find the updated item by ID
                                              try {
                                                final updatedItem =
                                                    seriesSixData.firstWhere(
                                                  (item) =>
                                                      item['id'] ==
                                                      currentItemId,
                                                );
                                                moreInfo.value =
                                                    updatedItem['saved'] ??
                                                        false;
                                              } catch (e) {
                                                // If item not found after update, set as saved
                                                moreInfo.value = true;
                                              }
                                              setState(() {});
                                            },
                                            icon: (!(currentItem['saved'] ??
                                                    false))
                                                ? Icon(
                                                    Icons
                                                        .download_for_offline_outlined,
                                                    color: SuccessCardText,
                                                    size: 35)
                                                : Icon(
                                                    Icons
                                                        .download_done_outlined,
                                                    color: darkBg,
                                                    size: 35)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Config/profile section
                        Container(
                          width: screenSize.width * 0.8,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Text("Config : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w500,
                                          FontColor: secondaryText)),
                                  Text(currentItem["profile"]["name"],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: SuccessCardText)),
                                ],
                              ),
                              SizedBox(width: 10),
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
                        // Profile details (keeping the rest of your profile UI code)
                        FittedBox(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 75,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "U. Threshold",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText,
                                              size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                                Icons
                                                    .battery_charging_full_outlined,
                                                size: 14,
                                                color: secondaryText),
                                            Text(
                                              "${currentItem["profile"]['uT']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w800,
                                                  size: 14,
                                                  FontColor: !(moreInfo.value)
                                                      ? SuccessCardText
                                                      : FailureCardText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ... rest of your profile containers with currentItem instead of seriesSixData[index]
                                  Container(
                                    width: 55,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "U.Volt",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText,
                                              size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            children: [
                                              Icon(Icons.battery_6_bar_outlined,
                                                  size: 14,
                                                  color: secondaryText),
                                              Text(
                                                "${currentItem["profile"]['uV']} V",
                                                style: CardText(
                                                    font_Weight:
                                                        FontWeight.w800,
                                                    size: 14,
                                                    FontColor: !(moreInfo.value)
                                                        ? SuccessCardText
                                                        : FailureCardText),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "L.Threshold",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText,
                                              size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.battery_alert_outlined,
                                                size: 13, color: secondaryText),
                                            Text(
                                              "${currentItem["profile"]['lT']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w800,
                                                  size: 14,
                                                  FontColor: !(moreInfo.value)
                                                      ? SuccessCardText
                                                      : FailureCardText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 55,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      children: [
                                        Text(
                                          "L. Volt",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText,
                                              size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            children: [
                                              Icon(Icons.battery_1_bar_rounded,
                                                  size: 13, color: secondaryText),
                                              Text(
                                                "${currentItem["profile"]['lV']} V",
                                                style: CardText(
                                                    font_Weight: FontWeight.w800,
                                                    size: 14,
                                                    FontColor: !(moreInfo.value)
                                                        ? SuccessCardText
                                                        : FailureCardText),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 75,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "N. Volt",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText,
                                              size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                                Icons
                                                    .battery_charging_full_outlined,
                                                size: 14,
                                                color: secondaryText),
                                            Text(
                                              "${currentItem["profile"]['nV']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w800,
                                                  size: 14,
                                                  FontColor: !(moreInfo.value)
                                                      ? SuccessCardText
                                                      : FailureCardText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 55,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "U.Temp",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText,
                                              size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${currentItem["profile"]['uTemp']} ' C",
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 14,
                                              FontColor: !(moreInfo.value)
                                                  ? SuccessCardText
                                                  : FailureCardText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "L.Temp",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: secondaryText,
                                              size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${currentItem["profile"]['lTemp']}'c",
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 14,
                                              FontColor: !(moreInfo.value)
                                                  ? SuccessCardText
                                                  : FailureCardText),
                                        ),
                                      ],
                                    ),
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
            );
          }));
    }

    setState(() {});
    return seriesSixWidgetList;
  }

  Future<List<Map<String, dynamic>>> getSeriesData() async {
    List<Map<String, dynamic>> totalBatchList = [];
    final allBatches = batchBox.values.toList();
    final allBatchMap = batchBox.toMap();

    printFunc("allBatches : ${allBatches}");
    printFunc("allBatchMap : ${allBatchMap.keys}");

    for (var entry in allBatchMap.entries) {
      final key = entry.key;
      final batch = entry.value;
      printFunc("Key: $key");
      printFunc(" batch : $batch");
      printFunc("Batch Name: ${batch.batchName}");
      printFunc("Batch saved: ${batch.saved}");
      printFunc("Firmware Version: ${batch.firmware.version}");
      printFunc("Profile Name: ${batch.profile.name}");
      printFunc("BatteryName : ${batch.battery.batteryName}");
    }

    // Clean up orphaned entries in Hive
    for (var key in allBatchMap.keys) {
      bool isPresent = batchList.any((batch) => batch['id'] == key);
      if (!isPresent) {
        printFunc("DEMO KEY IS NOT PRESENTED : ${key}");
        await batchBox.delete(key);
      }
    }

    final activeBatchMap = batchBox.toMap();

    // Create separate lists for saved and unsaved batches
    List<Map<String, dynamic>> savedBatches = [];
    List<Map<String, dynamic>> unsavedBatches = [];

    // Process batchList and separate into saved and unsaved
    for (var batch in batchList) {
      if (activeBatchMap.containsKey(batch['id'])) {
        // This batch is saved, add the saved version to savedBatches
        final savedBatch = activeBatchMap[batch['id']];
        savedBatches.add({
          'id': savedBatch.batchId,
          'name': savedBatch.batchName,
          'description': savedBatch.batchDescription,
          'firmware': savedBatch.firmware.toJson(),
          'profile': savedBatch.profile.toJson(),
          'battery': savedBatch.battery.toJson(),
          'saved': true,
        });
      } else {
        // This batch is not saved, add to unsavedBatches
        unsavedBatches.add({
          ...batch,
          'saved': false, // Ensure saved flag is set
        });
      }
    }

    // Combine lists: saved batches first, then unsaved batches
    totalBatchList.addAll(savedBatches);
    totalBatchList.addAll(unsavedBatches);

    return totalBatchList;
  }
}

/*

  List<Widget> seriesSix() {
    printFunc("Serice six Data : $seriesSixData");
    List<Widget> seriesSixWidgetList = [];

    for (int index = 0; index < ((seriesSixData != null) ? seriesSixData.length : 0); index++) {
      printFunc("DEMO DEMO Firmware logs 23: ${seriesSixData[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(seriesSixData[index]['saved'] ?? false);
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
                    '${seriesSixData[index]['id'].toString()}_${seriesSixData[index]['saved'].toString()}'),

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
                  child: FittedBox(child:
                  Column(
                    children: [
                      Row(
                        children: [
                          // Name
                          Container(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Batch : ",
                                    style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                              ],
                            ),
                          ),
                          // EmpID
                          Container(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Description : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                              ],
                            ),
                          ),
                          // DeviceID
                          Container(
                            width: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Series : ",
                                  style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Container(
                            width: 90,
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  seriesSixData[index]["name"].toString(),
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          // EmpID
                          Container(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  seriesSixData[index]["description"].toString(),
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                ),
                              ],
                            ),
                          ),
                          // DeviceID
                          Container(
                            width: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  moreInfo.value
                                  ? seriesSixData[index]["battery"]['batteryCode'].toString()
                                  : batchList[index]['batteryDetails']['Battery-Code'],
                                  style: CardText(
                                      font_Weight: FontWeight.w800,
                                      size: 19,
                                      FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        //Firmware
                        Container(
                          width: screenSize.width*0.8,
                          child: Row(
                            children: [
                              Text("Firmware Details  ",
                                  style:
                                  CardText(font_Weight: FontWeight.w500, FontColor: secondaryText)),
                              SizedBox(width: 5), // spacing before line
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
                        FittedBox(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Firm version
                                  Container(
                                    width : 150,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Firmware Version",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // version name
                                  Container(
                                    width: 150,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Firmware Name",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // download
                                  Container(
                                    width: 80,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (moreInfo.value) ? "Saved" : "Download",
                                          style: CardText(
                                              font_Weight: FontWeight.w300,
                                              FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Firm version
                                  Container(
                                    width : 150,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          seriesSixData[index]["firmware"]['version'].toString(),
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 19,
                                              FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                        )
                                      ],
                                    ),
                                  ),
                                  // version name
                                  Container(
                                    width: 150,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          seriesSixData[index]["firmware"]['versionName'].toString(),
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 19,
                                              FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                        )
                                      ],
                                    ),
                                  ),
                                  // download
                                  Container(
                                    width: 80,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              if (!(seriesSixData[index]['saved'] ?? false)) {
                                                if (!(await addBatch(BatchModel.fromJson(seriesSixData[index]))))
                                                  ShowSnackBarMessage(context, "Failed to save Batch", false);

                                                setState(() {});
                                              }
                                              // seriesSixData.clear();

                                              seriesSixData = await getSeriesData();
                                              moreInfo.value(seriesSixData[index]['saved']);
                                              setState(() {});
                                            },
                                            icon: (!(seriesSixData[index]['saved'] ?? false))
                                                ? Icon(Icons.download_for_offline_outlined,
                                                color: SuccessCardText, size: 35)
                                                : Icon(Icons.download_done_outlined, color: darkBg, size: 35)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //config/profile
                        Container(
                          width: screenSize.width * 0.8,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Text("Config : ",
                                      style:
                                          CardText(font_Weight: FontWeight.w500, FontColor: secondaryText)),
                                  Text(seriesSixData[index]["profile"]["name"],
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
                        FittedBox(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Upper Threshold
                                  Container(
                                    width : 75,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                        Text(
                                          "U. Threshold",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText,size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.battery_charging_full_outlined,
                                                size: 14, color: secondaryText),
                                            Text(
                                              "${seriesSixData[index]["profile"]['uT']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w800,
                                                  size: 14,
                                                  FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Upper Voltage
                                  Container(
                                    width:55,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                        Text(
                                          "U.Volt",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText,size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.battery_6_bar_outlined, size: 14, color: secondaryText),
                                            Text(
                                              "${seriesSixData[index]["profile"]['uV']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w800,
                                                  size: 14,
                                                  FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Lower Threshold
                                  Container(
                                    width: 70,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                        Text(
                                          "L.Threshold",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText,size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.battery_alert_outlined, size: 13, color: secondaryText),
                                            Text(
                                              "${seriesSixData[index]["profile"]['lT']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w800,
                                                  size: 14,
                                                  FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Lower Voltage
                                  Container(
                                    width: 55,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      children: [
                                        // Icon(Icons.battery_2_bar, size: 18, color: secondaryText), // Lower Voltage
                                        Text(
                                          "L. Volt",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText,size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.battery_1_bar_rounded, size: 13, color: secondaryText),
                                            Text(
                                              "${seriesSixData[index]["profile"]['lV']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w800,
                                                  size: 14,
                                                  FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nominal Voltage
                                  Container(
                                    width : 75,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                        Text(
                                          "N. Volt",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText,size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.battery_charging_full_outlined,
                                                size: 14, color: secondaryText),
                                            Text(
                                              "${seriesSixData[index]["profile"]['nV']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w800,
                                                  size: 14,
                                                  FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Upper Voltage
                                  Container(
                                    width:55,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.flash_on, size: 18, color: secondaryText), // Upper Voltage
                                        Text(
                                          "U.Temp",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText,size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${seriesSixData[index]["profile"]['uTemp']}",
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 14,
                                              FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Lower Threshold
                                  Container(
                                    width: 70,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.trending_down, size: 18, color: secondaryText), // Lower Threshold
                                        Text(
                                          "L.Temp",
                                          style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText,size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${seriesSixData[index]["profile"]['lTemp']}",
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 14,
                                              FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Lower Voltage
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

  Future<List<Map<String, dynamic>>> getSeriesData() async {
    List<Map<String, dynamic>> totalBatchList = [];
    final allBatches = batchBox.values.toList(); // List<BatchModel>
    final allBatchMap = batchBox.toMap(); // Map<dynamic, BatchModel>
    printFunc("allBatches : ${allBatches}");
    printFunc("allBatchMap : ${allBatchMap.keys}");

    for (var entry in allBatchMap.entries) {
      final key = entry.key;
      final batch = entry.value;

      printFunc("Key: $key");
      printFunc(" batch : $batch");
      printFunc("Batch Name: ${batch.batchName}");
      printFunc("Batch saved: ${batch.saved}");
      printFunc("Firmware Version: ${batch.firmware.version}");
      printFunc("Profile Name: ${batch.profile.name}");
      printFunc("BatteryName : ${batch.battery.batteryName}");
    }
    final allBatchesWithKeys = batchBox.keys.map((key) {
      final batch = batchBox.get(key);
      return {'key': key, 'value': batch};
    }).toList();
    // final batchFromHive = batchBox.get("$id");

    printFunc("DEMO BATCH WITH KEYS : $allBatchesWithKeys");

    if(allBatchMap.containsKey(batchList)){
      printFunc("Demo batch ID : ${allBatchMap.keys}");
    }else{
      printFunc("Demo batch ID not : ${allBatchMap.keys}");
    }

    for(var key in allBatchMap.keys){
      bool ispresent =  batchList.any((batch) => batch['id'] == key);
      if(!ispresent){
        printFunc("DEMO KEY IS NOT PRESENTED : ${key}");
        await batchBox.delete(key);
      }
    }

    final activeBatchMap = batchBox.toMap();

    activeBatchMap.forEach((key, batch) {
      totalBatchList.add({
        'id': batch.batchId,
        'name': batch.batchName,
        'description': batch.batchDescription,
        'firmware': batch.firmware.toJson(),
        'profile': batch.profile.toJson(),
        'battery':batch.battery.toJson(),
        'saved': true,
      });
    });

// Step 2: Add only new entries from batchList (by checking if ID not in allBatchMap)
    for (var batch in batchList) {
      if (!allBatchMap.containsKey(batch['id'])) {
        totalBatchList.add(batch);
      }
    }

    return totalBatchList;
  }
*/
