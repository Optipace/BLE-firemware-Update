// import 'dart:html';

// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/admin_main.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';

import '../../../widgets/buttons.dart';
import '../../../widgets/textFields.dart';

class AdminNewUser extends StatefulWidget{
  @override
  State<AdminNewUser> createState() => AdminNewUserState();

}
class AdminNewUserState extends State<AdminNewUser>{

  bool validateUser = false;
  int selectedbutton =1;
  bool _userFound = false;
  bool ValidatePhn = false;

  //----- Controllers for new / edit entry
  TextEditingController _name = TextEditingController();
  TextEditingController _empRegId = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repassword = TextEditingController();
  TextEditingController _createdBy = TextEditingController();
  TextEditingController _modifiedBy = TextEditingController();
  TextEditingController _designationId = TextEditingController();
  int? _selectedDesgId ;
  String? selectedRole;
  TextEditingController _deviceId = TextEditingController();

  TextEditingController _searchPhn = TextEditingController();




  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("New-User",style: TextStyle(fontFamily: baseFont,fontWeight: FontWeight.w800, fontSize: 22,color: lightBg),),
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
                      width: 0.5,
                    ),
                    borderRadius:  BorderRadius.all(
                        Radius.circular(20)
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
                          width: size.width * 0.48,
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
                                    Image.asset('assets/image/user.png',
                                      width: 32,
                                      height: 32,
                                      color: selectedbutton == 1 ? lightBg : darkBg,
                                    ),

                                    Text("New User",
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
                          width: size.width/2.1,
                          height: size.height/9,
                          decoration: BoxDecoration(
                              color: selectedbutton == 2  ? darkBg : lightBg,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
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
                                    Image.asset('assets/image/editUser.png',
                                      width: 32,
                                      height: 32,
                                      color: selectedbutton == 1 ? darkBg : lightBg,
                                    ),
                                    Text("Field User",
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

            selectedbutton == 1 ?
            //------------------- NEW USER  ------------------------
            Card(
              elevation: 5,
              margin: EdgeInsets.only(
                  left: 15,top: 10,right: 15,bottom: 20
              ),
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
                              //----Name-----
                              LabelText(text: "Emoplyee Name :"),
                              SizedBox(height: 4,),
                              TextFeildNewUser(
                                hintText: "Enter Empolyee name",
                                Controller: _name,
                                onChanged: (value){},
                                enable: true,
                                etext: validateUser && _name.text.trim().isEmpty ?"Please Enter the name" : "",
                              ),
                              SizedBox(height: 10,),

                              //----empRegId------
                              LabelText(text: "Emoplyee Regestred ID[Company ID]:"),
                              SizedBox(height: 4,),
                              TextFeildNewUser(
                                hintText: "Enter empRegID",
                                Controller: _empRegId,
                                onChanged: (value){},
                                enable: true,
                                etext: validateUser && _empRegId.text.trim().isEmpty ?"Please Enter the empRegID" : "",
                              ),
                              SizedBox(height: 8,),

                              //------email------
                              LabelText(text: "Empolyee E-Mail :"),
                              SizedBox(height: 4,),
                              TextFeildNewUser(
                                hintText: "Enter Empolyee E-Mail",
                                Controller: _email,
                                onChanged: (value){},
                                enable: true,
                                etext: validateUser && _email.text.trim().isEmpty ?"Please Enter the E-Mail" : "",
                              ),
                              SizedBox(height: 8,),

                              //-----Contact ------
                              LabelText(text: "Empolyee Phone number :"),
                              SizedBox(height: 4,),
                              TextFeildNewUser(
                                hintText: "Enter Empolyee Phone number",
                                Controller: _contact,
                                onChanged: (value){},
                                enable: true,
                                etext: validateUser && _contact.text.trim().isEmpty ?"Please Enter the Phone Number" : "",
                              ),
                              SizedBox(height: 8,),

                              //----DesignationID---- [DROPDOWN]
                              LabelText(text: "Empolyee DesignationID :"),
                              SizedBox(height: 4,),
                              TextFeildNewUser(
                                hintText: "Enter Empolyee Designation ID",
                                Controller: _designationId,
                                onChanged: (value){},
                                enable: true,
                                etext: validateUser && _designationId.text.trim().isEmpty ?"Please Enter the Designation ID" : "",
                              ),
                              SizedBox(height: 8,),

                              //-----password-----
                              LabelText(text: "Empolyee Password :"),
                              SizedBox(height: 4,),
                              TextFeildNewUser(
                                hintText: "Enter Empolyee Password",
                                Controller: _password,
                                onChanged: (value){},
                                enable: true,
                                etext: validateUser && _password.text.trim().isEmpty ?"Please Enter the Password" : "",
                              ),
                              SizedBox(height: 8,),

                              //-----password-----
                              LabelText(text: "Re-Enter Empolyee Password :"),
                              SizedBox(height: 4,),
                              TextFeildNewUser(
                                hintText: "Re-Enter Empolyee Password",
                                Controller: _repassword,
                                onChanged: (value){},
                                enable: true,
                                etext: validateUser && _password.text.trim().isEmpty ?"Please Enter the Password" : "",
                              ),
                              SizedBox(height: 15,),



                            ],
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: manageUserBtn(
                            text: "ADD USER",
                            onPress: (){
                              ValidateUser();
                              print("validate User : $validateUser");
                              if(!validateUser || true){
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
                      )
                    ],
                  ),
                ),
              ),
            )
            //------------------- EDIT USER ------------------------
                :Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // <-- radius here
              ),

              child:  Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Title
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text("Empolye's Phone number",
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
                      //TextField
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 10,),
                              //----Name-----

                              TextFeildNewUser(
                                hintText: "Enter Phone number",
                                Controller: _searchPhn,
                                maxLength: 10,
                                type: TextInputType.number,
                                onChanged: (value){},
                                enable: true,
                                etext: ValidatePhn ?"Please Enter 10 digit Phone number" : "",
                              ),
                              SizedBox(height: 10,),


                            ],
                          )
                      ),
                      //Search btn
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            width: size.width/3,      // Set your desired width
                            height: 40,
                            child: ElevatedButton(
                              onPressed:(){
                                validatePhn();
                                printFunc("DEMO VALIDATE USER : $ValidatePhn");
                                //api call and store in a bool var so then if the bool is true then olny set the userFound to true otherwise set to false
                               if(_searchPhn.text.trim().length == 10){
                                 setState(() {
                                   _userFound= true;
                                 });
                               }else{
                                 setState(() {
                                   _userFound= false;
                                 });
                               }
                              },
                              style: ButtonStyle(

                                backgroundColor: MaterialStateProperty.all(darkBg),
                                elevation: MaterialStateProperty.all(5),
                                shadowColor: MaterialStateProperty.all(darkBg),
                                shape:MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: darkBg,
                                          width: 1
                                      )
                                  ),
                                ),
                              ),
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
                            ),
                          )
                      ),

                      Visibility(
                          visible: _userFound,
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20 ,),
                                      //----Name-----
                                      LabelText(text: "Emoplyee Name :"),
                                      SizedBox(height: 4,),
                                      TextFeildNewUser(
                                        hintText: "Enter Empolyee name",
                                        Controller: _name,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: validateUser && _name.text.trim().isEmpty ?"Please Enter the name" : "",
                                      ),
                                      SizedBox(height: 10,),

                                      //----empRegId------
                                      LabelText(text: "Emoplyee Regestred ID[Company ID]:"),
                                      SizedBox(height: 4,),
                                      TextFeildNewUser(
                                        hintText: "Enter empRegID",
                                        Controller: _empRegId,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: validateUser && _empRegId.text.trim().isEmpty ?"Please Enter the empRegID" : "",
                                      ),
                                      SizedBox(height: 8,),

                                      //------email------
                                      LabelText(text: "Empolyee E-Mail :"),
                                      SizedBox(height: 4,),
                                      TextFeildNewUser(
                                        hintText: "Enter Empolyee E-Mail",
                                        Controller: _email,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: validateUser && _email.text.trim().isEmpty ?"Please Enter the E-Mail" : "",
                                      ),
                                      SizedBox(height: 8,),

                                      //-----Contact ------
                                      LabelText(text: "Empolyee Phone number :"),
                                      SizedBox(height: 4,),
                                      TextFeildNewUser(
                                        hintText: "Enter Empolyee Phone number",
                                        Controller: _contact,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: validateUser && _contact.text.trim().isEmpty ?"Please Enter the Phone Number" : "",
                                      ),
                                      SizedBox(height: 8,),

                                      //----DesignationID---- [DROPDOWN]
                                      LabelText(text: "Empolyee DesignationID :"),
                                      SizedBox(height: 4,),
                                      TextFeildNewUser(
                                        hintText: "Enter Empolyee Designation ID",
                                        Controller: _designationId,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: validateUser && _designationId.text.trim().isEmpty ?"Please Enter the Designation ID" : "",
                                      ),
                                      SizedBox(height: 8,),

                                      //-----password-----
                                      LabelText(text: "Empolyee Password :"),
                                      SizedBox(height: 4,),
                                      TextFeildNewUser(
                                        hintText: "Enter Empolyee Password",
                                        Controller: _password,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: validateUser && _password.text.trim().isEmpty ?"Please Enter the Password" : "",
                                      ),
                                      SizedBox(height: 8,),

                                      //-----password-----
                                      LabelText(text: "Re-Enter Empolyee Password :"),
                                      SizedBox(height: 4,),
                                      TextFeildNewUser(
                                        hintText: "Re-Enter Empolyee Password",
                                        Controller: _repassword,
                                        onChanged: (value){},
                                        enable: true,
                                        etext: validateUser && _password.text.trim().isEmpty ?"Please Enter the Password" : "",
                                      ),
                                      SizedBox(height: 15,),





                                    ],
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: manageUserBtn(
                                    text: "Update User",
                                    onPress: (){
                                      ValidateUser();
                                      print("validate User : $validateUser");
                                      if(!validateUser || true){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:Row(
                                              children: [
                                                Icon(CupertinoIcons.checkmark_seal_fill,color: lightBg,),
                                                SizedBox(width: 15,),
                                                Text('User Updated Successfully!!',
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
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AdminMain()));

                                      }
                                    }
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void ValidateUser(){
    final Controllers = [
      _name,
      _empRegId,
      _email,
      _contact,
      _password,
      _createdBy,
      _modifiedBy,
      _designationId,
    ];

    for(var controller in Controllers){
      if(controller.text.trim().isEmpty){
        setState(() {
          validateUser =true;
        });
      }
    }
    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        validateUser = false;
      });
    });
  }

  void validatePhn() {
    final phn = _searchPhn.text.trim();
    printFunc("DEMO DEMO : ${_searchPhn.text.trim().length}");
    printFunc("DEMO DEMO DEMO : ${phn.length != 10 }");
    if(phn.length != 10){
      setState(() {
        ValidatePhn = true;

      });
    }
    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        ValidatePhn = false;
      });
    });
  }
}