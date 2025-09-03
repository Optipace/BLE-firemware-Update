import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/Profile/main_profile.dart';
import 'package:tracker_firmware/modules/admin/ListOverview/listOverview.dart';
import 'package:tracker_firmware/modules/admin/api/api.dart';
import 'package:tracker_firmware/modules/admin/device_info.dart';
import 'package:tracker_firmware/modules/admin/log/admin_logs.dart';
import 'package:tracker_firmware/modules/admin/newUser/adminNewUser.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';
import 'package:tracker_firmware/widgets/textFields.dart';
import '../../services/apiCall/designation.dart';
import '../../services/apiCall/deviceType.dart';
import 'FirmwareSettings/addFirmware.dart';

class AdminMain extends StatefulWidget {
  @override
  State<AdminMain> createState() => AdminMainState();
}

class AdminMainState extends State<AdminMain> {
  // Controleers for New Battery
  TextEditingController _bname = TextEditingController();
  TextEditingController _relaseNote = TextEditingController();
  TextEditingController _upperThershold = TextEditingController();
  TextEditingController _lowerThershold = TextEditingController();
  TextEditingController _upperVoltage = TextEditingController();
  TextEditingController _lowerVoltage = TextEditingController();

  // Controleers for New device
  TextEditingController _newuuid = TextEditingController();
  TextEditingController _newmodel = TextEditingController();
  TextEditingController _newbrand = TextEditingController();
  bool deviceValidator = false;

  // Controllers for New Client
  TextEditingController _clientName = TextEditingController();
  TextEditingController _clientAddress = TextEditingController();
  TextEditingController _clientPhno = TextEditingController();
  TextEditingController _clientEmail = TextEditingController();
  TextEditingController _clientContactPerson = TextEditingController();
  TextEditingController _clientDiscription = TextEditingController();
  TextEditingController _clientCode = TextEditingController();
  bool clientValidator = false;

  // Controllers for New desgination
  TextEditingController _newDesgination = TextEditingController();
  TextEditingController _designationPriority = TextEditingController();
  bool designationValidator = false;

  // Controleers for New Battery
  TextEditingController _newbname = TextEditingController();
  TextEditingController _batteryDescription = TextEditingController();






  bool batteryValidator = false;

  bool apicall = false;

  bool validateUser = false;
  bool pluss = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: 'ADMIN\nDASH-BOARD',
        userProfile: true,

