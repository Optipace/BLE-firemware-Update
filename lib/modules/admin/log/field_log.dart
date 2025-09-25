import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/sortByStatus.dart';
import 'package:tracker_firmware/services/apiCall/Admin/logs.dart';

TextStyle CardText(
    {required FontWeight font_Weight, double? size, Color? FontColor}) {
  return TextStyle(
      color: FontColor ?? darkBg,
      fontWeight: font_Weight,
      fontFamily: baseFont,
      fontSize: size ?? 16,
      shadows: [Shadow(color: Colors.black)]);
}

List<Widget> fieldUserLog(BuildContext context) {
  var FeildUserLogs = getFeildLogs();
  var SortedLogs = sortByStatus(FeildUserLogs);
  List<Widget> FieldUsersList = [];

  for (int index = 0; index < SortedLogs.length; index++) {
    printFunc("DEMO DEMO Factory logs : ${SortedLogs}");
    ValueNotifier moreInfo = ValueNotifier<bool>(false);
    FieldUsersList.add(ValueListenableBuilder(
        valueListenable: moreInfo,
        builder: (ctx, value, child) {
          return log_pop_up(SortedLogs: SortedLogs, index: index);
        }));
  }
  return FieldUsersList;
}

class FieldLogs extends StatefulWidget {
  List<Map<String, dynamic>> FieldListLogs;
  Map<String, dynamic> FieldLogsCounts;

  FieldLogs(
      {super.key, required this.FieldLogsCounts, required this.FieldListLogs});

  @override
  State<FieldLogs> createState() => _FieldLogsState();
}

