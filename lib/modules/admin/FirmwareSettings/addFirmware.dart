import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/services/apiCall/batch.dart';
import 'package:tracker_firmware/services/apiCall/firmware.dart';
import 'package:tracker_firmware/services/apiCall/profile.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/CustomCard.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class AddNewFirmware extends StatefulWidget {
  final int? selectedBtn;

  AddNewFirmware({this.selectedBtn});

  @override
  State<AddNewFirmware> createState() => AddNewFirmwareState();
}

class AddNewFirmwareState extends State<AddNewFirmware> {
  int ?selectedbutton;

  Map<String, dynamic> batteryList = {};
  String? firmwareFileBase64;

  Map<String, dynamic> firmwareList = {};

  // -- New user
  bool firmwareValidator = false;
  bool configValidator = false;
  bool _validateDropDown = false;

  //Password Validation

  //Config visibilty
  bool _visibleConfig = false;

  //----- Controllers for new Entry
  String? selectedFileName;
  int? selectedFileSizeInBytes;

  TextEditingController _versionCode = TextEditingController();
  TextEditingController _releaseNote = TextEditingController();
  TextEditingController _firmWareVersionName = TextEditingController();

  TextEditingController _lowerVoltage = TextEditingController();
  TextEditingController _lowerTreshold = TextEditingController();
  TextEditingController _upperTreshold = TextEditingController();
  TextEditingController _upperVoltage = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _configName = TextEditingController();
  DataController _batterySeries = DataController();
  DataController _firmware = DataController();
  DataController _config = DataController();

//--------Batch --------------
  TextEditingController _batchName = TextEditingController();
  TextEditingController _batchDescription = TextEditingController();
  bool _validateFirmware = false;
  bool _validateConfig = false;
  bool _validatedeviceType = false;
  bool batchValidator = false;
  List<Map<String, dynamic>> configList = [{}];
  List<Map<String, dynamic>> allConfigList = [{}];
  List configallList = [];