        sliderChild: Column(
          children: [
            //Add Device
            /*Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () async{
                      await BottomSheet_Widget(context, color: lightBg, [
                        StatefulBuilder(builder:
                            (thisLowerContext, checkListDeviceState) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(thisLowerContext).viewInsets.bottom,
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                height: screenSize.height / 1.5,
                                width: screenSize.width,
                                color: lightBg,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SingleChildScrollView(
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Device Details!",
                                                style: TextStyle(
                                                    fontFamily: baseFont,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 28,
                                                    color: darkBg,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 0.5,
                                                          offset: Offset(0.5, 0.5))
                                                    ]),
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap :(){
                                                      checkListDeviceState(() {
                                                        _newuuid.text = sharedPreferences.getString("UUID")!;
                                                        _newbrand.text = sharedPreferences.getString("deviceBrand")!;
                                                        _newmodel.text = sharedPreferences.getString("deviceModel")!;
                                                      });
                                                      printFunc( "\n version : ${sharedPreferences.getString("osVersion")}"
                                                          "\n model : ${sharedPreferences.getString("deviceModel")}"
                                                          "\n deviceBrand : ${sharedPreferences.getString("deviceBrand")}");
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.black,width: 0.3),
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: darkBg
                                                      ),
                                                      child:  Column(
                                                        children: [
                                                          Text("Register This",style: TextStyle(color: Colors.white),),
                                                          Text("Device",style: TextStyle(color: Colors.white),),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              )
                                            ],
                                          ),
                                          margin: EdgeInsets.fromLTRB(5, 0, 15,0),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // UUID
                                            LabelText(text: "UUID :"),
                                            TextFeildNewUser(
                                              hintText: "Enter Device UUID ",
                                              Controller: _newuuid,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: deviceValidator &&
                                                  _newuuid.text
                                                      .trim()
                                                      .isEmpty
                                                  ? "Please Enter Device UUID"
                                                  : "",
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            // Model
                                            LabelText(text: "Model"),
                                            TextFeildNewUser(
                                              hintText: "Enter Device Model",
                                              Controller: _newmodel,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: deviceValidator &&
                                                  _newmodel.text
                                                      .trim()
                                                      .isEmpty
                                                  ? "Please Enter Device Model"
                                                  : "",
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            // Brand
                                            LabelText(text: "Brand"),
                                            TextFeildNewUser(
                                              hintText: "Enter Device Brand",
                                              Controller: _newbrand,
                                              onChanged: (value) {},
                                              enable: true,
                                              etext: deviceValidator &&
                                                  _newbrand.text
                                                      .trim()
                                                      .isEmpty
                                                  ? "Please Enter Device Brand"
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
                                          text: "Register Device",
                                          onPress: () async {
                                            checkListDeviceState(() {
                                              ValidateDeviceFields();
                                            });
                                            if(deviceValidator == false){
                                              checkListDeviceState(() {
                                                apicall =true;
                                              });
                                              if(apicall){
                                                Navigator.of(context).pop();
                                                ShowSnackBarMessage(context, 'Device Registerd successfully.', true);
                                                _newuuid.clear();
                                                _newbrand.clear();
                                                _newmodel.clear();
                                                setState(() {});
                                              }
                                            }
                                            setState(() {});
                                          }
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ]);
                      setState(() {});
                      printFunc("Device Information : \n"
                          "uuid :  ${sharedPreferences.getString("UUID")}"
                          "\n version : ${sharedPreferences.getString("osVersion")}"
                          "\n model : ${sharedPreferences.getString("deviceModel")}"
                          "\n deviceBrand : ${sharedPreferences.getString("deviceBrand")}");
                    },
                    child: Text(
                      "Add Device",
                      style: TextStyle(
                          fontFamily: baseFont,
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 0.3,
                              offset: Offset(0.5, 0.4),
                            )
                          ]),
                    ),
                  ),
                ),
                SizedBox(height: 15,)
              ],
            ), */
            //Add Client
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () async {
                      // Add Client
                      clearClient();
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                        true, // important for keyboard handling
                        backgroundColor: lightBg,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(
                              top: Radius
                                  .circular(
                                  10.0)),
                        ),
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (thisLowerContext,
                                checkClientState) {
                              return Padding(
                                padding:
                                EdgeInsets.only(
                                  bottom: MediaQuery.of(
                                      thisLowerContext)
                                      .viewInsets
                                      .bottom,
                                ),
                                child: Container(
                                  height: screenSize
                                      .height /
                                      1.5,
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .vertical(
                                      top: Radius
                                          .circular(
                                          10.0),
                                    ),
                                  ),
                                  child:
                                  SingleChildScrollView(
                                    child:
                                    Container(
                                      width:
                                      screenSize
                                          .width,
                                      color:
                                      lightBg,
                                      padding: const EdgeInsets
                                          .symmetric(
                                          vertical:
                                          20,
                                          horizontal:
                                          16),
                                      margin: EdgeInsets
                                          .symmetric(
                                          vertical:
                                          15),
                                      child: Column(
                                        mainAxisSize:
                                        MainAxisSize
                                            .min, // wrap content
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Center(
                                            child:
                                            Text(
                                              "Enter Client Details!",
                                              style:
                                              TextStyle(
                                                fontFamily:
                                                baseFont,
                                                fontWeight:
                                                FontWeight.w800,
                                                fontSize:
                                                28,
                                                color:
                                                darkBg,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 0.5,
                                                    offset: Offset(0.5, 0.5),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              height:
                                              20),
                                          LabelText(
                                              text:
                                              "Client Name :"),
                                          TextFeildNewUser(
                                            hintText:
                                            "Enter Client Name",
                                            Controller:
                                            _clientName,
                                            onChanged:
                                                (value) {},
                                            enable:
                                            true,
                                            etext: clientValidator &&
                                                _clientName.text.trim().isEmpty
                                                ? "Please Enter Client Name"
                                                : "",
                                          ),
                                          const SizedBox(
                                              height:
                                              8),
                                          LabelText(
                                              text:
                                              "Client Address"),
                                          TextFeildNewUser(
                                            hintText:
                                            "Enter Client Address",
                                            Controller:
                                            _clientAddress,
                                            onChanged:
                                                (value) {},
                                            enable:
                                            true,
                                            etext: clientValidator &&
                                                _clientAddress.text.trim().isEmpty
                                                ? "Please Enter Client Address"
                                                : "",
                                          ),
                                          const SizedBox(
                                              height:
                                              8),
                                          LabelText(
                                              text:
                                              "Client Phone-Number"),
                                          TextFeildNewUser(
                                            hintText:
                                            "Enter Client Phone-Number",
                                            Controller:
                                            _clientPhno,
                                            type: TextInputType.number,
                                            onChanged:
                                                (value) {},
                                            maxLength: 10,

                                            enable:
                                            true,
                                            etext: clientValidator &&
                                                _clientPhno.text.trim().isEmpty
                                                ? "Please Enter Client Phone-Number"
                                                : "",
                                          ),
                                          const SizedBox(
                                              height:
                                              8),
                                          LabelText(
                                              text:
                                              "Client E-mail"),
                                          TextFeildNewUser(
                                            hintText:
                                            "Enter Client E-mail",
                                            Controller:
                                            _clientEmail,
                                            onChanged:
                                                (value) {},
                                            enable:
                                            true,
                                            etext: clientValidator &&
                                                _clientEmail.text.trim().isEmpty
                                                ? "Please Enter Client E-mail"
                                                : "",
                                          ),
                                          const SizedBox(
                                              height:
                                              8),
                                          LabelText(
                                              text:
                                              "Client's Contact Person"),
                                          TextFeildNewUser(
                                            hintText:
                                            "Enter Client's Contact Person",
                                            Controller:
                                            _clientContactPerson,
                                            onChanged:
                                                (value) {},
                                            maxLength: 10,
                                            enable:
                                            true,
                                            etext: clientValidator &&
                                                _clientContactPerson.text.trim().isEmpty
                                                ? "Please Enter Client's Contact Person"
                                                : "",
                                          ),
                                          const SizedBox(
                                              height:
                                              8),
                                          LabelText(
                                              text:
                                              "Description"),
                                          TextFeildNewUser(
                                            hintText:
                                            "Enter Description",
                                            Controller:
                                            _clientDiscription,
                                            onChanged:
                                                (value) {},
                                            enable:
                                            true,
                                            etext: clientValidator &&
                                                _clientDiscription.text.trim().isEmpty
                                                ? "Please Enter Description"
                                                : "",
                                          ),
                                          const SizedBox(
                                              height:
                                              8),
                                          LabelText(
                                              text:
                                              "Client's code"),
                                          TextFeildNewUser(
                                            hintText:
                                            "Enter Client's code",
                                            Controller:
                                            _clientCode,
                                            type: TextInputType.number,
                                            onChanged:
                                                (value) {},
                                            enable:
                                            true,
                                            etext: clientValidator &&
                                                _clientCode.text.trim().isEmpty
                                                ? "Please Enter Client's code"
                                                : "",
                                          ),
                                          const SizedBox(
                                              height:
                                              20),
                                          Center(
                                            child:
                                            manageUserBtn(
                                              text:
                                              "Add Client",
                                              onPress:
                                                  () async {
                                                checkClientState(() {
                                                  ValidateClientFields();
                                                });
                                                if (!clientValidator) {
                                                  if (await saveClient(
                                                    context,
                                                    name: _clientName.text.trim(),
                                                    address: _clientAddress.text.trim(),
                                                    contactNumber: _clientPhno.text.trim(),
                                                    email: _clientEmail.text.trim(),
                                                    contactPerson: _clientContactPerson.text.trim(),
                                                    discription: _clientDiscription.text.trim(),
                                                    code: _clientCode.text.trim(),
                                                  )) {
                                                    clearClient();
                                                    Navigator.of(context).pop();
                                                  }
                                                }
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.person_add,size: 22,color: Colors.white,shadows: [Shadow(
                          color: Colors.black,
                          blurRadius: 0.3,
                          offset: Offset(0.5, 0.4),
                        )],),
                        SizedBox(width: 20,),
                        Text(
                          "Add Client",
                          style: TextStyle(
                              fontFamily: baseFont,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 0.3,
                                  offset: Offset(0.5, 0.4),
                                )
                              ]),
                        ),
                        // Icon(Icons.chevron_right,color: Colors.white,size: 20,)

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,)
              ],
            ),
            //Add Battery
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () async {
                      // Add Battery

                      await BottomSheet_Widget(
                          context,
                          color: lightBg,
                          [
                            StatefulBuilder(builder:
                                (thisLowerContext,
                                checkBoxState) {
                              return Padding(
                                padding:
                                EdgeInsets.only(
                                  bottom: MediaQuery.of(
                                      thisLowerContext)
                                      .viewInsets
                                      .bottom,
                                ),
                                child:
                                SingleChildScrollView(
                                  child: Container(
                                    height: screenSize
                                        .height /
                                        1.5,
                                    width:
                                    screenSize
                                        .width,
                                    color: lightBg,
                                    child:
                                    SingleChildScrollView(
                                      child:
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                            20),
                                        child:
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              "Enter Battery Details!",
                                              style: TextStyle(
                                                  fontFamily: baseFont,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 24,
                                                  color: darkBg,
                                                  shadows: [
                                                    Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))
                                                  ]),
                                            ),
                                            SizedBox(
                                              height:
                                              20,
                                            ),

                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                // Battery Name
                                                LabelText(text: "Battery Name :"),
                                                TextFeildNewUser(
                                                  hintText: "Enter Battery Name",
                                                  Controller: _newbname,
                                                  onChanged: (value) {},
                                                  enable: true,
                                                  etext: batteryValidator && _newbname.text.trim().isEmpty ? "Please Enter Battery Name" : "",
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                // Relase Note
                                                LabelText(text: "Battery Code"),
                                                TextFeildNewUser(
                                                  hintText: "Enter Battery Code",
                                                  Controller: _batteryDescription,
                                                  type: TextInputType.number,
                                                  maxLength: 2,
                                                  onChanged: (value) {},
                                                  enable: true,
                                                  etext: batteryValidator && _batteryDescription.text.trim().isEmpty ? "Please Enter Battery Code" : "",
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                            // Add Btn
                                            manageUserBtn(
                                                text:
                                                "Add Battery",
                                                onPress:
                                                    () async {
                                                  printFunc("BEFORE : $batteryValidator");
                                                  checkBoxState(() {
                                                    ValidateBatteryFields();
                                                  });
                                                  printFunc("DEMO DEMO : ${batteryValidator && _newbname.text.trim().isEmpty}");
                                                  printFunc("DEMODEMO");
                                                  printFunc(batteryValidator);
                                                  printFunc(_newbname.text.trim().isEmpty);

                                                  if (!batteryValidator) {
                                                    printFunc("Inside IF COND");
                                                    if (await addNewDeviceType(
                                                      context,
                                                      name: _newbname.text.trim(),
                                                      description: _batteryDescription.text.trim(),
                                                    )) {

                                                      clearBattery();
                                                      Navigator.of(context, rootNavigator: true).pop();

                                                      // Navigator.of(context,rootNavigator: true).pop();//(MaterialPageRoute(builder: (_) => AdminMain()));
                                                    }
                                                  }

                                                  setState(() {});
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                          ]);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.battery_0_bar_outlined,size: 22,color: Colors.white,shadows: [Shadow(
                          color: Colors.black,
                          blurRadius: 0.3,
                          offset: Offset(0.5, 0.4),
                        )],),
                        SizedBox(width: 20),
                        Text(
                          "Add Battery",
                          style: TextStyle(
                              fontFamily: baseFont,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 0.3,
                                  offset: Offset(0.5, 0.4),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,)
              ],
            ),
            //Add Designation
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () async {
                      await BottomSheet_Widget(
                          context,
                          color: lightBg,
                          [
                            StatefulBuilder(builder:
                                (thisLowerContext,
                                CheckDesignationState) {
                              return Padding(
                                padding:
                                EdgeInsets.only(
                                  bottom: MediaQuery.of(
                                      thisLowerContext)
                                      .viewInsets
                                      .bottom,
                                ),
                                child:
                                SingleChildScrollView(
                                  child: Container(
                                    height: screenSize
                                        .height /
                                        1.5,
                                    width:
                                    screenSize
                                        .width,
                                    color: lightBg,
                                    child:
                                    SingleChildScrollView(
                                      child:
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                            20),
                                        child:
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              "Enter Designation Details!",
                                              style: TextStyle(
                                                  fontFamily: baseFont,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 24,
                                                  color: darkBg,
                                                  shadows: [
                                                    Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))
                                                  ]),
                                            ),
                                            SizedBox(
                                              height:
                                              20,
                                            ),

                                            Container(
                                              child:
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  // Battery Name
                                                  LabelText(text: "Designation :"),
                                                  TextFeildNewUser(
                                                    hintText: "Enter Designation",
                                                    Controller: _newDesgination,
                                                    onChanged: (value) {},
                                                    enable: true,
                                                    etext: designationValidator && _newDesgination.text.trim().isEmpty ? "Please Enter Designation" : "",
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  // Relase Note
                                                  LabelText(text: "Priority"),
                                                  TextFeildNewUser(
                                                    hintText: "Enter Priority",
                                                    Controller: _designationPriority,
                                                    type: TextInputType.number,
                                                    onChanged: (value) {},
                                                    enable: true,
                                                    etext: designationValidator && _designationPriority.text.trim().isEmpty ? "Please Enter Priority" : "",
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Add Btn
                                            manageUserBtn(
                                                text:
                                                "Add Designation",
                                                onPress: () async {
                                                  CheckDesignationState(() {
                                                    ValidateDesignationFields();
                                                  });

                                                  if (!designationValidator) {
                                                    printFunc("Inside IF COND");
                                                    if (await addNewDesgination(
                                                      context,
                                                      name: _newDesgination.text.trim(),
                                                      priority: int.tryParse(_designationPriority.text) ?? 0,
                                                    )) {
                                                      clearDesignationFields();

                                                      Navigator.of(context).pop(); // Close inner sheet
                                                      // Navigator.of(context,rootNavigator: true).pop();//(MaterialPageRoute(builder: (_) => AdminMain()));
                                                    }
                                                  }
                                                  setState(() {});
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                          ]);
                      clearDesignationFields();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.supervised_user_circle_outlined,size: 22,color: Colors.white,shadows: [Shadow(
                          color: Colors.black,
                          blurRadius: 0.3,
                          offset: Offset(0.5, 0.4),
                        )],),
                        SizedBox(width: 20,),
                        Text(
                          "Add Designation",
                          style: TextStyle(
                              fontFamily: baseFont,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 0.3,
                                  offset: Offset(0.5, 0.4),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,)
              ],
            ),
            futureScope
            ? Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => deviceInfo()));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.perm_device_information_outlined,size: 22,color: Colors.white,shadows: [Shadow(
                          color: Colors.black,
                          blurRadius: 0.3,
                          offset: Offset(0.5, 0.4),
                        )],),
                        SizedBox(width: 20,),
                        Text(
                          "Device Information",
                          style: TextStyle(
                              fontFamily: baseFont,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 0.3,
                                  offset: Offset(0.5, 0.4),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,)
              ],
            )
            : SizedBox(),
          ],
        ),


        child: Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // View logs
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/viewLog.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "View Device Log",
                      onPress: () {
                        printFunc("USERDATA : $UserData");
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => AdminLogs()));
                      }),
                  SizedBox(
                    height: 15,
                  ),

                  // Manage users
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/modify_user.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "Modify User Data",
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => AdminNewUser()));
                      }),
                  SizedBox(
                    height: 15,
                  ),

                  //  Firmware
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/edit_firmware.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "Firmware settings",
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => AddNewFirmware()));
                      }),
                  SizedBox(
                    height: 15,
                  ),