class _FieldLogsState extends State<FieldLogs> {
  var sortedFieldLogs;
  int totalCount = 0;
  int successCount = 0;
  int FailureCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sortedFieldLogs = sortByStatus(widget.FieldListLogs);
      totalCount = widget.FieldLogsCounts['TotalFieldLogs'];
      successCount = widget.FieldLogsCounts['SuccessFieldLogs'];
      FailureCount = widget.FieldLogsCounts['FailureFieldLogs'];
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
          "Field Logs",
          style: TextStyle(
              fontFamily: baseFont,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: lightBg),
        ),
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: UpdatedBG,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: BoxDecoration(
                    border: Border.all(color: darkBg, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.devices,
                              color: darkBg,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              totalCount.toString(),
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: darkBg,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black, blurRadius: 0.5)
                                  ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Total Devices Flashed",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: darkBg,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 0.5)
                              ]),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: darkBg,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.device_phone_portrait,
                                    size: 22,
                                    color: SuccessCardText,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    successCount.toString(),
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: SuccessCardText,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 0.5)
                                        ]),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Successful Devices",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: SuccessCardText,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black, blurRadius: 0.5)
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.device_unknown,
                                  size: 24,
                                  color: FailureCardText,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  FailureCount.toString(),
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: FailureCardText,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 0.5)
                                      ]),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Failed Devices",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: FailureCardText,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black, blurRadius: 0.5)
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Divider(
                    color: darkBg.withOpacity(0.5),
                  )),
              ...List.generate(totalCount, (index) {
                ValueNotifier<bool> moreInfo = ValueNotifier<bool>(false);
                return ValueListenableBuilder(
                  valueListenable: moreInfo,
                  builder: (ctx, value, child) {
                    printFunc("Demo : ${sortedFieldLogs[0]}");
                    return log_pop_up(
                        SortedLogs: sortedFieldLogs, index: index);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class log_pop_up extends StatelessWidget {
  const log_pop_up({
    super.key,
    required this.SortedLogs,
    required this.index,
  });

  final List<Map<String, dynamic>> SortedLogs;
  final int index;

  @override
  Widget build(BuildContext context) {
    // printFunc("Sorted LOGS IN POP_UP : ${SortedLogs[index]}");
    return GestureDetector(
      onTap: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 0.5, color: darkBg)),
                child: Container(
                  // margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
                  height: screenSize.height / 1.3,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: SortedLogs[index]['status'] == 'Success'
                          ? SuccessCard
                          : FailureCard),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Title
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Log Info",
                                    style: TextStyle(
                                        fontFamily: baseFont,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 28,
                                        color: darkBg),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: SortedLogs[index]['status'] ==
                                                'Success'
                                            ? CupertinoColors.activeGreen
                                            : CupertinoColors.destructiveRed),
                                    child: Text(
                                      SortedLogs[index]['status'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
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
                      Expanded(
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: MaterialStateProperty.all(darkBg),
                            radius: Radius.circular(10),
                            thickness: MaterialStateProperty.all(6),
                            trackColor: MaterialStateProperty.all(Colors.white),
                            trackBorderColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                width: screenSize.width,
                                child: Column(
                                  children: [
                                    //Emp details
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Empolyee ",
                                                style: TextStyle(
                                                    color: darkBg,
                                                    fontFamily: baseFont,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 0.2)
                                                    ]),
                                              ),
                                              SizedBox(
                                                  width:
                                                      3), // spacing before line
                                              Expanded(
                                                child: Container(
                                                  height: 1,
                                                  decoration: BoxDecoration(
                                                      color: darkBg,
                                                      border: Border.all(
                                                          width: 0.8,
                                                          color: darkBg)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Name",
                                                    style: CardText(
                                                        font_Weight:
                                                            FontWeight.w500,
                                                        FontColor:
                                                            secondaryText),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      SortedLogs[index]['Name'],
                                                      style: CardText(
                                                          font_Weight:
                                                              FontWeight.w800,
                                                          size: 16,
                                                          FontColor: SortedLogs[
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  'Success'
                                                              ? SuccessCardText
                                                              : FailureCardText),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "EmpId",
                                                    style: CardText(
                                                        font_Weight:
                                                            FontWeight.w500,
                                                        FontColor:
                                                            secondaryText),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      SortedLogs[index]
                                                          ['empId'],
                                                      style: CardText(
                                                          font_Weight:
                                                              FontWeight.w800,
                                                          size: 16,
                                                          FontColor: SortedLogs[
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  'Success'
                                                              ? SuccessCardText
                                                              : FailureCardText),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Device details
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "DFU Info ",
                                                style: TextStyle(
                                                    color: darkBg,
                                                    fontFamily: baseFont,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 0.2)
                                                    ]),
                                              ),
                                              SizedBox(
                                                  width:
                                                      3), // spacing before line
                                              Expanded(
                                                child: Container(
                                                  height: 1,
                                                  decoration: BoxDecoration(
                                                      color: darkBg,
                                                      border: Border.all(
                                                          width: 0.8,
                                                          color: darkBg)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          //MacId-deviceId
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "MAC ID",
                                                    style: CardText(
                                                        font_Weight:
                                                            FontWeight.w500,
                                                        FontColor:
                                                            secondaryText),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      SortedLogs[index]
                                                          ['mac_Id'],
                                                      style: CardText(
                                                          font_Weight:
                                                              FontWeight.w800,
                                                          size: 16,
                                                          FontColor: SortedLogs[
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  'Success'
                                                              ? SuccessCardText
                                                              : FailureCardText),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Device-type",
                                                    style: CardText(
                                                        font_Weight:
                                                            FontWeight.w500,
                                                        FontColor:
                                                            secondaryText),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      SortedLogs[index]
                                                              ['DeviceID']
                                                          .toString(),
                                                      style: CardText(
                                                          font_Weight:
                                                              FontWeight.w800,
                                                          size: 16,
                                                          FontColor: SortedLogs[
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  'Success'
                                                              ? SuccessCardText
                                                              : FailureCardText),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: screenSize.width / 4.5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.computer,
                                                            size: 14,
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            "Batch",
                                                            style: CardText(
                                                                font_Weight:
                                                                    FontWeight
                                                                        .w500,
                                                                FontColor:
                                                                    secondaryText),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        SortedLogs[index]
                                                            ['Batch'],
                                                        style: CardText(
                                                            font_Weight:
                                                                FontWeight.w800,
                                                            size: 16,
                                                            FontColor: SortedLogs[
                                                                            index]
                                                                        [
                                                                        'status'] ==
                                                                    'Success'
                                                                ? SuccessCardText
                                                                : FailureCardText),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: screenSize.width / 4.5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.memory,
                                                            size: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            "Config",
                                                            style: CardText(
                                                                font_Weight:
                                                                    FontWeight
                                                                        .w500,
                                                                FontColor:
                                                                    secondaryText),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        SortedLogs[index]
                                                            ['Config'],
                                                        style: CardText(
                                                            font_Weight:
                                                                FontWeight.w800,
                                                            size: 16,
                                                            FontColor: SortedLogs[
                                                                            index]
                                                                        [
                                                                        'status'] ==
                                                                    'Success'
                                                                ? SuccessCardText
                                                                : FailureCardText),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: screenSize.width / 4.5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .folder_open_outlined,
                                                              size: 16),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            "FirmWare",
                                                            style: CardText(
                                                                font_Weight:
                                                                    FontWeight
                                                                        .w500,
                                                                FontColor:
                                                                    secondaryText),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        SortedLogs[index]
                                                            ['firm_version'],
                                                        style: CardText(
                                                            font_Weight:
                                                                FontWeight.w800,
                                                            size: 16,
                                                            FontColor: SortedLogs[
                                                                            index]
                                                                        [
                                                                        'status'] ==
                                                                    'Success'
                                                                ? SuccessCardText
                                                                : FailureCardText),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    //date and Time
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Date And Time ",
                                                style: TextStyle(
                                                    color: darkBg,
                                                    fontFamily: baseFont,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 0.2)
                                                    ]),
                                              ),
                                              SizedBox(
                                                  width:
                                                      3), // spacing before line
                                              Expanded(
                                                child: Container(
                                                  height: 1,
                                                  decoration: BoxDecoration(
                                                      color: darkBg,
                                                      border: Border.all(
                                                          width: 0.8,
                                                          color: darkBg)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            SortedLogs[index]['Date-Time'],
                                            style: CardText(
                                                font_Weight: FontWeight.w800,
                                                size: 16,
                                                FontColor: SortedLogs[index]
                                                            ['status'] ==
                                                        'Success'
                                                    ? SuccessCardText
                                                    : FailureCardText),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Reason
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Message",
                                                style: TextStyle(
                                                    color: darkBg,
                                                    fontFamily: baseFont,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 0.2)
                                                    ]),
                                              ),
                                              SizedBox(
                                                  width:
                                                      3), // spacing before line
                                              Expanded(
                                                child: Container(
                                                  height: 1,
                                                  decoration: BoxDecoration(
                                                      color: darkBg,
                                                      border: Border.all(
                                                          width: 0.8,
                                                          color: darkBg)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            SortedLogs[index]['reason'],
                                            style: CardText(
                                                font_Weight: FontWeight.w800,
                                                size: 16,
                                                FontColor: SortedLogs[index]
                                                            ['status'] ==
                                                        'Success'
                                                    ? SuccessCardText
                                                    : FailureCardText),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Btns
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(darkBg),
                              minimumSize: MaterialStateProperty.all(
                                  Size(100, 40)), // width: 80, height: 40
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: baseFont,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white,
                                      blurRadius: 0.2,
                                    )
                                  ]),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
              )
            ],
            color: SortedLogs[index]['status'] == 'Success'
                ? SuccessCard
                : FailureCard),
        height: screenSize.height / 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: screenSize.width / 5,
                  child: Column(
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
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          SortedLogs[index]["Name"] ?? '',
                          style: CardText(
                              font_Weight: FontWeight.w800,
                              size: 14,
                              FontColor:
                                  SortedLogs[index]['status'] == 'Success'
                                      ? SuccessCardText
                                      : FailureCardText),
                        ),
                      ),
                    ],
                  ),
                ),

                // Batch
                Container(
                  width: screenSize.width / 5.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Batch:",
                        style: CardText(
                          font_Weight: FontWeight.w300,
                          FontColor: secondaryText,
                        ),
                      ),
                      SizedBox(height: 3),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          SortedLogs[index]['Batch'] ?? '',
                          style: CardText(
                            font_Weight: FontWeight.w800,
                            size: 14,
                            FontColor: SortedLogs[index]['status'] == 'Success'
                                ? SuccessCardText
                                : FailureCardText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Time and Date
                Container(
                  width: screenSize.width / 4.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("Date-Time : ",
                            style: CardText(
                                font_Weight: FontWeight.w300,
                                FontColor: secondaryText)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatDateTime(SortedLogs[index]['Date-Time']),
                          style: CardText(
                              font_Weight: FontWeight.w800,
                              size: 14,
                              FontColor:
                                  SortedLogs[index]['status'] == 'Success'
                                      ? SuccessCardText
                                      : FailureCardText),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Icon(
              CupertinoIcons.chevron_right_2,
              color: darkBg,
              weight: 40,
              size: 26,
            )
          ],
        ),
      ),
    );
  }

  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('dd/MM \'T\' HH:mm').format(dateTime);
  }
}
