import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/batchModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/dfuModule/dfuModule.dart';
import 'package:tracker_firmware/modules/factoryUser/api/hardWareNumber.dart';
import 'package:tracker_firmware/modules/factoryUser/bluetooth/bluetoothHardWareNumber.dart';
import 'package:tracker_firmware/widgets/buttons.dart';

class SavedBatches extends StatefulWidget {
  const SavedBatches({super.key});

  @override
  State<SavedBatches> createState() => BlueetoothBatchesState();
}

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

class BlueetoothBatchesState extends State<SavedBatches> {
  int selectedbutton = 1;
  List<BatchModel> batchList = [];
  List<Map<String, dynamic>> clientList = [];
  Map<String, dynamic> AllClient = {};
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

      getAllseriesData = await getSeriesData();

      await loadHardWareNumber(context);
      clientList = await getAllClients(context);

      printFunc("Batch list/ :-> $batchList");

      // addBatch(BatchModel.fromJson(batchList[0]));

      if (mounted) {
        setState(() {});
      }
    });
  }

  void clientListIntoMap() {
    AllClient = {for (var client in clientList) client['name'].toString(): client};
    setState(() {});
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

              child:Column(children: seriesSix()),
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
                      Container(
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                      // Description
                      Container(
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                      // Series
                      Container(
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [

                        //Firmware
                        Container(
                          width: size.width * 0.8,
                          child: Row(
                            children: [
                              Text("Firmware Details : ",
                                  style:
                                  CardText(font_Weight: FontWeight.w500, FontColor: secondaryText)),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Firm version
                              Container(
                                width : 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              ),
                              // firmware name
                              Container(
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              ),
                              // download
                              Container(
                                width:50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Flash",
                                      style: CardText(font_Weight: FontWeight.w300, FontColor: SuccessCardText),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          printFunc("Which Data is : ${getAllseriesData[index]}");
                                          printFunc("Client Map : ${AllClient}");
                                          clientListIntoMap();
                                          BatchSelected.cleardata();
                                          var batchObj = getAllseriesData[index];
                                          setState(() {});

                                          BatchSelected.setobj = getAllseriesData[index];

                                          FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

                                          Navigator.of(context).push(MaterialPageRoute<void>(
                                              builder: (_) => DfuHomePage(
                                                    SelectedBatch: BatchSelected,
                                                    allClients: AllClient,
                                                  )));
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.flash_on_outlined, color: darkBg, size: 35)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Config
                        Container(
                          width: size.width * 0.8,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Text("Config : ",
                                      style:
                                          CardText(font_Weight: FontWeight.w500, FontColor: secondaryText)),
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
                        FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Upper Threshold
                                  Container(
                                    width : 75,
                                    margin: EdgeInsets.all(1.5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.trending_up, size: 18, color: secondaryText), // Upper Threshold
                                        Text(
                                          "U. Threshold",
                                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText,size: 13),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.battery_charging_full_outlined,
                                                size: 14, color: secondaryText),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "${getAllseriesData[index]["profile"]['uT']} V",
                                                style: CardText(
                                                    font_Weight: FontWeight.w800,
                                                    size: 14,
                                                    FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  // Upper Voltage
                                  Container(
                                    width: 55,
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
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "${getAllseriesData[index]["profile"]['uV']} V",
                                                style: CardText(
                                                    font_Weight: FontWeight.w800,
                                                    size: 14,
                                                    FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                              ),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.battery_alert_outlined, size: 13, color: secondaryText),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "${getAllseriesData[index]["profile"]['lT']} V",
                                                style: CardText(
                                                    font_Weight: FontWeight.w800,
                                                    size: 14,
                                                    FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                              ),
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
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "${getAllseriesData[index]["profile"]['lV']} V",
                                                style: CardText(
                                                    font_Weight: FontWeight.w800,
                                                    size: 14,
                                                    FontColor: !(moreInfo.value) ? SuccessCardText : FailureCardText),
                                              ),
                                            ),
                                          ],
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
    printFunc("DemoDDEMO : $totalBatchList");

    return totalBatchList;
  }
}