                  // List of Firmware, profiles,Battery, batches,
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/to-do-list.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "System Overview",
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => listOverview()));
                      }),
                  SizedBox(
                    height: 15,
                  ),

                  //Demo profile thing
                  /*ElevatedButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => EmployeeFormTextField()));
                  }, child: Text("child"))*/
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        )
    );
  }

  void ValidateUser() {
    final Controllers = [
      _bname,
      _relaseNote,
      _upperThershold,
      _upperVoltage,
      _lowerThershold,
      _lowerVoltage,
    ];

    bool hasEmpty =
        Controllers.any((controller) => controller.text.trim().isEmpty);
    printFunc("has Next : $hasEmpty");
    setState(() {
      validateUser = hasEmpty;
    });

    // Future Delayed

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        validateUser = false;
      });
    });
  }

  void ValidateDeviceFields() {
    final Controllers = [_newuuid, _newmodel, _newbrand];

    bool hasEmpty =
        Controllers.any((controller) => controller.text.trim().isEmpty);
    printFunc("has Next : $hasEmpty");
    setState(() {
      deviceValidator = hasEmpty;
    });
    // Future Delayed
    printFunc("DEMOMMOMO : ${deviceValidator}");
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        deviceValidator = false;
      });
    });
  }

  void ValidateClientFields() {
    final Controllers = [
      _clientName,
      _clientAddress,
      _clientPhno,
      _clientEmail,
      _clientContactPerson,
      _clientDiscription,
      _clientCode
    ];

    bool hasEmpty =
        Controllers.any((controller) => controller.text.trim().isEmpty);
    printFunc("has Next : $hasEmpty");
    setState(() {
      clientValidator = hasEmpty;
    });
    // Future Delayed
    printFunc("DEMOMMOMO clientValidator: ${clientValidator}");
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        clientValidator = false;
      });
    });
  }

  void clearClient() {
    _clientName.clear();
    _clientAddress.clear();
    _clientPhno.clear();
    _clientEmail.clear();
    _clientContactPerson.clear();
    _clientDiscription.clear();
    _clientCode.clear();
    setState(() {});
  }

  void ValidateDesignationFields() {
    final Controllers = [_newDesgination, _designationPriority];

    bool hasEmpty =
        Controllers.any((controller) => controller.text.trim().isEmpty);
    printFunc("has Next : $hasEmpty");
    setState(() {
      designationValidator = hasEmpty;
    });
    // Future Delayed
    printFunc("DEMOMMOMO : ${designationValidator}");
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        designationValidator = false;
      });
    });
  }

  void clearDesignationFields() {
    _newDesgination.clear();
    _designationPriority.clear();
    setState(() {});
  }

  void ValidateBatteryFields() {
    final Controllers = [
      _newbname,
      _batteryDescription,
    ];

    bool hasEmpty =
    Controllers.any((controller) => controller.text.trim().isEmpty);
    printFunc("has Next : $hasEmpty");
    setState(() {
      batteryValidator = hasEmpty;
    });
    // Future Delayed
    printFunc("DEMOMMOMO : ${batteryValidator}");

  }

  void clearBattery() {
    // New Battery
    _newbname.clear();
    _batteryDescription.clear();
    setState(() {});
  }
}