  // Controleers for New Battery
  TextEditingController _newbname = TextEditingController();
  TextEditingController _newrelaseNote = TextEditingController();
  TextEditingController _newupperThershold = TextEditingController();
  TextEditingController _newlowerThershold = TextEditingController();
  TextEditingController _newupperVoltage = TextEditingController();
  TextEditingController _newlowerVoltage = TextEditingController();
  bool batteryValidator = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectedbutton = widget.selectedBtn ?? 1;
      // batteryList = await getDeviceTypes(context);
      firmwareList = await getFirmwareList(context);
      allConfigList = await getAllConfigurationList(context);
      batteryList = {for (var item in allConfigList) item['deviceName']: item};
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Firmware",
          style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 22, color: lightBg),
        ),
        toolbarHeight: 60,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: lightBg,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
                // // elevation: ,
                // // shadowColor: Colors.black,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
                color: lightBg,
                child: Container(
                  height: size.height / 9,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //NEW Firmware
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectedbutton = 1;
                            });
                          },
                          child: Container(
                            width: selectedbutton == 1 ? size.width / 1.85 : (size.width / 2) / 2.2,
                            height: 120,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: selectedbutton == 1 ? darkBg : Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                                border: Border.all(width: 0.8, color: darkBg),
                                boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                            child: Center(
                              heightFactor: 2,
                              child: selectedbutton == 1
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.system_update_outlined,
                                            color: lightBg,
                                            size: 28,
                                          ),
                                          Text(
                                            "New Firmware",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: baseFont,
                                              fontWeight: FontWeight.w600,
                                              color: lightBg,
                                              shadows: [
                                                Shadow(offset: Offset(0.3, 0.3), color: lightBg),
                                                Shadow(offset: Offset(-0.3, 0.3), color: lightBg),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Text("Firmware",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: baseFont,
                                              fontWeight: FontWeight.w600,
                                              color: darkBg,
                                              shadows: [
                                                Shadow(offset: Offset(0.3, 0.3), color: darkBg),
                                              ])),
                                    ),
                            ),
                          )),
                      //New config
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedbutton = 2;
                          });
                        },
                        child: Container(
                          width: selectedbutton == 2 ? size.width / 2 : (size.width / 2) / 2.7,
                          height: 120,
                          decoration: BoxDecoration(
                              color: selectedbutton == 2 ? darkBg : Colors.white,
                              border: Border.all(width: 0.8, color: darkBg),
                              boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                          child: Center(
                            heightFactor: 2,
                            child: selectedbutton == 2
                                ? Center(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.handyman_outlined,
                                        color: lightBg,
                                        size: 26,
                                      ),
                                      Text(
                                        "New Config",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: baseFont,
                                          fontWeight: FontWeight.w600,
                                          color: lightBg,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0.3, 0.3),
                                              color: lightBg,
                                            ),
                                            Shadow(
                                              offset: Offset(-0.3, 0.3),
                                              color: lightBg,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                                : Text("Config",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: baseFont,
                                        fontWeight: FontWeight.w600,
                                        color: darkBg,
                                        shadows: [
                                          Shadow(offset: Offset(0.3, 0.3), color: darkBg),
                                        ])),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedbutton = 3;
                          });
                        },
                        child: Container(
                          width: selectedbutton == 3 ? size.width / 2 : (size.width / 2) / 2.7,
                          height: 120,
                          decoration: BoxDecoration(
                              color: selectedbutton == 3 ? darkBg : Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                              border: Border.all(width: 0.8, color: darkBg),
                              boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                          child: Center(
                            heightFactor: 2,
                            child: selectedbutton == 3
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.handyman_outlined,
                                          color: selectedbutton == 3 ? lightBg : darkBg,
                                          size: 26,
                                        ),
                                        Text(
                                          "New Batch",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: baseFont,
                                            fontWeight: FontWeight.w600,
                                            color: lightBg,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(0.3, 0.3),
                                                color: lightBg,
                                              ),
                                              Shadow(offset: Offset(-0.3, 0.3), color: lightBg),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text("Batch",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: baseFont,
                                        fontWeight: FontWeight.w600,
                                        color: darkBg,
                                        shadows: [
                                          Shadow(offset: Offset(0.3, 0.3), color: darkBg),
                                        ])),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            if (selectedbutton == 1)
              newFirmware(context)
            else if (selectedbutton == 2)
              newConfiguration(context)
            else
              newBatch(context)
          ],
        ),
      ),
    );
  }

  Widget newFirmware(context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // <-- radius here
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: darkBg,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Enter the details
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Center(
                  child: Text(
                    "ENTER THE DETAILS",
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: darkBg,
                        shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))]),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      //----2.0.3-----
                      // Firmware version
                      LabelText(text: "Firmware Version :"),
                      TextFeildNewUser(
                        hintText: "Enter Firmware Version ",
                        Controller: _versionCode,
                        onChanged: (value) {},
                        enable: true,
                        etext: firmwareValidator && _versionCode.text.trim().isEmpty
                            ? "Please Enter the Version"
                            : "",
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //update on bluetooth conectivity
                      // Release note
                      LabelText(text: "Release Note:"),
                      TextFeildNewUser(
                        hintText: "Release Note",
                        Controller: _releaseNote,
                        onChanged: (value) {},
                        enable: true,
                        etext: firmwareValidator && _releaseNote.text.trim().isEmpty
                            ? "Please Enter the Release Note"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      //B5 v 2.0.3
                      // Version name
                      // LabelText(text: "Version Name :"),
                      // TextFeildNewUser(
                      //   hintText: "Enter Version Name",
                      //   Controller: _firmWareVersionName,
                      //   onChanged: (value) {},
                      //   enable: true,
                      //   etext: firmwareValidator && _firmWareVersionName.text.trim().isEmpty
                      //       ? "Please Enter the Version Name"
                      //       : "",
                      // ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      LabelText(text: "Select Firmware :"),
                      Center(
                        child: Column(
                          children: [
                            PrimaryButton(
                              width: size.width / 2.5,
                              height: 40,
                              tailIcon: Icon(
                                CupertinoIcons.arrow_up_doc,
                                shadows: [Shadow(color: darkBg, blurRadius: 0.5)],
                              ),
                              text: "Select file",
                              onPress: pickPdfAndConvertToBase64,
                            ),
                            SizedBox(height: 10),
                            if (selectedFileName != null && selectedFileSizeInBytes != null)
                              Text(
                                "Selected File: $selectedFileName (${(selectedFileSizeInBytes! / 1024).toStringAsFixed(2)} KB)",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: baseFont,
                                  color: darkBg,
                                ),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 8,
                      ),
                    ],
                  )),

              SizedBox(
                height: 10,
              ),
              // add firmware btn

              // upload btn
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: manageUserBtn(
                    text: "Upload Firmware",
                    onPress: () async {
                      ValidateFirmwareFields();

                      if (!firmwareValidator && firmwareFileBase64 != null && firmwareFileBase64 != "") {
                        printFunc("Inside IF COND");
                        if (await addNewFirmware(context,
                            versionName: '${_firmWareVersionName.text}',
                            versionCode: '${_versionCode.text}',
                            releaseNote: '${_releaseNote.text}',
                            // firmwareFile: '$firmwareFileBase64'))
                            firmwareFile: '$selectedFileName')) {
                          clearFirmware();
                          // Navigator.of(context,rootNavigator: true).pop();//(MaterialPageRoute(builder: (_) => AdminMain()));
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newConfiguration(context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // <-- radius here
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: darkBg,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Center(
                  child: Text(
                    "ENTER THE DETAILS",
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: darkBg,
                        shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))]),
                  ),
                ),
              ),
              // Text fields
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      //----2.0.3-----
                      // ---- Config name ------
                      LabelText(text: "Config Name :"),
                      TextFeildNewUser(
                        hintText: "Enter Config Name  ",
                        Controller: _configName,
                        onChanged: (value) {},
                        enable: true,
                        etext: configValidator && _configName.text.trim().isEmpty
                            ? "Please Enter the Config Name"
                            : "",
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // ----- Upper threshold -------
                      const LabelText(text: "Upper Threshold :"),
                      TextFeildNewUser(
                        hintText: "Enter Upper Threshold",
                        inputFormatters: [OneDecimalInputFormatter()],
                        type: TextInputType.number,
                        Controller: _upperTreshold,
                        onChanged: (value) {},
                        enable: true,
                        etext: configValidator && _upperTreshold.text.trim().isEmpty
                            ? "Please Enter the Upper Threshold"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // -------- Upper Voltage--------
                      const LabelText(text: "Upper Voltage :"),
                      TextFeildNewUser(
                        hintText: "Enter Upper Voltage",
                        inputFormatters: [OneDecimalInputFormatter()],
                        // Correct
                        type: TextInputType.number,

                        Controller: _upperVoltage,
                        onChanged: (value) {},
                        enable: true,
                        etext: configValidator && _upperVoltage.text.trim().isEmpty
                            ? "Please Enter the Upper Voltage"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // ---------- Lower Threshold ----------
                      const LabelText(text: "Lower Threshold :"),
                      TextFeildNewUser(
                        hintText: "Enter Lower Threshold",
                        inputFormatters: [OneDecimalInputFormatter()],
                        type: TextInputType.number,
                        Controller: _lowerTreshold,
                        onChanged: (value) {},
                        enable: true,
                        etext: configValidator && _lowerTreshold.text.trim().isEmpty
                            ? "Please Enter the Lower Threshold"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // ---------- Lower Voltage -------
                      const LabelText(text: "Lower Voltage :"),
                      TextFeildNewUser(
                        hintText: "Enter Lower Voltage",
                        inputFormatters: [OneDecimalInputFormatter()],
                        type: TextInputType.number,
                        Controller: _lowerVoltage,
                        onChanged: (value) {},
                        enable: true,
                        etext: configValidator && _lowerVoltage.text.trim().isEmpty
                            ? "Please Enter the Lower Voltage"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ), // ---- Description -----
                      LabelText(text: "Description :"),
                      TextFeildNewUser(
                        hintText: "Description",
                        Controller: _description,
                        onChanged: (value) {},
                        enable: true,
                        etext: configValidator && _description.text.trim().isEmpty
                            ? "Please Enter the Description"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      //----Battery series---- [DROPDOWN]
                      GestureDetector(
                        child: PrimeryDropDownButton(
                          isEnabled: true,
                          tail: ErrorContainer(
                              show: _validateDropDown, errorMsg: "Please Select the Battery Series"),
                          mainText: "Select Battery Series",
                          text: _batterySeries.Text != "" ? _batterySeries.getText : "Battery Series",
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: darkBg,
                          ),
                          press: () async {
                            await BottomSheet_Widget(
                                context, [
                              MapListItemBuilder(
                                listItems: batteryList,
                                press: () {},
                                selected: _batterySeries,
                                BtnEnable: true,
                                btnTitle: "ADD BATTERY SERIES ",
                                btnFunction: () async{
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
                                                          ? "Please Enter the Phone Number"
                                                          : "",
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    // Relase Note
                                                    LabelText(text: "Relase Date"),
                                                    TextFeildNewUser(
                                                      hintText: "Enter Relase Date",
                                                      Controller: _newrelaseNote,
                                                      onChanged: (value) {},
                                                      enable: true,
                                                      etext: batteryValidator && _newrelaseNote.text.trim().isEmpty
                                                          ? "Please Enter the Phone Number"
                                                          : "",
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    // Upper thershold
                                                    LabelText(text: "Upper Thershold"),
                                                    TextFeildNewUser(
                                                      hintText: "Enter Upper Thershold",
                                                      Controller: _newupperThershold,
                                                      onChanged: (value) {},
                                                      enable: true,
                                                      etext: batteryValidator && _newupperThershold.text.trim().isEmpty
                                                          ? "Please Enter the Phone Number"
                                                          : "",
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    // Lower Temp
                                                    LabelText(text: "Lower Thershold"),
                                                    TextFeildNewUser(
                                                      hintText: "Enter Lower Thershold",
                                                      Controller: _newlowerThershold,
                                                      onChanged: (value) {},
                                                      enable: true,
                                                      etext: batteryValidator && _newlowerThershold.text.trim().isEmpty
                                                          ? "Please Enter the Phone Number"
                                                          : "",
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    // Upper Voltage
                                                    LabelText(text: "Upper Voltage"),
                                                    TextFeildNewUser(
                                                      hintText: "Enter Upper Voltage",
                                                      Controller: _upperVoltage,
                                                      onChanged: (value) {},
                                                      enable: true,
                                                      etext: batteryValidator && _upperVoltage.text.trim().isEmpty
                                                          ? "Please Enter the Phone Number"
                                                          : "",
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    // Lower Voltage
                                                    LabelText(text: "Lower Voltage"),
                                                    TextFeildNewUser(
                                                      hintText: "Enter Lower Voltage",
                                                      Controller: _lowerVoltage,
                                                      onChanged: (value) {},
                                                      enable: true,
                                                      etext: batteryValidator && _lowerVoltage.text.trim().isEmpty
                                                          ? "Please Enter the Phone Number"
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
                                                  onPress: () {
                                                    printFunc("DEMODEMO");
                                                    printFunc(batteryValidator);
                                                    printFunc(_newbname.text.trim().isEmpty);
                                                    ValidateBatteryFields();
                                                    setState(() {});
                                                  })
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ]);

                                },
                              )
                            ]);
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
              //Upload btn
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: manageUserBtn(
                    text: "Upload Config",
                    onPress: () async {
                      ValidateConfigFields();
                      validateDropDown(_batterySeries);
                      if (!configValidator && !_validateDropDown) {
                        printFunc("Inside IF COND");
                        if (await addNewConfig(
                          context,
                          configName: _configName.text.trim(),
                          upperThreshold: _upperTreshold.text.trim(),
                          upperVoltage: _upperVoltage.text.trim(),
                          lowerThreshold: _lowerTreshold.text.trim(),
                          lowerVoltage: _lowerVoltage.text.trim(),
                          description: _description.text.trim(),
                          batterySeriesId: (_batterySeries.obj["id"]).toString(),
                        )) {
                          clearConfig();
                          // Navigator.of(context,rootNavigator: true).pop();//(MaterialPageRoute(builder: (_) => AdminMain()));
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newBatch(context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // <-- radius here
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: darkBg,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ------ Title -----
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Center(
                  child: Text(
                    "ENTER THE DETAILS",
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: darkBg,
                        shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))]),
                  ),
                ),
              ),
              // ----- Text fields ------
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      //----2.0.3-----
                      // ------ Batch name -----
                      LabelText(text: "Batch Name :"),
                      TextFeildNewUser(
                        hintText: "Enter Batch Name  ",
                        Controller: _batchName,
                        onChanged: (value) {},
                        enable: true,
                        etext: batchValidator && _batchName.text.trim().isEmpty
                            ? "Please Enter the batch Name"
                            : "",
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //update on bluetooth conectivity
                      // ------- Description --------
                      LabelText(text: "Description :"),
                      TextFeildNewUser(
                        hintText: "Description",
                        Controller: _batchDescription,
                        onChanged: (value) {},
                        enable: true,
                        etext: batchValidator && _batchDescription.text.trim().isEmpty
                            ? "Please Enter the Description"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // -------- Firmware[DropDown] ---------
                      GestureDetector(
                        child: PrimeryDropDownButton(
                          isEnabled: true,
                          tail:
                              ErrorContainer(show: _validateFirmware, errorMsg: "Please Select the firmware"),
                          mainText: "Firmware",
                          text: _firmware.Text != "" ? _firmware.getText : "Select the firmware",
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: darkBg,
                          ),
                          press: () async {
                            await BottomSheet_Widget(context, [
                              MapListItemBuilder(
                                listItems: firmwareList,
                                press: () {},
                                selected: _firmware,
                              )
                            ]);
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // ------ Battery series [DropDown] -----
                      GestureDetector(
                        child: PrimeryDropDownButton(
                          isEnabled: true,
                          tail: ErrorContainer(
                              show: _validatedeviceType, errorMsg: "Please Select the Battery Series"),
                          mainText: "Select Battery Series",
                          text: _batterySeries.Text != "" ? _batterySeries.getText : "Battery Series",
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: darkBg,
                          ),
                          press: () async {
                            _config.cleardata();
                            await BottomSheet_Widget(context, [
                              MapListItemBuilder(
                                listItems: batteryList,
                                press: () {},
                                selected: _batterySeries,
                              )
                            ]);
                            setState(() {});
                            setState(() {
                              _visibleConfig = true;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // ----- Config[DropDown] -----
                      Visibility(
                        visible: _visibleConfig,
                        child: GestureDetector(
                          child: PrimeryDropDownButton(
                            isEnabled: true,
                            tail: ErrorContainer(show: _validateConfig, errorMsg: "Please Select the Config"),
                            mainText: "Config",
                            text: _config.Text != "" ? _config.getText : "select Config",
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: darkBg,
                            ),
                            press: () async {
                              final selectedBatteryConfigList = _batterySeries.obj['configuration'];

                              Map<String, Map<String, dynamic>> deviceMap = {
                                for (var config in selectedBatteryConfigList)
                                  if (config['active'].toString().toUpperCase() == 'Y') config['name']: config
                              };

                              await BottomSheet_Widget(context, [
                                MapListItemBuilder(
                                  listItems: deviceMap,
                                  press: () {},
                                  selected: _config,
                                )
                              ]);
                              setState(() {});
                              printFunc(
                                  "DEMO DATACONTROLER \n  battery ${_batterySeries.getText} \n${_batterySeries.obj["id"]}\n firmware ${_firmware.getText}\n${_firmware.getobj} \n config ${_config.getText}\n${_config.getobj}");
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
              // ----- Upload btn
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: manageUserBtn(
                    text: "Upload Batch",
                    onPress: () async {
                      ValidateBatchFields();

                      validateBatchDropDown(
                          _batterySeries, (val) => setState(() => _validatedeviceType = val));
                      validateBatchDropDown(_config, (val) => setState(() => _validatedeviceType = val));
                      validateBatchDropDown(_firmware, (val) => setState(() => _validateFirmware = val));
                      if (!batchValidator &&
                          !_validatedeviceType &&
                          !_validatedeviceType &&
                          !_validateFirmware) {
                        printFunc("Inside IF COND");
                        if (await addNewBatch(
                          context,
                          config: _config.obj["id"].toString().trim(),
                          firmware: _firmware.obj["id"].toString().trim(),
                          batchName: _batchDescription.text.trim(),
                          description: _batchDescription.text.trim(),
                        )) {
                          clearBatch();
                          // Navigator.of(context,rootNavigator: true).pop();//(MaterialPageRoute(builder: (_) => AdminMain()));
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ValidateFirmwareFields() {
    final Controllers = [
      _versionCode,
      _releaseNote,
      // _firmWareVersionName,
    ];

    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);
    setState(() {
      firmwareValidator = hasEmpty;
    });
    printFunc("firmware validatot : $firmwareValidator");
    // Future Delayed

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        firmwareValidator = false;
      });
    });
  }

  void ValidateBatteryFields() {
    final Controllers = [
      _newbname,
      _newrelaseNote,
      _newupperThershold,
      _newupperVoltage,
      _newlowerThershold,
      _newlowerVoltage,
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

  void ValidateConfigFields() {
    final Controllers = [
      _configName,
      _upperTreshold,
      _upperVoltage,
      _lowerTreshold,
      _lowerVoltage,
      _description,
    ];

    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);
    setState(() {
      configValidator = hasEmpty;
    });

    printFunc("firmwareValidator: $configValidator");

    // Reset validation flags after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        configValidator = false;
        printFunc("firmwareValidator seconds: 3 : $configValidator");
      });
    });
  }

  void ValidateBatchFields() {
    final Controllers = [
      _batchName,
      _batchDescription,
    ];

    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);
    setState(() {
      batchValidator = hasEmpty;
    });

    // Reset validation flags after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        batchValidator = false;
      });
    });
  }
  
  
  void validateDropDown(DataController variable) {
    if (variable.getText == "") {
      setState(() {
        _validateDropDown = true;
      });
    } else {
      _validateDropDown = false;
    }

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _validateDropDown = false;
      });
    });
  }

  void validateBatchDropDown(DataController variable, void Function(bool) setValidator) {
    if (variable.getText == "") {
      setValidator(true);
    } else {
      setValidator(false);
    }

    Future.delayed(Duration(seconds: 3), () {
      setValidator(false);
    });
  }

  Future<void> pickPdfAndConvertToBase64() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', "jpeg"],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      List<int> fileBytes = await file.readAsBytes();

      setState(() {
        firmwareFileBase64 = base64Encode(fileBytes);
        selectedFileName = result.files.single.name;
        selectedFileSizeInBytes = fileBytes.length;
      });
      print('PDF converted to Base64:\n$firmwareFileBase64');
    } else {
      // User canceled the picker
      print('No file selected.');
    }
  }

  void clearFirmware() {
    _versionCode.clear();
    _firmWareVersionName.clear();
    _releaseNote.clear();
    firmwareFileBase64 = "";
    selectedFileName = null;
    selectedFileSizeInBytes = null;
  }

  void clearConfig() {
    // Clear text controllers
    _configName.clear();
    _upperTreshold.clear();
    _upperVoltage.clear();
    _lowerTreshold.clear();
    _lowerVoltage.clear();
    _description.clear();

    // Clear dropdown
    _batterySeries.cleardata();

    // Clear validation flags
    _validateDropDown = false;
    configValidator = false;

    // Optional: Force UI update
    setState(() {});
  }

  void clearBatch() {
    // Clear text controllers
    _config.cleardata();
    _batterySeries.cleardata();
    _firmware.cleardata();
    _batchName.clear();
    _batchDescription.clear();
    _validateDropDown = false;
    configValidator = false;

    // Optional: Force UI update
    setState(() {});
  }


}
