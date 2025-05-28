import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/login/api/api.dart';

class AdminLogs extends StatefulWidget {
  @override
  State<AdminLogs> createState() => AdminLogsState();
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

class AdminLogsState extends State<AdminLogs> {
  int selectedbutton = 1;

  @override
  Widget build(BuildContext context) {
    print("Inside Logs Page");
    print("Inside Logs Page");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightBg),
          title: Text(
            "Logs",
            style: TextStyle(
                fontFamily: baseFont,
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: lightBg),
          ),
          toolbarHeight: size.height / 11.5,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: lightBg,
        body: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Card(
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
                              topLeft: Radius.circular(28),
                              bottomLeft: Radius.circular(28)),
                          border: Border.all(width: 0.5, color: darkBg),
                          boxShadow: [
                            BoxShadow(blurRadius: 0.5, color: darkBg)
                          ]),
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
                                      color: selectedbutton == 1
                                          ? lightBg
                                          : darkBg),
                                  Shadow(
                                      offset: Offset(-0.3, 0.3),
                                      color: selectedbutton == 1
                                          ? lightBg
                                          : darkBg),
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
                              topRight: Radius.circular(28),
                              bottomRight: Radius.circular(28)),
                          boxShadow: [
                            BoxShadow(blurRadius: 0.5, color: darkBg)
                          ]),
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
          ],
        ));
  }

  List<Widget> factoryUserLog() {
    var FactoryLogs = getFactoryLogs();
    List<Widget> FactoryUsersList = [];

    for (int index = 0; index < FactoryLogs.length; index++) {
      printFunc("DEMO DEMO Factory logs : ${FactoryLogs[index]}");
      ValueNotifier moreInfo = ValueNotifier<bool>(false);
      FactoryUsersList.add(ValueListenableBuilder(
          valueListenable: moreInfo,
          builder: (ctx, value, child) {
            return Container(
              margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                )]
              ),
              child: ExpansionTile(
                key: ValueKey('factory_$index'),
                tilePadding: EdgeInsets.all(5),
                backgroundColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                collapsedBackgroundColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                iconColor: darkBg,
                collapsedIconColor: darkBg,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                        color: Colors.black,
                        width: 0.3
                    )
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                        color: Colors.black,
                        width: 0.3
                    )
                ),

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
                        Text("Name : ",
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText)),
                        SizedBox(
                          height: 3,
                        ),
                        Text(FactoryLogs[index]["Name"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor:
                                FactoryLogs[index]['status'] == 'Success'
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
                          style: CardText(
                              font_Weight: FontWeight.w300,
                              FontColor: secondaryText),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          FactoryLogs[index]["empId"],
                          style: CardText(
                              font_Weight: FontWeight.w800,
                              size: 19,
                              FontColor:
                              FactoryLogs[index]['status'] == 'Success'
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
                          style: CardText(
                              font_Weight: FontWeight.w300,
                              FontColor: secondaryText),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          FactoryLogs[index]['DeviceID'],
                          style: CardText(
                              font_Weight: FontWeight.w800,
                              size: 19,
                              FontColor:
                              FactoryLogs[index]['status'] == 'Success'
                                  ? SuccessCardText
                                  : FailureCardText),
                        )
                      ],
                    ),
                  ],
                ),
                ),
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                    children: [
                      Divider(color: Colors.black26,),
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
                                "Phone Number : ",
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
                                    size: 19,
                                    FontColor: FactoryLogs[index]['status'] ==
                                        'Success'
                                        ? SuccessCardText
                                        : FailureCardText),
                              )
                            ],
                          ),
                          SizedBox(width: 20,),
                          // Firm Version
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Firm version : ",
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
                                    size: 19,
                                    FontColor: FactoryLogs[index]['status'] ==
                                        'Success'
                                        ? SuccessCardText
                                        : FailureCardText),
                              )
                            ],
                          ),
                          SizedBox(width: 20,),
                          // Battery-Service
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Battery-Service : ",
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
                                    size: 19,
                                    FontColor: FactoryLogs[index]['status'] ==
                                        'Success'
                                        ? SuccessCardText
                                        : FailureCardText),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
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
                                "Service-Profile:",
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
                                  size: 19,
                                  FontColor: FactoryLogs[index]['status'] ==
                                      'Success'
                                      ? SuccessCardText
                                      : FailureCardText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 35,),
                          // Date-Time
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date-Time:",
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
                                  size: 19,
                                  FontColor: FactoryLogs[index]['status'] ==
                                      'Success'
                                      ? SuccessCardText
                                      : FailureCardText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30,),
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
                                  size: 19,
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
                  ),
                  )
                ],
              ),
              // CARD DESIGN
              /*Card(
                color: FactoryLogs[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.black,
                    width: 0.3
                  )
                ),
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.fromLTRB(15, 8, 15, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Name : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      )
                                  ),
                                  SizedBox(height: 3,),
                                  Text(
                                      FactoryLogs[index]["Name"],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                      )
                                  ),
                                ],
                              ),
                            )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "EmpID : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                      FactoryLogs[index]["empId"],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "DeviceID : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                        FactoryLogs[index]['DeviceID'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                        ),
                                    )
                                  ],
                                ),
                              )
                          ),


                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Phone Number : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                      FactoryLogs[index]['phone'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText

                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Firm version : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                        FactoryLogs[index]['firm_version'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                        ),

                                    )
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Battery-Service : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                        FactoryLogs[index]['Battery-Service'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Service-Profile : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                        FactoryLogs[index]['Battery-profile'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                        ),
                                    )
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date-Time : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(FactoryLogs[index]['Date-Time'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(FactoryLogs[index]['status'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText

                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              )*/
            );
          }));
    }

    setState(() {});
    return FactoryUsersList;
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                  )]
              ),
              child: ExpansionTile(

                key: ValueKey('field_$index'),

                tilePadding: EdgeInsets.all(5),
                backgroundColor: FeildUserLogs[index]['status'].toLowerCase() == 'success' ? SuccessCard : FailureCard,
                collapsedBackgroundColor: FeildUserLogs[index]['status'].toLowerCase() == 'success' ? SuccessCard : FailureCard,
                iconColor: darkBg,
                collapsedIconColor: darkBg,
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                        color: Colors.black,
                        width: 0.3
                    )
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                        color: Colors.black,
                        width: 0.3
                    )
                ),

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
                          Text("Name : ",
                              style: CardText(
                                  font_Weight: FontWeight.w300,
                                  FontColor: secondaryText)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(FeildUserLogs[index]["Name"],
                              style: CardText(
                                  font_Weight: FontWeight.w800,
                                  size: 19,
                                  FontColor:
                                  FeildUserLogs[index]['status'].toLowerCase() == 'success'
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
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            FeildUserLogs[index]["empId"],
                            style: CardText(
                                font_Weight: FontWeight.w800,
                                size: 19,
                                FontColor:
                                FeildUserLogs[index]['status'].toLowerCase() == 'Success'
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
                              size: 19,
                              FontColor: FeildUserLogs[index]['status'].toLowerCase() ==
                                  'success'
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
                  Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Divider(color: Colors.black26,),
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
                                  "Phone Number : ",
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
                                      size: 19,
                                      FontColor: FeildUserLogs[index]['status'].toLowerCase() ==
                                          'success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(width: 20,),
                            // Firm Version
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Firm version : ",
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
                                      size: 19,
                                      FontColor: FeildUserLogs[index]['status'].toLowerCase() ==
                                          'success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                            SizedBox(width: 20,),
                            // Battery-Service
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Battery-Service : ",
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
                                      size: 19,
                                      FontColor: FeildUserLogs[index]['status'].toLowerCase() ==
                                          'success'
                                          ? SuccessCardText
                                          : FailureCardText),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
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
                                    "Service-Profile:",
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
                                      size: 19,
                                      FontColor: FeildUserLogs[index]['status'] ==
                                          'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 35,),
                              // Date-Time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date-Time:",
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
                                      size: 19,
                                      FontColor: FeildUserLogs[index]['status'] ==
                                          'Success'
                                          ? SuccessCardText
                                          : FailureCardText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 30,),

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
                                        size: 19,
                                        FontColor:
                                        FeildUserLogs[index]['status'] == 'Success'
                                            ? SuccessCardText
                                            : FailureCardText),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // CARD DESIGN
              /*Card(
                color: FactoryLogs[index]['status'] == 'Success' ? SuccessCard : FailureCard,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.black,
                    width: 0.3
                  )
                ),
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.fromLTRB(15, 8, 15, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Name : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      )
                                  ),
                                  SizedBox(height: 3,),
                                  Text(
                                      FactoryLogs[index]["Name"],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                      )
                                  ),
                                ],
                              ),
                            )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "EmpID : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                      FactoryLogs[index]["empId"],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "DeviceID : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                        FactoryLogs[index]['DeviceID'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                        ),
                                    )
                                  ],
                                ),
                              )
                          ),


                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Phone Number : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                      FactoryLogs[index]['phone'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText

                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Firm version : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                        FactoryLogs[index]['firm_version'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                        ),

                                    )
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Battery-Service : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                        FactoryLogs[index]['Battery-Service'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Service-Profile : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                        FactoryLogs[index]['Battery-profile'],
                                        style: CardText(
                                            font_Weight: FontWeight.w800,
                                            size: 19,
                                            FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                        ),
                                    )
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date-Time : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(FactoryLogs[index]['Date-Time'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: CardText(
                                          font_Weight: FontWeight.w300,
                                          FontColor: secondaryText
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(FactoryLogs[index]['status'],
                                      style: CardText(
                                          font_Weight: FontWeight.w800,
                                          size: 19,
                                          FontColor: FactoryLogs[index]['status'] == 'Success' ? SuccessCardText : FailureCardText

                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              )*/
            );
          }));
    }

    setState(() {});
    return FieldUsersList;
  }
}
