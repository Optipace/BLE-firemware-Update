import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/factory_log.dart';
import 'package:tracker_firmware/modules/admin/log/field_log.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';

class AdminLogs extends StatefulWidget {
  @override
  State<AdminLogs> createState() => AdminLogsState();
}

TextStyle CardText({required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

class AdminLogsState extends State<AdminLogs> {
  int selectedbutton = 1;
  Map<String, dynamic> batteryList = {};
  List<Map<String, dynamic>> batchList = [{}];
  var factoryLogs;
  var fieldLogs;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      batteryList = {
        "B6": {
          "id": 1,
          "name": "B6",
          "priority": 1,
          "batches":[]
        },
        "B9": {
          "id": 2,
          "name": "B9",
          "priority": 2,
          "batches":[]
        },
        "B12": {
          "id": 3,
          "name": "B12",
          "priority": 3,
          "batches":[]
        },
      };
      batchList = await getBatchList(context);

      for(var batch in batchList){
        if(batch.containsKey("profile") && batch["profile"].containsKey("deviceType")){
          String type = batch["profile"]["deviceType"];
          if(batteryList.containsKey(type)){
            if(batteryList[type]["batches"] is! List){
              batteryList[type]["batches"] =[];
            }
            batteryList[type]["batches"].add(batch);
          }
        }
      }
      printFunc("Bacthes length : ${batteryList["B6"]["batches"].length}");



      setState(() {});
    });
    factoryLogs = getFactoryLogs();
    fieldLogs = getFeildLogs();
    setState(() {});
    printFunc("Logs length : ${factoryLogs.length}");



  }



  @override
  Widget build(BuildContext context) {
    print("Inside Logs Page");

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Logs",
            style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
          ),
          toolbarHeight: size.height / 11.5,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: lightBg,
        body: Column(
          children: [
            //Loop for battery list
            Center(
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                  color: second_lightBg,
                  border: Border.all(
                    color: darkBg,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(
                    color: darkBg,
                    blurRadius: 0.8
                  )]

                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Batches : ",
                      style: TextStyle(
                        color: darkBg,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w500,
                        fontSize: 24
                      ),
                    ),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        for (int i = 0; i < batteryList.length; i += 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: second_lightBg,
                                      border: Border.all(
                                          color: darkBg,
                                          width: 1
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [BoxShadow(
                                          color: darkBg,
                                          blurRadius: 0.8
                                      )]

                                  ),
                                  child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.battery_std,color: darkBg,shadows: [Shadow(color: darkBg,blurRadius: 0.8)],),
                                          SizedBox(height: 2,),
                                          Text(batteryList.entries.elementAt(i).value["name"].toString(),
                                            style: TextStyle(color: darkBg, fontSize: 20,fontWeight: FontWeight.w500,fontFamily: baseFont),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("No.of Batches : ${(batteryList.entries.elementAt(i).value["batches"] as List?)?.length ?? 0}",
                                            style: TextStyle(color: darkBg, fontSize: 16,fontWeight: FontWeight.w500,fontFamily: baseFont),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Center(
                                child: (i + 1 < batteryList.length)
                                    ? Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: second_lightBg,
                                      border: Border.all(
                                          color: darkBg,
                                          width: 1
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [BoxShadow(
                                          color: darkBg,
                                          blurRadius: 0.8
                                      )]

                                  ),
                                  child: Center(
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.battery_std,color: darkBg,shadows: [Shadow(color: darkBg,blurRadius: 0.8)],),
                                        SizedBox(height: 2,),
                                        Text(batteryList.entries.elementAt(i + 1).value["name"].toString(),
                                          style: TextStyle(color: darkBg, fontSize: 20,fontWeight: FontWeight.w500,fontFamily: baseFont),
                                        ),
                                        SizedBox(height: 5,),
                                        Text("No.of Batches : ", //${(batteryList.entries.elementAt(i+1).value["batches"] as List?)?.length ?? }
                                          style: TextStyle(color: darkBg, fontSize: 16,fontWeight: FontWeight.w500,fontFamily: baseFont),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    : SizedBox(),
                              ),
                            ],
                          )
                      ],
                    ),

                  ],
                )
              )
            ),

            SizedBox(
              height: 5,
            ),

            GestureDetector(
              onTap: () {
                printFunc("Inside Factory user ");
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FactoryLog()));
              },
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                    color: second_lightBg,
                    border: Border.all(
                        color: darkBg,
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(
                        color: darkBg,
                        blurRadius: 0.8
                    )]

                ),
                child: Column(
                  children: [
                    Text("No.of Devices flashed by Factory user :",
                      style: TextStyle(color: darkBg, fontSize: 18,fontWeight: FontWeight.w500,fontFamily: baseFont),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.on_device_training_outlined,color: darkBg,shadows: [Shadow(color: darkBg,blurRadius: 0.8)],),
                        SizedBox(width: 5,),
                        Text(": ${factoryLogs.length}",
                          style: TextStyle(color: darkBg, fontSize: 20,fontWeight: FontWeight.w500,fontFamily: baseFont),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                printFunc("Inside Field user ");
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FieldLogs()));
              },
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                    color: second_lightBg,
                    border: Border.all(
                        color: darkBg,
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(
                        color: darkBg,
                        blurRadius: 0.8
                    )]

                ),
                child: Column(
                  children: [
                    Text("No.of Devices flashed by Field user :",
                      style: TextStyle(color: darkBg, fontSize: 18,fontWeight: FontWeight.w500,fontFamily: baseFont),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.on_device_training_outlined),
                        SizedBox(width: 5,),
                        Text(": ${fieldLogs.length}",
                          style: TextStyle(color: darkBg, fontSize: 20,fontWeight: FontWeight.w500,fontFamily: baseFont),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            /*Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: darkBg,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(28))),
              color: lightBg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedbutton = 1;
                      });
                    },
                    child: Container(
                      width: size.width * 0.48,
                      height: 60,
                      decoration: BoxDecoration(
                          color: selectedbutton == 1 ? darkBg : lightBg,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28), bottomLeft: Radius.circular(28)),
                          border: Border.all(width: 0.5, color: darkBg),
                          boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                      child: Center(
                          heightFactor: 2,
                          child: Center(
                            child: Text(
                              "Factory User",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: baseFont,
                                fontWeight: FontWeight.w600,
                                color: selectedbutton == 1 ? lightBg : darkBg,
                                shadows: [
                                  Shadow(
                                      offset: Offset(0.3, 0.3),
                                      color: selectedbutton == 1 ? lightBg : darkBg),
                                  Shadow(
                                      offset: Offset(-0.3, 0.3),
                                      color: selectedbutton == 1 ? lightBg : darkBg),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedbutton = 2;
                      });
                    },
                    child: Container(
                      width: size.width * 0.49,
                      height: 60,
                      decoration: BoxDecoration(
                          color: selectedbutton == 2 ? darkBg : lightBg,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(28), bottomRight: Radius.circular(28)),
                          boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                      child: Center(
                        heightFactor: 2,
                        child: Center(
                          child: Text(
                            "Field User",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: baseFont,
                              fontWeight: FontWeight.w600,
                              color: selectedbutton == 1 ? darkBg : lightBg,
                              shadows: [
                                Shadow(
                                  offset: Offset(0.3, 0.3),
                                  color: selectedbutton == 1 ? darkBg : lightBg,
                                ),
                                Shadow(
                                  offset: Offset(-0.3, 0.3),
                                  color: selectedbutton == 1 ? darkBg : lightBg,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  if (selectedbutton == 1) ...?factoryUserLog(),
                  if (selectedbutton == 2) ...?fieldUserLog(),
                ],
              ),
            )),

             */
          ],
        ));
  }

  List<Widget> factoryUserLog() {
    var factoryLogs = getFactoryLogs();
    List<Widget> factoryUsersList = [];

    for (int index = 0; index < factoryLogs.length; index++) {
      printFunc("DEMO DEMO Factory logs : ${factoryLogs[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(false);
      factoryUsersList.add(ValueListenableBuilder(
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
                key: ValueKey('factory_$index'),
                tilePadding: EdgeInsets.all(5),
                backgroundColor: factoryLogs[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                collapsedBackgroundColor:
                    factoryLogs[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                iconColor: darkBg,
                collapsedIconColor: darkBg,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                title: Container(
                  padding: EdgeInsets.all(5),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Name
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(factoryLogs[index]["Name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 14,
                                  FontColor: factoryLogs[index]['status'] == 'Success'
                                      ? SuccessCardText
                                      : FailureCardText)),
                        ],
                      ),
                      // EmpID
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "EmpID : ",
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            factoryLogs[index]["empId"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 14,
                                FontColor: factoryLogs[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          ),
                        ],
                      ),
                      // DeviceID
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DeviceID : ",
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            factoryLogs[index]['DeviceID'],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 14,
                                FontColor: factoryLogs[index]['status'] == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.black26,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // phone number
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Phone\nNumber : ",
                                          style: CardText(
                                              font_Weight: FontWeight.w300, FontColor: secondaryText),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          factoryLogs[index]['phone'],
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 16,
                                              FontColor: factoryLogs[index]['status'] == 'Success'
                                                  ? SuccessCardText
                                                  : FailureCardText),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //Service-Profile
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Service\nProfile:",
                                          style: CardText(
                                            font_Weight: FontWeight.w300,
                                            FontColor: secondaryText,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          factoryLogs[index]['Battery-profile'],
                                          style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor: factoryLogs[index]['status'] == 'Success'
                                                ? SuccessCardText
                                                : FailureCardText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Firm Version
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Firm\nversion : ",
                                          style: CardText(
                                              font_Weight: FontWeight.w300, FontColor: secondaryText),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          factoryLogs[index]['firm_version'],
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 16,
                                              FontColor: factoryLogs[index]['status'] == 'Success'
                                                  ? SuccessCardText
                                                  : FailureCardText),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Date-Time
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Date\nTime:",
                                          style: CardText(
                                            font_Weight: FontWeight.w300,
                                            FontColor: secondaryText,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          factoryLogs[index]['Date-Time'].replaceFirst(' ', '\n'),
                                          style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor: factoryLogs[index]['status'] == 'Success'
                                                ? SuccessCardText
                                                : FailureCardText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Battery-Service
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Battery\nService : ",
                                          style: CardText(
                                              font_Weight: FontWeight.w300, FontColor: secondaryText),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          factoryLogs[index]['Battery-Service'],
                                          style: CardText(
                                              font_Weight: FontWeight.w800,
                                              size: 16,
                                              FontColor: factoryLogs[index]['status'] == 'Success'
                                                  ? SuccessCardText
                                                  : FailureCardText),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Status
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Status:",
                                          style: CardText(
                                            font_Weight: FontWeight.w300,
                                            FontColor: secondaryText,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          factoryLogs[index]['status'],
                                          style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor: factoryLogs[index]['status'] == 'Success'
                                                ? SuccessCardText
                                                : FailureCardText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                /*Column(
                          children: [
                            Divider(
                              color: Colors.black26,
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // phone number
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phone\nNumber : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      FactoryLogs[index]['phone'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FactoryLogs[index]['status'] ==
                                              'Success'
                                              ? SuccessCardText
                                              : FailureCardText),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                // Firm Version
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Firm\nversion : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      FactoryLogs[index]['firm_version'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FactoryLogs[index]['status'] ==
                                              'Success'
                                              ? SuccessCardText
                                              : FailureCardText),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                // Battery-Service
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Battery\nService : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      FactoryLogs[index]['Battery-Service'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FactoryLogs[index]['status'] ==
                                              'Success'
                                              ? SuccessCardText
                                              : FailureCardText),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Service-Profile
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Service\nProfile:",
                                        style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        FactoryLogs[index]['Battery-profile'],
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FactoryLogs[index]['status'] ==
                                              'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  // Date-Time
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date\nTime:",
                                        style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        FactoryLogs[index]['Date-Time']
                                            .replaceFirst(' ', '\n'),
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FactoryLogs[index]['status'] ==
                                              'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  // Status
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Status:",
                                        style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        FactoryLogs[index]['status'],
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FactoryLogs[index]['status'] ==
                                              'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )*/
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            );
          }));
    }

    setState(() {});
    return factoryUsersList;
  }

  List<Widget> fieldUserLog() {
    var FeildUserLogs = getFeildLogs();
    List<Widget> FieldUsersList = [];

    for (int index = 0; index < FeildUserLogs.length; index++) {
      printFunc("DEMO DEMO Factory logs : ${FeildUserLogs[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(false);
      FieldUsersList.add(ValueListenableBuilder(
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
                key: ValueKey('field_$index'),
                tilePadding: EdgeInsets.all(5),
                backgroundColor:
                    FeildUserLogs[index]['status'].toLowerCase() == 'success' ? SuccessCard : FailureCard,
                collapsedBackgroundColor:
                    FeildUserLogs[index]['status'].toLowerCase() == 'success' ? SuccessCard : FailureCard,
                iconColor: darkBg,
                collapsedIconColor: darkBg,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 0.3)),
                title: Container(
                  padding: EdgeInsets.all(5),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Name
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ",
                              style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(FeildUserLogs[index]["Name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 14,
                                  FontColor: FeildUserLogs[index]['status'].toLowerCase() == 'success'
                                      ? SuccessCardText
                                      : FailureCardText)),
                        ],
                      ),
                      // EmpID
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "EmpID : ",
                            style: CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            FeildUserLogs[index]["empId"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 14,
                                FontColor: FeildUserLogs[index]['status'].toLowerCase() == 'Success'
                                    ? SuccessCardText
                                    : FailureCardText),
                          ),
                        ],
                      ),
                      // Status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status:",
                            style: CardText(
                              font_Weight: FontWeight.w300,
                              FontColor: secondaryText,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            FeildUserLogs[index]['status'],
                            style: CardText(
                              font_Weight: FontWeight.w800,
                              size: 14,
                              FontColor: FeildUserLogs[index]['status'].toLowerCase() == 'success'
                                  ? SuccessCardText
                                  : FailureCardText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Divider(
                          color: Colors.black26,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // phone number
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Phone\nNumber : ",
                                        style:
                                            CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        FeildUserLogs[index]['phone'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor:
                                                FeildUserLogs[index]['status'].toLowerCase() == 'success'
                                                    ? SuccessCardText
                                                    : FailureCardText),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //Service-Profile
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Service\nProfile:",
                                        style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        FeildUserLogs[index]['Battery-profile'],
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FeildUserLogs[index]['status'] == 'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  // Firm Version
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Firm\nversion : ",
                                        style:
                                            CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        FeildUserLogs[index]['firm_version'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor:
                                                FeildUserLogs[index]['status'].toLowerCase() == 'success'
                                                    ? SuccessCardText
                                                    : FailureCardText),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Date-Time
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date\nTime:",
                                        style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        FeildUserLogs[index]['Date-Time'].replaceFirst(' ', '\n'),
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FeildUserLogs[index]['status'] == 'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Battery-Service
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Battery\nService : ",
                                        style:
                                            CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        FeildUserLogs[index]['Battery-Service'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 16,
                                            FontColor:
                                                FeildUserLogs[index]['status'].toLowerCase() == 'success'
                                                    ? SuccessCardText
                                                    : FailureCardText),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // DeviceID
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "DeviceID : ",
                                        style:
                                            CardText(font_Weight: FontWeight.w300, FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        FeildUserLogs[index]['DeviceID'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 14,
                                            FontColor: FeildUserLogs[index]['status'] == 'Success'
                                                ? SuccessCardText
                                                : FailureCardText),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              /* Column(
                          children: [
                            Divider(
                              color: Colors.black26,
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // phone number
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phone\nNumber : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      FeildUserLogs[index]['phone'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FeildUserLogs[index]['status']
                                              .toLowerCase() ==
                                              'success'
                                              ? SuccessCardText
                                              : FailureCardText),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                // Firm Version
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Firm\nversion : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      FeildUserLogs[index]['firm_version'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FeildUserLogs[index]['status']
                                              .toLowerCase() ==
                                              'success'
                                              ? SuccessCardText
                                              : FailureCardText),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                // Battery-Service
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Battery\nService : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      FeildUserLogs[index]['Battery-Service'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FeildUserLogs[index]['status']
                                              .toLowerCase() ==
                                              'success'
                                              ? SuccessCardText
                                              : FailureCardText),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Service-Profile
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Service\nProfile:",
                                        style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        FeildUserLogs[index]['Battery-profile'],
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FeildUserLogs[index]
                                          ['status'] ==
                                              'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  // Date-Time
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date\nTime:",
                                        style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        FeildUserLogs[index]['Date-Time']
                                            .replaceFirst(' ', '\n'),
                                        style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 16,
                                          FontColor: FeildUserLogs[index]
                                          ['status'] ==
                                              'Success'
                                              ? SuccessCardText
                                              : FailureCardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),

                                  // DeviceID
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "DeviceID : ",
                                        style: CardText(
                                            font_Weight: FontWeight.w300,
                                            FontColor: secondaryText),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        FeildUserLogs[index]['DeviceID'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 14,
                                            FontColor: FeildUserLogs[index]
                                            ['status'] ==
                                                'Success'
                                                ? SuccessCardText
                                                : FailureCardText),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )*/
                            ],
                          ),
                        )
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
    return FieldUsersList;
  }
}
