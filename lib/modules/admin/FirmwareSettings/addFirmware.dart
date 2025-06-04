import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/admin_main.dart';
import 'package:tracker_firmware/services/apiCall/firmware.dart';
import 'package:tracker_firmware/services/apiCall/profile.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/CustomCard.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class AddNewFirmware extends StatefulWidget {
  @override
  State<AddNewFirmware> createState() => AddNewFirmwareState();
}

class AddNewFirmwareState extends State<AddNewFirmware> {
  int selectedbutton = 1;

  Map<String, dynamic> batteryList = {};
  String? fileBase64;

  Map<String, dynamic> firmwareList = {};

  // -- New user
  bool firmwareValidator = false;
  bool _validateDropDown = false;

  //Password Validation
  bool _passwordNotSame = false;

  //Profile visibilty
  bool _visibleProfile = false;

  //----- Controllers for new Entry
  TextEditingController _versionCode = TextEditingController();
  TextEditingController _releaseNote = TextEditingController();
  TextEditingController _firmWareVersionName = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repassword = TextEditingController();
  TextEditingController _lowerVoltage = TextEditingController();
  TextEditingController _lowerTreshold = TextEditingController();
  TextEditingController _upperTreshold = TextEditingController();
  TextEditingController _upperVoltage = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _profileName = TextEditingController();
  DataController _batterySeries = DataController();
  DataController _firmware = DataController();
  DataController _profile = DataController();

