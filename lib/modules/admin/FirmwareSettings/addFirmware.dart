
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/admin_main.dart';
import 'package:tracker_firmware/modules/login/api/api.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/CustomCard.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';

import '../../../widgets/buttons.dart';
import '../../../widgets/textFields.dart';

class AddNewFirmware extends StatefulWidget{
  @override
  State<AddNewFirmware> createState() => AddNewFirmwareState();

}
class AddNewFirmwareState extends State<AddNewFirmware>{


  int selectedbutton =1;

Map<String, dynamic> batteryList ={};
  String? fileBase64;

  // -- New user
  bool validateUser = false;
  bool _validateDropDown = false;

  //Password Validation
  bool _passwordNotSame= false;

  // -- Edit User
  bool _userFound = false;
  bool _validatePhn = false;
  bool _activeUser = false;
  bool _validateEditUser = false;
  bool _validateEditDropDown = false;


  //----- Controllers for new Entry
  TextEditingController _versionCode = TextEditingController();
  TextEditingController _releaseNote = TextEditingController();
  TextEditingController _firmWareVersionName = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repassword = TextEditingController();
  DataController batterySeries = DataController();

  // ----- Controller For Searching
  TextEditingController _searchPhn = TextEditingController();

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
        "B12": {
          "id": 3,
          "name": "B12",
          "priority": 3
        },
      };
    });
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Firmware",style: TextStyle(fontFamily: baseFont,fontWeight: FontWeight.w800, fontSize: 22,color: lightBg),),
        toolbarHeight: 60,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: lightBg,
      body: SingleChildScrollView(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              // elevation: ,
              // shadowColor: Colors.black,
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: darkBg,
                        width:1
                    ),

                    borderRadius:  BorderRadius.all(
                        Radius.circular(22)
                    )
                ),
                color: lightBg,
                child: Container(
                  height: size.height/9,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //NEW USER
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedbutton =1;
                          });
                        },
                        child: Container(
                          width: size.width * 0.49,
                          height: 120,
                          decoration: BoxDecoration(
                              color:  selectedbutton == 1 ? darkBg :lightBg,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              ),
                              border: Border.all(
                                  width: 0.5,
                                  color: darkBg
                              ),
                              boxShadow: [BoxShadow(
                                  blurRadius: 0.5,
                                  color: darkBg
                              )]
                          ),
                          child: Center(
                              heightFactor: 2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Image.asset('assets/image/user.png',
                                    //   width: 32,
                                    //   height: 32,
                                    //   color: selectedbutton == 1 ? lightBg : darkBg,
                                    // ),
                                    Icon(Icons.update,color: selectedbutton == 2 ? darkBg : lightBg,size: 40,),
                                    Text("New Firmware",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: baseFont,
                                        fontWeight: FontWeight.w600,
                                        color: selectedbutton == 1 ? lightBg : darkBg,
                                        shadows: [
                                          Shadow(offset: Offset(0.3, 0.3), color:  selectedbutton == 1 ? lightBg : darkBg),
                                          Shadow(offset: Offset(-0.3, 0.3), color:  selectedbutton == 1 ? lightBg : darkBg),
                                        ],
                                      ),)
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                      //EDIT USER
                      InkWell(
                        onTap: (){
                          setState(() {
                            selectedbutton =2;
                          });
                        },
                        child: Container(
                          width: size.width * 0.48,
                          height: 120,
                          decoration: BoxDecoration(
                              color: selectedbutton == 2  ? darkBg : lightBg,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                              ),

                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 0.5,
                                    color: darkBg
                                )]

                          ),
                          child: Center(
                              heightFactor: 2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Image.asset('assets/image/editUser.png',
                                    //   width: 32,
                                    //   height: 32,
                                    //   color: selectedbutton == 1 ? darkBg : lightBg,
                                    // ),
                                    // Icon(Icons.tune_outlined),
                                    Icon(Icons.handyman_outlined,color: selectedbutton == 1 ? darkBg : lightBg,size: 32,),
                                    Text("New Profile",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: baseFont,
                                        fontWeight: FontWeight.w600,
                                        color: selectedbutton == 1 ? darkBg : lightBg,
                                        shadows: [
                                          Shadow(offset: Offset(0.3, 0.3), color:  selectedbutton == 1 ? darkBg : lightBg,),
                                          Shadow(offset: Offset(-0.3, 0.3), color:  selectedbutton == 1 ? darkBg : lightBg,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ),

            if (selectedbutton == 1)
              newFirmware(context)   else
               newService(context)
          ],
        ),
      ),
    );
  }
  Widget newFirmware(context){
   return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 15,top: 10,right: 15,bottom: 20),
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
            borderRadius: BorderRadius.circular(20)
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Center(
                  child: Text("ENTER THE DETAILS",
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: darkBg,
                        shadows: [Shadow(
                            color: Colors.black,
                            blurRadius: 0.5,
                            offset: Offset(0.5, 0.5)
                        )]
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20 ,),
                      //----2.0.3-----
                      LabelText(text: "Firmware Version :"),
                      TextFeildNewUser(
                        hintText: "Enter Firmware Version ",
                        Controller: _versionCode,
                        onChanged: (value){},
                        enable: true,
                        etext: validateUser && _versionCode.text.trim().isEmpty ?"Please Enter the Version" : "",
                      ),
                      SizedBox(height: 10,),

                      //update on bluetooth conectivity
                      LabelText(text: "Release Note:"),
                      TextFeildNewUser(
                        hintText: "Release Note",
                        Controller: _releaseNote,
                        onChanged: (value){},
                        enable: true,
                        etext: validateUser && _releaseNote.text.trim().isEmpty ?"Please Enter the Release Note" : "",
                      ),
                      SizedBox(height: 8,),

                      //B5 v 2.0.3
                      LabelText(text: "Version Name :"),
                      TextFeildNewUser(
                        hintText: "Enter Version Name",
                        Controller: _firmWareVersionName,
                        onChanged: (value){
                        },
                        enable: true,
                        etext: validateUser && _firmWareVersionName.text.trim().isEmpty ?"Please Enter the Version Name" : "",
                      ),
                      SizedBox(height: 8,),



                      //----Battery series---- [DROPDOWN]
                      GestureDetector(
                        child: PrimeryDropDownButton(
                          isEnabled: true,
                          tail: ErrorContainer(
                              show: _validateDropDown,
                              errorMsg:"Please Select the Battery Series"
                          ),
                          mainText: "Select Battery Series",
                          text: batterySeries.Text != ""
                              ?batterySeries.getText
                              : "Battery Series",
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: darkBg,
                          ),
                          press: () async{
                            await BottomSheet_Widget(
                                context,
                                [
                                  MapListItemBuilder(
                                    listItems: batteryList,
                                    press: (){},
                                    selected: batterySeries,
                                  )
                                ]
                            );
                            setState(() {});
                          },


                        ),
                      ),
                      SizedBox(height: 8,),




                    ],
                  )
              ),
              SizedBox(height: 20 ,),

              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: PrimaryButton(
                  width: size.width/2.5,
                  height:40,
                  tailIcon: Icon(CupertinoIcons.arrow_up_doc,
                      // color: darkBg,
                      shadows: [Shadow(
                          color: darkBg,
                          blurRadius: 0.5
                      )]),
                  text: "ADD Firmware",
                  onPress:                          pickPdfAndConvertToBase64,

                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: manageUserBtn(
                    text: "Upload Firmware",
                    onPress: (){
                      ValidateUser();
                      validateDropDown(batterySeries);
                      validatePassword();

                      if(!validateUser && !_validateDropDown ){
                        printFunc("Inside IF COND");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:Row(
                              children: [
                                Icon(CupertinoIcons.checkmark_seal_fill,color: lightBg,),
                                SizedBox(width: 15,),
                                Text('User Added Successfully!!',
                                  style: TextStyle(
                                    color: lightBg,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: baseFont,
                                    fontSize: 22,

                                  ),),
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
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget newService(context){
   return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 15,top: 10,right: 15,bottom: 20),
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
            borderRadius: BorderRadius.circular(20)
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Center(
                  child: Text("ENTER THE DETAILS",
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: darkBg,
                        shadows: [Shadow(
                            color: Colors.black,
                            blurRadius: 0.5,
                            offset: Offset(0.5, 0.5)
                        )]
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20 ,),
                      //----2.0.3-----
                      LabelText(text: "Profile Name :"),
                      TextFeildNewUser(
                        hintText: "Enter Profile Name  ",
                        Controller: _versionCode,
                        onChanged: (value){},
                        enable: true,
                        etext: validateUser && _versionCode.text.trim().isEmpty ?"Please Enter the Profile Name" : "",
                      ),
                      SizedBox(height: 10,),

                      //update on bluetooth conectivity
                      LabelText(text: "Description :"),
                      TextFeildNewUser(
                        hintText: "Description",
                        Controller: _releaseNote,
                        onChanged: (value){},
                        enable: true,
                        etext: validateUser && _releaseNote.text.trim().isEmpty ?"Please Enter the Description" : "",
                      ),
                      SizedBox(height: 8,),

                      const LabelText(text: "Upper Threshold :"),
                      TextFeildNewUser(
                        hintText: "Enter Upper Threshold",
                        inputFormatters:   [OneDecimalInputFormatter()],
                        type:TextInputType.number,
                        Controller: _firmWareVersionName,
                        onChanged: (value){
                        },
                        enable: true,
                        etext: validateUser && _firmWareVersionName.text.trim().isEmpty ?"Please Enter the Upper Threshold" : "",
                      ),
                      SizedBox(height: 8,),
                      const LabelText(text: "Upper Voltage :"),
                      TextFeildNewUser(
                        hintText: "Enter Upper Voltage",
                        inputFormatters:   [OneDecimalInputFormatter()], // Correct
                        type:TextInputType.number,

                        Controller: _firmWareVersionName,
                        onChanged: (value){
                        },
                        enable: true,
                        etext: validateUser && _firmWareVersionName.text.trim().isEmpty ?"Please Enter the Upper Voltage" : "",
                      ),
                      SizedBox(height: 8,),
                      const LabelText(text: "Lower Threshold :"),
                      TextFeildNewUser(
                        hintText: "Enter Lower Threshold",
                        inputFormatters:   [OneDecimalInputFormatter()],
                        type:TextInputType.number,

                        Controller: _firmWareVersionName,
                        onChanged: (value){
                        },
                        enable: true,
                        etext: validateUser && _firmWareVersionName.text.trim().isEmpty ?"Please Enter the Lower Threshold" : "",
                      ),
                      SizedBox(height: 8,),
                      const LabelText(text: "Lower Voltage :"),
                      TextFeildNewUser(
                        hintText: "Enter Lower Voltage",
                        inputFormatters:   [OneDecimalInputFormatter()],
                        type:TextInputType.number,

                        Controller: _firmWareVersionName,
                        onChanged: (value){
                        },
                        enable: true,
                        etext: validateUser && _firmWareVersionName.text.trim().isEmpty ?"Please Enter the Lower Voltage" : "",
                      ),
                      SizedBox(height: 8,),



                      //----Battery series---- [DROPDOWN]
                      GestureDetector(
                        child: PrimeryDropDownButton(
                          isEnabled: true,
                          tail: ErrorContainer(
                              show: _validateDropDown,
                              errorMsg:"Please Select the Battery Series"
                          ),
                          mainText: "Select Battery Series",
                          text: batterySeries.Text != ""
                              ?batterySeries.getText
                              : "Battery Series",
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: darkBg,
                          ),
                          press: () async{
                            await BottomSheet_Widget(
                                context,
                                [
                                  MapListItemBuilder(
                                    listItems: batteryList,
                                    press: (){},
                                    selected: batterySeries,
                                  )
                                ]
                            );
                            setState(() {});
                          },


                        ),
                      ),
                      SizedBox(height: 8,),




                    ],
                  )
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: manageUserBtn(
                    text: "Upload Profile",
                    onPress: (){  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void ValidateUser(){
    final Controllers = [
      _versionCode,
      _releaseNote,
      _firmWareVersionName,
      _contact,
      _password,
      _repassword,
    ];

    printFunc("name : ${_versionCode.text}\n EmpREGID : ${_releaseNote.text}\n email : ${_firmWareVersionName.text}\n Contact : ${_contact.text}\n password : ${_password.text} \nRePassword : ${_repassword.text}");
    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);
    setState(() {
      validateUser = hasEmpty;
    });

    // Future Delayed

    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        validateUser = false;
      });
    });

  }

  void ValidateEditUser(){
    final Controllers = [
      _name01,
      _empRegId01,
      _email01,
      _contact01,
      /*
      _password01,
      _repassword01,
      */
    ];
    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);

    setState(() {
      _validateEditUser = hasEmpty;
    });
    // Future Delayed

    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        _validateEditUser = false;
      });
    });

  }

  void validatePassword(){
    print("Demo validatePassword ${_passwordNotSame}");
    if(_password.text != _repassword.text!){
      setState(() {
        _passwordNotSame = true;
      });
    }
    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        _passwordNotSame = false;
      });
    });
  }

  void validatePhn() {
    final phn = _searchPhn.text.trim();
    printFunc("DEMO DEMO : ${_searchPhn.text.trim().length}");
    printFunc("DEMO DEMO DEMO : ${phn.length != 10 }");
    if(phn.length != 10){
      setState(() {
        _validatePhn = true;

      });
    }else{
      setState(() {
        _validatePhn = false;
      });
    }

  }

  void validateDropDown(DataController variable) {
    if (variable.getText ==""){
      setState(() {
        _validateDropDown = true;
      });
    }else{
      _validateDropDown = false;
    }

    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        _validateDropDown = false;
      });
    });
  }

  void validateEditDropDown(DataController variable) {
    if (variable.getText ==""){
      setState(() {
        _validateEditDropDown = true;
      });
    }else{
      _validateEditDropDown = false;
    }

    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        _validateDropDown = false;
      });
    });
  }

  void setEmpDetails() async{
    var empObj = await getEmployeeDetail(context, _searchPhn.text);
    printFunc("DEMO EMP OBJ : $empObj \n name : ${empObj?["name"]}");


    if(empObj == null){
      printFunc("Inside is cond");
      setState(() {
        _userFound = false;
      });
    }else{
      setState(() {
        _userFound = true;
      });
      setState(() {
        _name01.text = empObj["name"];
        _empRegId01.text = empObj["empRegisteredId"];
        _email01.text = empObj["email"];
        _contact01.text = empObj["phone"];
        designation01.setText = empObj["designation"];
        designation01.setobj = batteryList[empObj["designation"]];//Designation.getEmpDetails(int.parse(empObj["designationCode"]));
      });
      printFunc("Inside else cond");
      if(empObj["status"] == "active"){
        setState(() {
          _activeUser = true;
        });
      } else{
        setState(() {
          _activeUser = false;
        });
      }

    }
    printFunc("Name01 : ${_name01.text}");
    printFunc("EMP DETAILS OBJECT : ${designation01.obj}");
  }
  Future<void> pickPdfAndConvertToBase64() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg',"jpeg"],
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