//Adding Client, Designation, Battery Type
/*
                  PrimaryButton(
                      icon: Image.asset(
                        'assets/image/add_new.png',
                        width: 20,
                        height: 20,
                        color: darkBg,
                      ),
                      text: "Add New Resource",
                      onPress: () async {
                        await BottomSheet_Widget(
                            context,
                            color: darkBg.withOpacity(0.8),
                            [
                              StatefulBuilder(
                                  builder: (thisLowerContext, checkBoxState) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(thisLowerContext)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: screenSize.height / 3,
                                      width: screenSize.width,
                                      color: darkBg.withOpacity(0.5),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // ADD CLIENT
                                              GestureDetector(
                                                onTap: () async {
                                                  // Add Client
                                                  clearClient();
                                                  await showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled:
                                                        true, // important for keyboard handling
                                                    backgroundColor: lightBg,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      10.0)),
                                                    ),
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                        builder: (thisLowerContext,
                                                            checkClientState) {
                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                      thisLowerContext)
                                                                  .viewInsets
                                                                  .bottom,
                                                            ),
                                                            child: Container(
                                                              height: screenSize
                                                                      .height /
                                                                  1.5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      screenSize
                                                                          .width,
                                                                  color:
                                                                      lightBg,
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          20,
                                                                      horizontal:
                                                                          16),
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              15),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min, // wrap content
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "Enter Client Details!",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                baseFont,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            fontSize:
                                                                                28,
                                                                            color:
                                                                                darkBg,
                                                                            shadows: [
                                                                              Shadow(
                                                                                color: Colors.black,
                                                                                blurRadius: 0.5,
                                                                                offset: Offset(0.5, 0.5),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              20),
                                                                      LabelText(
                                                                          text:
                                                                              "Client Name :"),
                                                                      TextFeildNewUser(
                                                                        hintText:
                                                                            "Enter Client Name",
                                                                        Controller:
                                                                            _clientName,
                                                                        onChanged:
                                                                            (value) {},
                                                                        enable:
                                                                            true,
                                                                        etext: clientValidator &&
                                                                                _clientName.text.trim().isEmpty
                                                                            ? "Please Enter Client Name"
                                                                            : "",
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      LabelText(
                                                                          text:
                                                                              "Client Address"),
                                                                      TextFeildNewUser(
                                                                        hintText:
                                                                            "Enter Client Address",
                                                                        Controller:
                                                                            _clientAddress,
                                                                        onChanged:
                                                                            (value) {},
                                                                        enable:
                                                                            true,
                                                                        etext: clientValidator &&
                                                                                _clientAddress.text.trim().isEmpty
                                                                            ? "Please Enter Client Address"
                                                                            : "",
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      LabelText(
                                                                          text:
                                                                              "Client Phone-Number"),
                                                                      TextFeildNewUser(
                                                                        hintText:
                                                                            "Enter Client Phone-Number",
                                                                        Controller:
                                                                            _clientPhno,
                                                                        type: TextInputType.number,
                                                                        onChanged:
                                                                            (value) {},
                                                                        maxLength: 10,

                                                                        enable:
                                                                            true,
                                                                        etext: clientValidator &&
                                                                                _clientPhno.text.trim().isEmpty
                                                                            ? "Please Enter Client Phone-Number"
                                                                            : "",
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      LabelText(
                                                                          text:
                                                                              "Client E-mail"),
                                                                      TextFeildNewUser(
                                                                        hintText:
                                                                            "Enter Client E-mail",
                                                                        Controller:
                                                                            _clientEmail,
                                                                        onChanged:
                                                                            (value) {},
                                                                        enable:
                                                                            true,
                                                                        etext: clientValidator &&
                                                                                _clientEmail.text.trim().isEmpty
                                                                            ? "Please Enter Client E-mail"
                                                                            : "",
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      LabelText(
                                                                          text:
                                                                              "Client's Contact Person"),
                                                                      TextFeildNewUser(
                                                                        hintText:
                                                                            "Enter Client's Contact Person",
                                                                        Controller:
                                                                            _clientContactPerson,
                                                                        onChanged:
                                                                            (value) {},
                                                                        maxLength: 10,
                                                                        enable:
                                                                            true,
                                                                        etext: clientValidator &&
                                                                                _clientContactPerson.text.trim().isEmpty
                                                                            ? "Please Enter Client's Contact Person"
                                                                            : "",
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      LabelText(
                                                                          text:
                                                                              "Description"),
                                                                      TextFeildNewUser(
                                                                        hintText:
                                                                            "Enter Description",
                                                                        Controller:
                                                                            _clientDiscription,
                                                                        onChanged:
                                                                            (value) {},
                                                                        enable:
                                                                            true,
                                                                        etext: clientValidator &&
                                                                                _clientDiscription.text.trim().isEmpty
                                                                            ? "Please Enter Description"
                                                                            : "",
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      LabelText(
                                                                          text:
                                                                              "Client's code"),
                                                                      TextFeildNewUser(
                                                                        hintText:
                                                                            "Enter Client's code",
                                                                        Controller:
                                                                            _clientCode,
                                                                        type: TextInputType.number,
                                                                        onChanged:
                                                                            (value) {},
                                                                        enable:
                                                                            true,
                                                                        etext: clientValidator &&
                                                                                _clientCode.text.trim().isEmpty
                                                                            ? "Please Enter Client's code"
                                                                            : "",
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              20),
                                                                      Center(
                                                                        child:
                                                                            manageUserBtn(
                                                                          text:
                                                                              "Add Client",
                                                                          onPress:
                                                                              () async {
                                                                            checkClientState(() {
                                                                              ValidateClientFields();
                                                                            });
                                                                            if (!clientValidator) {
                                                                              if (await saveClient(
                                                                                context,
                                                                                name: _clientName.text.trim(),
                                                                                address: _clientAddress.text.trim(),
                                                                                contactNumber: _clientPhno.text.trim(),
                                                                                email: _clientEmail.text.trim(),
                                                                                contactPerson: _clientContactPerson.text.trim(),
                                                                                discription: _clientDiscription.text.trim(),
                                                                                code: _clientCode.text.trim(),
                                                                              )) {
                                                                                clearClient();
                                                                                Navigator.of(context).pop();
                                                                                Navigator.of(context).pop();
                                                                              }
                                                                            }
                                                                            setState(() {});
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.white70),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5, left: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "ADD CLIENT!!",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily: baseFont,
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.w700,
                                                                    shadows: [
                                                                      Shadow(
                                                                          color: Colors
                                                                              .black26,
                                                                          blurRadius:
                                                                              0.4)
                                                                    ]),
                                                              ),
                                                            ],
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .double_arrow_outlined,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),

                                              // ADD DESIGNATION
                                              GestureDetector(
                                                onTap: () async {
                                                  await BottomSheet_Widget(
                                                      context,
                                                      color: lightBg,
                                                      [
                                                        StatefulBuilder(builder:
                                                            (thisLowerContext,
                                                                CheckDesignationState) {
                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                      thisLowerContext)
                                                                  .viewInsets
                                                                  .bottom,
                                                            ),
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Container(
                                                                height: screenSize
                                                                        .height /
                                                                    1.5,
                                                                width:
                                                                    screenSize
                                                                        .width,
                                                                color: lightBg,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "Enter Designation Details!",
                                                                          style: TextStyle(
                                                                              fontFamily: baseFont,
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: 24,
                                                                              color: darkBg,
                                                                              shadows: [
                                                                                Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))
                                                                              ]),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),

                                                                        Container(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              // Battery Name
                                                                              LabelText(text: "Designation :"),
                                                                              TextFeildNewUser(
                                                                                hintText: "Enter Designation",
                                                                                Controller: _newDesgination,
                                                                                onChanged: (value) {},
                                                                                enable: true,
                                                                                etext: designationValidator && _newDesgination.text.trim().isEmpty ? "Please Enter Designation" : "",
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              // Relase Note
                                                                              LabelText(text: "Priority"),
                                                                              TextFeildNewUser(
                                                                                hintText: "Enter Priority",
                                                                                Controller: _designationPriority,
                                                                                type: TextInputType.number,
                                                                                onChanged: (value) {},
                                                                                enable: true,
                                                                                etext: designationValidator && _designationPriority.text.trim().isEmpty ? "Please Enter Priority" : "",
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        // Add Btn
                                                                        manageUserBtn(
                                                                            text:
                                                                                "Add Designation",
                                                                            onPress:
                                                                                () async {
                                                                              CheckDesignationState(() {
                                                                                ValidateDesignationFields();
                                                                              });

                                                                              if (!designationValidator) {
                                                                                printFunc("Inside IF COND");
                                                                                if (await addNewDesgination(
                                                                                  context,
                                                                                  name: _newDesgination.text.trim(),
                                                                                  priority: int.tryParse(_designationPriority.text) ?? 0,
                                                                                )) {
                                                                                  clearDesignationFields();

                                                                                  Navigator.of(context).pop(); // Close inner sheet
                                                                                  // Navigator.of(context,rootNavigator: true).pop();//(MaterialPageRoute(builder: (_) => AdminMain()));
                                                                                }
                                                                              }
                                                                              setState(() {});
                                                                            })
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                      ]);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.white70),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5, left: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "ADD DESIGNATION",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily: baseFont,
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.w700,
                                                                    shadows: [
                                                                      Shadow(
                                                                          color: Colors
                                                                              .black26,
                                                                          blurRadius:
                                                                              0.4)
                                                                    ]),
                                                              ),
                                                            ],
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .double_arrow_outlined,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),

                                              // ADD BATTERY
                                              GestureDetector(
                                                onTap: () async {
                                                  // Add Battery

                                                  await BottomSheet_Widget(
                                                      context,
                                                      color: lightBg,
                                                      [
                                                        StatefulBuilder(builder:
                                                            (thisLowerContext,
                                                                checkBoxState) {
                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                      thisLowerContext)
                                                                  .viewInsets
                                                                  .bottom,
                                                            ),
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Container(
                                                                height: screenSize
                                                                        .height /
                                                                    1.5,
                                                                width:
                                                                    screenSize
                                                                        .width,
                                                                color: lightBg,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "Enter Battery Details!",
                                                                          style: TextStyle(
                                                                              fontFamily: baseFont,
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: 24,
                                                                              color: darkBg,
                                                                              shadows: [
                                                                                Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))
                                                                              ]),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),

                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            // Battery Name
                                                                            LabelText(text: "Battery Name :"),
                                                                            TextFeildNewUser(
                                                                              hintText: "Enter Battery Name",
                                                                              Controller: _newbname,
                                                                              onChanged: (value) {},
                                                                              enable: true,
                                                                              etext: batteryValidator && _newbname.text.trim().isEmpty ? "Please Enter Battery Name" : "",
                                                                            ),
                                                                            SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            // Relase Note
                                                                            LabelText(text: "Battery Code"),
                                                                            TextFeildNewUser(
                                                                              hintText: "Enter Battery Code",
                                                                              Controller: _batteryDescription,
                                                                              type: TextInputType.number,
                                                                              maxLength: 2,
                                                                              onChanged: (value) {},
                                                                              enable: true,
                                                                              etext: batteryValidator && _batteryDescription.text.trim().isEmpty ? "Please Enter Battery Code" : "",
                                                                            ),
                                                                            SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        // Add Btn
                                                                        manageUserBtn(
                                                                            text:
                                                                                "Add Battery",
                                                                            onPress:
                                                                                () async {
                                                                              printFunc("BEFORE : $batteryValidator");
                                                                              checkBoxState(() {
                                                                                ValidateBatteryFields();
                                                                              });
                                                                              printFunc("DEMO DEMO : ${batteryValidator && _newbname.text.trim().isEmpty}");
                                                                              printFunc("DEMODEMO");
                                                                              printFunc(batteryValidator);
                                                                              printFunc(_newbname.text.trim().isEmpty);

                                                                              if (!batteryValidator) {
                                                                                printFunc("Inside IF COND");
                                                                                if (await addNewDeviceType(
                                                                                  context,
                                                                                  name: _newbname.text.trim(),
                                                                                  description: _batteryDescription.text.trim(),
                                                                                )) {

                                                                                  clearBattery();
                                                                                  Navigator.of(context, rootNavigator: true).pop();

                                                                                  // Navigator.of(context,rootNavigator: true).pop();//(MaterialPageRoute(builder: (_) => AdminMain()));
                                                                                }
                                                                              }

                                                                              setState(() {});
                                                                            })
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                      ]);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.white70),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5, left: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "ADD BATTERY SERIES",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily: baseFont,
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.w700,
                                                                    shadows: [
                                                                      Shadow(
                                                                          color: Colors
                                                                              .black26,
                                                                          blurRadius:
                                                                              0.4)
                                                                    ]),
                                                              ),
                                                            ],
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .double_arrow_outlined,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                            ]);
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  */