  //------- Controllers for Editing Entry
  TextEditingController _name01 = TextEditingController();
  TextEditingController _empRegId01 = TextEditingController();
  TextEditingController _email01 = TextEditingController();
  TextEditingController _contact01 = TextEditingController();
  DataController designation01 = DataController();

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
        },
        "B9": {
          "id": 2,
          "name": "B9",
          "priority": 2,
        },
        "B12": {"id": 3, "name": "B12", "priority": 3},
      };
      firmwareList = await getFirmwareList(context);
      // profileList = await getProfileByID(context,);
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
                                      child: Text(
                                        "Firmware",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: baseFont,
                                          fontWeight: FontWeight.w600,
                                          color: darkBg,
                                          shadows: [
                                            Shadow(offset: Offset(0.3, 0.3), color: darkBg),
                                            Shadow(offset: Offset(-0.3, 0.3), color: darkBg),
                                          ],
                                        ),
                                      ),
                                    )),
                        ),
                      ),
                      //New profile
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
                                    ),
                                  )
                                : Text(
                                    "Config",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: baseFont,
                                      fontWeight: FontWeight.w600,
                                      color: darkBg,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0.3, 0.3),
                                          color: darkBg,
                                        ),
                                        Shadow(
                                          offset: Offset(-0.3, 0.3),
                                          color: darkBg,
                                        ),
                                      ],
                                    ),
                                  ),
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
                                : Text(
                                    "Batch",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: baseFont,
                                      fontWeight: FontWeight.w600,
                                      color: darkBg,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0.3, 0.3),
                                          color: darkBg,
                                        ),
                                        Shadow(offset: Offset(-0.3, 0.3), color: darkBg),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            if (selectedbutton == 1)
              newFirmware(context)
            else if (selectedbutton == 2)
              newService(context)
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
                      LabelText(text: "Version Name :"),
                      TextFeildNewUser(
                        hintText: "Enter Version Name",
                        Controller: _firmWareVersionName,
                        onChanged: (value) {},
                        enable: true,
                        etext: firmwareValidator && _firmWareVersionName.text.trim().isEmpty
                            ? "Please Enter the Version Name"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      //----Battery series---- [DROPDOWN]
                      /*
                      GestureDetector(
                        child: PrimeryDropDownButton(
                          isEnabled: true,
                          tail: ErrorContainer(
                              show: _validateDropDown,
                              errorMsg: "Please Select the Battery Series"),
                          mainText: "Select Battery Series",
                          text: _batterySeries.Text != ""
                              ? _batterySeries.getText
                              : "Battery Series",
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: darkBg,
                          ),
                          press: () async {
                            await BottomSheet_Widget(context, [
                              MapListItemBuilder(
                                listItems: batteryList,
                                press: () {},
                                selected: _batterySeries,
                              )
                            ]);
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                       */
                    ],
                  )),

              SizedBox(
                height: 20,
              ),
              // add firmware btn
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: PrimaryButton(
                  width: size.width / 2.5,
                  height: 40,
                  tailIcon: Icon(CupertinoIcons.arrow_up_doc,
                      // color: darkBg,
                      shadows: [Shadow(color: darkBg, blurRadius: 0.5)]),
                  text: "ADD Firmware",
                  onPress: pickPdfAndConvertToBase64,
                ),
              ),
              // upload btn
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: manageUserBtn(
                    text: "Upload Firmware",
                    onPress: () {
                      ValidateFirmwareFields();
                      validateDropDown(_batterySeries);
                      validatePassword();

                      if (!firmwareValidator && !_validateDropDown) {
                        printFunc("Inside IF COND");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  color: lightBg,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'User Added Successfully!!',
                                  style: TextStyle(
                                    color: lightBg,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: baseFont,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: darkBg,
                            elevation: 5,
                            margin: EdgeInsets.all(16),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminMain()));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newService(context) {
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
                      // ---- Profile name ------
                      LabelText(text: "Profile Name :"),
                      TextFeildNewUser(
                        hintText: "Enter Profile Name  ",
                        Controller: _profileName,
                        onChanged: (value) {},
                        enable: true,
                        etext: firmwareValidator && _profileName.text.trim().isEmpty
                            ? "Please Enter the Profile Name"
                            : "",
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //update on bluetooth conectivity
                      // ---- Description -----
                      LabelText(text: "Description :"),
                      TextFeildNewUser(
                        hintText: "Description",
                        Controller: _description,
                        onChanged: (value) {},
                        enable: true,
                        etext: firmwareValidator && _description.text.trim().isEmpty
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
                            await BottomSheet_Widget(context, [
                              MapListItemBuilder(
                                listItems: batteryList,
                                press: () {},
                                selected: _batterySeries,
                              )
                            ]);
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
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
                        etext: firmwareValidator && _upperTreshold.text.trim().isEmpty
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
                        etext: firmwareValidator && _upperVoltage.text.trim().isEmpty
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
                        etext: firmwareValidator && _lowerTreshold.text.trim().isEmpty
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
                        etext: firmwareValidator && _lowerVoltage.text.trim().isEmpty
                            ? "Please Enter the Lower Voltage"
                            : "",
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
              //Upload btn
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: manageUserBtn(text: "Upload Config", onPress: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> profileList = [{}];
  List profileallList = [];

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
                        Controller: _profileName,
                        onChanged: (value) {},
                        enable: true,
                        etext: firmwareValidator && _profileName.text.trim().isEmpty
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
                        Controller: _description,
                        onChanged: (value) {},
                        enable: true,
                        etext: firmwareValidator && _description.text.trim().isEmpty
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
                              ErrorContainer(show: _validateDropDown, errorMsg: "Please Select the firmware"),
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
                              show: _validateDropDown, errorMsg: "Please Select the Battery Series"),
                          mainText: "Select Battery Series",
                          text: _batterySeries.Text != "" ? _batterySeries.getText : "Battery Series",
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: darkBg,
                          ),
                          press: () async {
                            _profile.cleardata();
                            await BottomSheet_Widget(context, [
                              MapListItemBuilder(
                                listItems: batteryList,
                                press: () {},
                                selected: _batterySeries,
                              )
                            ]);
                            setState(() {});
                            setState(() {
                              _visibleProfile = true;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // ----- Profile[DropDown] -----
                      Visibility(
                        visible: _visibleProfile,
                        child: GestureDetector(
                          child: PrimeryDropDownButton(
                            isEnabled: true,
                            tail: ErrorContainer(
                                show: _validateDropDown, errorMsg: "Please Select the Profile"),
                            mainText: "Profile",
                            text: _profile.Text != "" ? _profile.getText : "select Profile",
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: darkBg,
                            ),
                            press: () async {
                              profileList =
                                  await getProfileByID(context, _batterySeries.obj["id"].toString());
                              printFunc("DEMO DEMO DEMO : ${profileList}");
                              Map<String, Map<String, dynamic>> deviceMap = {
                                for (var item in profileList) item['name']: item
                              };

                              await BottomSheet_Widget(context, [
                                MapListItemBuilder(
                                  listItems: deviceMap,
                                  press: () {},
                                  selected: _profile,
                                )
                              ]);
                              setState(() {});
                              printFunc(
                                  "DEMO DATACONTROLER \n  battery ${_batterySeries.getText} \n${_batterySeries.obj["id"]}\n firmware ${_firmware.getText}\n${_firmware.getobj} \n profile ${_profile.getText}\n${_profile.getobj}");
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
                child: manageUserBtn(text: "Upload Batch", onPress: () {}),
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
      _firmWareVersionName,
    ];

    printFunc(
        "_versionCode : ${_versionCode.text}\n _versionCode : ${_versionCode.text}\n _firmWareVersionName : ${_firmWareVersionName.text}\n Contact : ${_contact.text}\n password : ${_password.text} \nRePassword : ${_repassword.text}");
    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);
    setState(() {
      firmwareValidator = hasEmpty;
    });

    // Future Delayed

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        firmwareValidator = false;
      });
    });
  }

  void validatePassword() {
    print("Demo validatePassword ${_passwordNotSame}");
    if (_password.text != _repassword.text!) {
      setState(() {
        _passwordNotSame = true;
      });
    }
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _passwordNotSame = false;
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

  Future<void> pickPdfAndConvertToBase64() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', "jpeg"],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      List<int> fileBytes = await file.readAsBytes();
      setState(() {
        fileBase64 = base64Encode(fileBytes);
      });

      print('PDF converted to Base64:\n$fileBase64');
    } else {
      // User canceled the picker
      print('No file selected.');
    }
  }
}
