// import 'dart:html';

// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/admin_main.dart';
import 'package:tracker_firmware/modules/login/api/api.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/CustomCard.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class AdminNewUser extends StatefulWidget {
  @override
  State<AdminNewUser> createState() => AdminNewUserState();
}

class AdminNewUserState extends State<AdminNewUser> {
  int selectedbutton = 1;

  Map<String, dynamic> designationRoles = {};

  // -- New user
  bool validateUser = false;
  bool _validateDropDown = false;

  //Password Validation
  bool _passwordNotSame = false;

  // -- Edit User
  bool _userFound = false;
  bool _validatePhn = false;
  bool _activeUser = false;
  bool _validateEditUser = false;
  bool _validateEditDropDown = false;

  //----- Controllers for new Entry
  TextEditingController _name = TextEditingController();
  TextEditingController _empRegId = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repassword = TextEditingController();
  DataController designation = DataController();

  // ----- Controller For Searching
  TextEditingController _searchPhn = TextEditingController();

  //------- Controllers for Editing Entry
  TextEditingController _name01 = TextEditingController();
  TextEditingController _empRegId01 = TextEditingController();
  TextEditingController _email01 = TextEditingController();
  TextEditingController _contact01 = TextEditingController();
  TextEditingController _password01 = TextEditingController();
  TextEditingController _repassword01 = TextEditingController();
  DataController designation01 = DataController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      designationRoles = {
        "Admin": {
          "id": 1,
          "name": "admin",
          "priority": 1,
        },
        "Factory User": {
          "id": 2,
          "name": "Factory User",
          "priority": 2,
        },
        "Field User": {"id": 3, "name": "Field User", "priority": 3},
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Manage User",
            style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 22, color: lightBg),
          ),
          toolbarHeight: 60,
          backgroundColor: darkBg,
          elevation: 5,
          shadowColor: darkBg,
        ),
        backgroundColor: lightBg,
        body: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Card(
              // elevation: ,
              // shadowColor: Colors.black,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: darkBg, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(22))),
              color: lightBg,
              child: Container(
                height: size.height / 9,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //NEW USER
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedbutton = 1;
                        });
                      },
                      child: Container(
                        width: size.width * 0.49,
                        height: 120,
                        decoration: BoxDecoration(
                            color: selectedbutton == 1 ? darkBg : lightBg,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                            border: Border.all(width: 0.5, color: darkBg),
                            boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                        child: Center(
                            heightFactor: 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/image/user.png',
                                    width: 32,
                                    height: 32,
                                    color: selectedbutton == 1 ? lightBg : darkBg,
                                  ),
                                  Text(
                                    "New User",
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
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    //EDIT USER
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedbutton = 2;
                        });
                      },
                      child: Container(
                        width: size.width * 0.48,
                        height: 120,
                        decoration: BoxDecoration(
                            color: selectedbutton == 2 ? darkBg : lightBg,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                            boxShadow: [BoxShadow(blurRadius: 0.5, color: darkBg)]),
                        child: Center(
                            heightFactor: 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/image/editUser.png',
                                    width: 32,
                                    height: 32,
                                    color: selectedbutton == 1 ? darkBg : lightBg,
                                  ),
                                  Text(
                                    "Edit User",
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
                                ],
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              )),
          if (selectedbutton == 1)
            Card(
              elevation: 5,
              margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <-- radius here
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: second_lightBg.withOpacity(0.5),
                    border: Border.all(
                      color: darkBg,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))
                                ]),
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
                              //----Name-----
                              const LabelText(text: "Employee Name :"),
                              TextFeildNewUser(
                                hintText: "Enter Employee name",
                                Controller: _name,
                                onChanged: (value) {},
                                enable: true,
                                etext:
                                    validateUser && _name.text.trim().isEmpty ? "Please Enter the name" : "",
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //----empRegId------
                              LabelText(text: "Emoplyee Regestred ID[Company ID]:"),
                              TextFeildNewUser(
                                hintText: "Enter empRegID",
                                Controller: _empRegId,
                                onChanged: (value) {},
                                enable: true,
                                etext: validateUser && _empRegId.text.trim().isEmpty
                                    ? "Please Enter the empRegID"
                                    : "",
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              //------email------
                              const LabelText(text: "Employee E-Mail :"),
                              TextFeildNewUser(
                                hintText: "Enter Employee E-Mail",
                                Controller: _email,
                                onChanged: (value) {},
                                enable: true,
                                etext: validateUser && _email.text.trim().isEmpty
                                    ? "Please Enter the E-Mail"
                                    : "",
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              //-----Contact ------
                              LabelText(text: "Employee Phone number :"),
                              TextFeildNewUser(
                                hintText: "Enter Employee Phone number",
                                Controller: _contact,
                                onChanged: (value) {},
                                enable: true,
                                etext: validateUser && _contact.text.trim().isEmpty
                                    ? "Please Enter the Phone Number"
                                    : "",
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              //----DesignationID---- [DROPDOWN]
                              GestureDetector(
                                child: PrimeryDropDownButton(
                                  isEnabled: true,
                                  tail: ErrorContainer(
                                      show: _validateDropDown, errorMsg: "Please Select the Designation"),
                                  mainText: "Select the desgination",
                                  text:
                                      designation.Text != "" ? designation.getText : "Select The Designation",
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: darkBg,
                                  ),
                                  press: () async {
                                    await BottomSheet_Widget(context, [
                                      Column(
                                        children: [
                                          MapListItemBuilder(
                                            listItems: designationRoles,
                                            press: () {},
                                            selected: designation,
                                          )
                                        ],
                                      )
                                    ]);
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              //-----password-----
                              LabelText(text: "Employee Password :"),
                              TextFeildNewUser(
                                hintText: "Enter Employee Password",
                                Controller: _password,
                                onChanged: (value) {},
                                enable: true,
                                etext: validateUser && _password.text.trim().isEmpty
                                    ? "Please Enter the Password"
                                    : "",
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              //-----RE-password-----
                              LabelText(text: "Re-Enter Employee Password :"),
                              TextFeildNewUser(
                                hintText: "Re-Enter Employee Password",
                                Controller: _repassword,
                                onChanged: (value) {},
                                enable: true,
                                etext: validateUser && _password.text.trim().isEmpty
                                    ? "Please Re-Entry the Password"
                                    : validateUser && _passwordNotSame
                                        ? "Password mismatched"
                                        : "",
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: manageUserBtn(
                            text: "ADD USER",
                            onPress: () {
                              ValidateUser();
                              validateDropDown(designation);
                              validatePassword();

                              if (!validateUser && !_validateDropDown) {
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
                      )
                    ],
                  ),
                ),
              ),
            )
          else
            Card(
                elevation: 5,
                margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // <-- radius here
                ),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: second_lightBg.withOpacity(0.5),
                        border: Border.all(
                          color: darkBg,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      //Title
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            "Empolye's Phone number",
                            style: TextStyle(
                                fontFamily: baseFont,
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                                color: darkBg,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))
                                ]),
                          ),
                        ),
                      ),
                      //TextField
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              //----Name-----

                              TextFeildNewUser(
                                hintText: "Enter Phone number",
                                Controller: _searchPhn,
                                maxLength: 10,
                                type: TextInputType.number,
                                onChanged: (value) {},
                                enable: true,
                                etext: _validatePhn ? "Please Enter 10 digit Phone number" : "",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                      //Search btn
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            width: size.width / 3,
                            // Set your desired width
                            height: 40,
                            child: manageUserBtn(
                              text: "Search",
                              onPress: () {
                                validatePhn();
                                setState(() {});
                                if (!_validatePhn) {
                                  setEmpDetails();
                                }
                                printFunc("DEMO VALIDATE USER : $_validatePhn");
                                printFunc("DEMO SetEMp Detials : $_userFound");
                                //api call and store in a bool var so then if the bool is true then olny set the userFound to true otherwise set to false

                                if (_searchPhn.text.trim().length == 10) {
                                  setState(() {
                                    _userFound = true;
                                  });
                                } else {
                                  setState(() {
                                    _userFound = false;
                                  });
                                }
                              },
                              icon: Icon(
                                CupertinoIcons.search,
                                size: 20,
                              ),
                            ),
                            /*ElevatedButton(
                              onPressed:(){
                                validatePhn();
                                setState(() {});
                                if(!_validatePhn){
                                  setEmpDetails();
                                }
                                printFunc("DEMO VALIDATE USER : $_validatePhn");
                                printFunc("DEMO SetEMp Detials : $_userFound");
                                //api call and store in a bool var so then if the bool is true then olny set the userFound to true otherwise set to false
                               /*
                                if(_searchPhn.text.trim().length == 10){
                                 setState(() {
                                   _userFound= true;
                                 });
                               }else{
                                 setState(() {
                                   _userFound= false;
                                 });
                               }*/
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(darkBg),
                                  elevation: MaterialStateProperty.all(5),
                                  shadowColor: MaterialStateProperty.all(darkBg),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        side: BorderSide(color: darkBg, width: 1)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_rounded, size: 21),
                                    Text(
                                      "Search",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: baseFont,
                                          shadows: [Shadow(color: Colors.black, blurRadius: 0.1)]),
                                    )
                                  ],
                                ),
                              ),
