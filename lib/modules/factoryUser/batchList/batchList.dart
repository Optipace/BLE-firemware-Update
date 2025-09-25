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

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 14,
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
            "Batches",
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
                tilePadding: EdgeInsets.all(3),
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
                                  Text("Batch ",
                                      style: CardText(
                                          font_Weight: FontWeight.w500,
                                          FontColor: secondaryText)),
                                ],
                              ),
                            ),
                            Container(
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Description ",
                                    style: CardText(
                                        font_Weight: FontWeight.w500,
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
                                    "Series ",
                                    style: CardText(
                                        font_Weight: FontWeight.w500,
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
                          children: [
                            Container(
                              width: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      currentItem["name"].toString(),
                                      style: CardText(
                                          font_Weight: FontWeight.w600,
                                          size: 16,
                                          FontColor: !(moreInfo.value)
                                              ? SuccessCardText
                                              : FailureCardText),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentItem["description"].toString(),
                                    style: CardText(
                                        font_Weight: FontWeight.w600,
                                        size: 16,
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
                                        font_Weight: FontWeight.w600,
                                        size: 16,
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
                                      size: 16,
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
                                              font_Weight: FontWeight.w500,
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
                                              font_Weight: FontWeight.w500,
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
                                              font_Weight: FontWeight.w500,
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
                                              font_Weight: FontWeight.w600,
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
                                              font_Weight: FontWeight.w600,
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
                                    child: Center(
                                      child: IconButton(
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
                                          size: 16,
                                          FontColor: secondaryText)),
                                  Text(currentItem["profile"]["name"],
                                      style: CardText(
                                          font_Weight: FontWeight.w500,
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "U. Threshold",
                                          style: CardText(
                                              font_Weight: FontWeight.w500,
                                              FontColor: secondaryText,
                                              size: 12),
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
                                                  font_Weight: FontWeight.w600,
                                                  size: 13,
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
                                              font_Weight: FontWeight.w500,
                                              FontColor: secondaryText,
                                              size: 12),
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
                                                        FontWeight.w600,
                                                    size: 13,
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
                                              font_Weight: FontWeight.w500,
                                              FontColor: secondaryText,
                                              size: 12),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.battery_alert_outlined,
                                                size: 13, color: secondaryText),
                                            Text(
                                              "${currentItem["profile"]['lT']} V",
                                              style: CardText(
                                                  font_Weight: FontWeight.w600,
                                                  size: 13,
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
                                              font_Weight: FontWeight.w500,
                                              FontColor: secondaryText,
                                              size: 12),
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
                                                    font_Weight: FontWeight.w600,
                                                    size: 13,
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
                                              font_Weight: FontWeight.w500,
                                              FontColor: secondaryText,
                                              size: 12),
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
                                                  font_Weight: FontWeight.w600,
                                                  size: 13,
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
                                              font_Weight: FontWeight.w500,
                                              FontColor: secondaryText,
                                              size: 12),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${currentItem["profile"]['uTemp']} ' C",
                                          style: CardText(
                                              font_Weight: FontWeight.w600,
                                              size: 13,
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
                                              font_Weight: FontWeight.w500,
                                              FontColor: secondaryText,
                                              size: 12),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${currentItem["profile"]['lTemp']}'C",
                                          style: CardText(
                                              font_Weight: FontWeight.w600,
                                              size: 13,
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