<<<<<<< HEAD
                            )),
=======
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_rounded,size: 21),
                                  Text("Search",style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: baseFont,
                                      shadows: [Shadow(
                                          color: Colors.black,
                                          blurRadius:0.1
                                      )]
                                  ),)
                                ],
                              ),
                            )*/
                          )),

                      Visibility(
                        visible: _userFound && !_validatePhn,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),

                                  //----Name-----
                                  LabelText(text: "Emoplyee Name :"),
                                  TextFeildNewUser(
                                    hintText: "Enter Employee name",
                                    Controller: _name01,
                                    onChanged: (value) {},
                                    enable: _activeUser,
                                    etext: _validateEditUser && _name01.text.trim().isEmpty
                                        ? "Please Enter the name"
                                        : "",
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //----empRegId------
                                  LabelText(text: "Emoplyee Regestred ID[Company ID]:"),
                                  TextFeildNewUser(
                                    hintText: "Enter empRegID",
                                    Controller: _empRegId01,
                                    onChanged: (value) {},
                                    enable: _activeUser,
                                    etext: _validateEditUser && _empRegId01.text.trim().isEmpty
                                        ? "Please Enter the empRegID"
                                        : "",
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  //------email------
                                  LabelText(text: "Employee E-Mail :"),
                                  TextFeildNewUser(
                                    hintText: "Enter Employee E-Mail",
                                    Controller: _email01,
                                    onChanged: (value) {},
                                    enable: _activeUser,
                                    etext: _validateEditUser && _email01.text.trim().isEmpty
                                        ? "Please Enter the E-Mail"
                                        : "",
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  //-----Contact ------
                                  LabelText(text: "Employee Phone number :"),
                                  TextFeildNewUser(
                                    hintText: "Enter Employee Password",
                                    Controller: _contact01,
                                    onChanged: (value) {},
                                    enable: _activeUser,
                                    etext: _validateEditUser && _contact01.text.trim().isEmpty
                                        ? "Please Enter the Phone Number"
                                        : "",
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  //----DesignationID---- [DROPDOWN]
                                  GestureDetector(
                                    child: PrimeryDropDownButton(
                                      isEnabled: _activeUser,
                                      tail: ErrorContainer(
                                          show: _validateDropDown, errorMsg: "Please Select the Designation"),
                                      mainText: "Select the desgination",
                                      text: designation01.Text != ""
                                          ? designation01.getText
                                          : "Select The Designation",
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: darkBg,
                                      ),
                                      press: () async {
                                        await BottomSheet_Widget(context, [
                                          Column(
                                            children: [
                                              MapListItemBuilder(
                                                listItems: designationRoles,
                                                press: () {},
                                                selected: designation01,
                                              )
                                            ],
                                          )
                                        ]);
                                        setState(() {});
                                        printFunc("Designation Demo ${designation01.obj}");
                                      },
                                    ),
                                  ),

                                  Visibility(
                                      visible: _userFound && !_validatePhn,
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Column(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),

                                                  //----Name-----
                                                  LabelText(text: "Emoplyee Name :"),
                                                  TextFeildNewUser(
                                                    hintText: "Enter Employee name",
                                                    Controller: _name01,
                                                    onChanged: (value) {},
                                                    enable: _activeUser,
                                                    etext: _validateEditUser && _name01.text.trim().isEmpty
                                                        ? "Please Enter the name"
                                                        : "",
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),

                                                  //----empRegId------
                                                  LabelText(text: "Emoplyee Regestred ID[Company ID]:"),
                                                  TextFeildNewUser(
                                                    hintText: "Enter empRegID",
                                                    Controller: _empRegId01,
                                                    onChanged: (value) {},
                                                    enable: _activeUser,
                                                    etext:
                                                        _validateEditUser && _empRegId01.text.trim().isEmpty
                                                            ? "Please Enter the empRegID"
                                                            : "",
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),

                                                  //------email------
                                                  LabelText(text: "Employee E-Mail :"),
                                                  TextFeildNewUser(
                                                    hintText: "Enter Employee E-Mail",
                                                    Controller: _email01,
                                                    onChanged: (value) {},
                                                    enable: _activeUser,
                                                    etext: _validateEditUser && _email01.text.trim().isEmpty
                                                        ? "Please Enter the E-Mail"
                                                        : "",
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),

                                                  //-----Contact ------
                                                  LabelText(text: "Employee Phone number :"),
                                                  TextFeildNewUser(
                                                    hintText: "Enter Employee Password",
                                                    Controller: _contact01,
                                                    onChanged: (value) {},
                                                    enable: _activeUser,
                                                    etext: _validateEditUser && _contact01.text.trim().isEmpty
                                                        ? "Please Enter the Phone Number"
                                                        : "",
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),

                                                  //----DesignationID---- [DROPDOWN]
                                                  GestureDetector(
                                                    child: PrimeryDropDownButton(
                                                      isEnabled: _activeUser,
                                                      tail: ErrorContainer(
                                                          show: _validateDropDown,
                                                          errorMsg: "Please Select the Designation"),
                                                      mainText: "Select the desgination",
                                                      text: designation01.Text != ""
                                                          ? designation01.getText
                                                          : "Select The Designation",
                                                      icon: Icon(
                                                        Icons.keyboard_arrow_down_sharp,
                                                        color: darkBg,
                                                      ),
                                                      press: () async {
                                                        await BottomSheet_Widget(context, [
                                                          Column(
                                                            children: [
                                                              MapListItemBuilder(
                                                                listItems: designationRoles,
                                                                press: () {},
                                                                selected: designation01,
                                                              )
                                                            ],
                                                          )
                                                        ]);
                                                        setState(() {});
                                                        printFunc("Designation Demo ${designation01.obj}");
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),

                                                  // Password and Re-entry Password
                                                  /*
                                      //-----password-----
                                      LabelText(text: "Employee Password :"),
                                      TextFeildNewUser(
                                        hintText: "Enter Employee Password",
                                        Controller: _password01,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: _validateEditUser && _password.text.trim().isEmpty ?"Please Enter the Password" : "",
                                      ),
                                      SizedBox(height: 8,),

                                      //-----password-----
                                      LabelText(text: "Re-Enter Employee Password :"),
                                      TextFeildNewUser(
                                        hintText: "Re-Enter Employee Password",
                                        Controller: _repassword01,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: _validateEditUser && _password.text.trim().isEmpty ?"Please Enter the Password" : "",
                                      ),

                                      */

                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              )),
                                          _activeUser
                                              ? Container(
                                                  padding: EdgeInsets.only(
                                                      top: 15, bottom: 30, left: 15, right: 15),
                                                  child: FittedBox(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        manageUserBtn(
                                                            text: "Update",
                                                            onPress: () {
                                                              ValidateEditUser();
                                                              validateEditDropDown(designation01);
                                                              print(
                                                                  "validate edit User : $_validateEditDropDown");
                                                              printFunc(
                                                                  "Validate Edit Drop Down : ${_validateEditDropDown}");
                                                              printFunc(
                                                                  "${!_validateEditUser && !_validateEditDropDown}");
                                                              if (!_validateEditUser &&
                                                                  !_validateEditDropDown) {
                                                                printFunc("Insid if cond");
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
                                                                          'User Updated Successfully!!',
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
                                                                    duration: Duration(milliseconds: 800),
                                                                  ),
                                                                );
                                                                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AdminMain()));
                                                              } else {
                                                                printFunc("Inside else cond");
                                                              }
                                                            }),
                                                        SizedBox(width: 5),
                                                        manageUserBtn(
                                                            text: "Deactive",
                                                            onPress: () {
                                                              setState(() {
                                                                _activeUser = false;
                                                              });
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: 20,
                                                                      ),
                                                                      Text(
                                                                        'Employee Deactivted',
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
                                                                  margin: EdgeInsets.only(
                                                                      left: 16,
                                                                      right: 16,
                                                                      top: 16,
                                                                      bottom: 21.5),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.only(
                                                                        bottomLeft: Radius.circular(20),
                                                                        bottomRight: Radius.circular(20)),
                                                                  ),
                                                                  duration: Duration(milliseconds: 500),
                                                                ),
                                                              );
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.only(top: 15, bottom: 30),
                                                  child: manageUserBtn(
                                                      text: "Active",
                                                      onPress: () {
                                                        setState(() {
                                                          _activeUser = true;
                                                        });
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  'Employee Activaited',
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
                                                            margin: EdgeInsets.only(
                                                                left: 16, right: 16, top: 16, bottom: 21.5),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius.circular(20),
                                                                  bottomRight: Radius.circular(20)),
                                                            ),
                                                            duration: Duration(milliseconds: 500),
                                                          ),
                                                        );
                                                      }),
                                                )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]))))
        ])));
  }

  void ValidateUser() {
    final Controllers = [
      _name,
      _empRegId,
      _email,
      _contact,
      _password,
      _repassword,
    ];

    printFunc(
        "name : ${_name.text}\n EmpREGID : ${_empRegId.text}\n email : ${_email.text}\n Contact : ${_contact.text}\n password : ${_password.text} \nRePassword : ${_repassword.text}");

    bool hasEmpty = Controllers.any((controller) => controller.text.trim().isEmpty);
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

  void ValidateEditUser() {
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

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _validateEditUser = false;
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

  void validatePhn() {
    final phn = _searchPhn.text.trim();
    printFunc("DEMO DEMO : ${_searchPhn.text.trim().length}");
    printFunc("DEMO DEMO DEMO : ${phn.length != 10}");
    if (phn.length != 10) {
      setState(() {
        _validatePhn = true;
      });
    } else {
      setState(() {
        _validatePhn = false;
      });
    }
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

  void validateEditDropDown(DataController variable) {
    if (variable.getText == "") {
      setState(() {
        _validateEditDropDown = true;
      });
    } else {
      _validateEditDropDown = false;
    }

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _validateDropDown = false;
      });
    });
  }

  void setEmpDetails() async {
    var empObj = await getEmployeeDetail(context, _searchPhn.text);
    printFunc("DEMO EMP OBJ : $empObj \n name : ${empObj?["name"]}");

    if (empObj == null) {
      printFunc("Inside is cond");
      setState(() {
        _userFound = false;
      });
    } else {
      setState(() {
        _userFound = true;
      });
      setState(() {
        _name01.text = empObj["name"];
        _empRegId01.text = empObj["empRegisteredId"];
        _email01.text = empObj["email"];
        _contact01.text = empObj["phone"];
        designation01.setText = empObj["designation"];

        designation01.setobj = designationRoles[
            empObj["designation"]]; //Designation.getEmpDetails(int.parse(empObj["designationCode"]));
      });
      printFunc("Inside else cond");
      if ((empObj["status"]).toLowerCase() == "active") {
        setState(() {
          _activeUser = true;
        });
      } else {
        setState(() {
          _activeUser = false;
        });
      }
    }
    printFunc("Name01 : ${_name01.text}");
    printFunc("EMP DETAILS OBJECT : ${designation01.obj}");
  }
}
