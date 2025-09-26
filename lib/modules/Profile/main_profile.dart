import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/api/api.dart';

class mainProfile extends StatefulWidget {
  const mainProfile({super.key});

  @override
  State<mainProfile> createState() => _mainProfileState();
}

class _mainProfileState extends State<mainProfile> {
  // Controllers for update password
  final _formKey = GlobalKey<FormState>();

  TextEditingController _Phno = TextEditingController();
  TextEditingController _Password = TextEditingController();
  TextEditingController _Repassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Phno.text = UserData().phone;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkBg,
        child: Column(
          children: [
            Container(
              height: screenSize.height * 0.17,
              // top section
              width: screenSize.width,
              padding:
              const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF56B6C2), // a lighter shade for smooth effect
                    Color(0xFF358A94),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              size: 30,
                              color: Colors.white,
                            )),
                        SizedBox(
                            width: 5
                        ),
                        Text(
                          "My Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
            //main content
            Expanded(
                child: Container(
                  // height: screenSize.height * 1,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: lightBg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child:SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Name
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: darkBg.withOpacity(0.1)),
                          margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          padding: EdgeInsets.all(20),
                          width: screenSize.width * 0.85,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("PROFILE DETAILS",style: TextStyle(color: darkBg, fontSize: 21,fontWeight: FontWeight.w800,shadows: [Shadow(color: Colors.black,blurRadius: 0.2 )]),),
                              ),
                              Divider(color: darkBg,),
                              SizedBox(height: 8,),

                              //Name
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.person,size: 28,color: darkBg,),
                                    SizedBox(width: 15,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("User Name",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: darkBg),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(UserData().name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: darkBg,),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              //Phone number
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.phone,size: 26,color: darkBg,),
                                    SizedBox(width: 15,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Phone Number",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: darkBg),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(UserData().phone,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: darkBg,),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              //Mail
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.mail,size: 24,color: darkBg,),
                                    SizedBox(width: 15,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Mail-Id",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: darkBg),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(UserData().email,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: darkBg,),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              //EmpReg-Id
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.badge,size: 24,color: darkBg,),
                                    SizedBox(width: 15,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("EmpReg-Id",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: darkBg),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(UserData().empRegisteredId,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: darkBg,),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              //Designation
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.work_rounded,size: 24,color: darkBg,),
                                    SizedBox(width: 15,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Designation",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: darkBg),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(UserData().designation,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: darkBg,),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              //Device-Id
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.device_phone_portrait,size: 24,color: darkBg,),
                                    SizedBox(width: 15,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Device-Id",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: darkBg),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(UserData().UUID,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: darkBg,),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),

                              Divider(color: darkBg,),
                              Padding(
                                padding: const EdgeInsets.only(top: 5,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /*ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: darkBg,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 14),

                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => EditProfile()));
                                      },
                                      child: Text(
                                        "Edit Profile",
                                        textAlign: TextAlign.center,
                                        style:
                                        TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                    ),*/
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: darkBg,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 14),
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    side: BorderSide(
                                                        width: 0.5, color: darkBg)),
                                                child: Container(
                                                  width: screenSize.width * 0.8,
                                                  height: screenSize.height / 1.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: [
                                                        //Title
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(vertical: 10),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(top: 20),
                                                                child: Text(
                                                                  "Update Password",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      baseFont,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                      fontSize: 28,
                                                                      color: darkBg),
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
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.fromLTRB(
                                                              20, 10, 20, 10),
                                                          child: Form(
                                                            key: _formKey,
                                                            autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                            child: Column(
                                                              mainAxisSize:
                                                              MainAxisSize.min,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                // Phone Number
                                                                Text(
                                                                  "Phone number",
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      color: darkBg,
                                                                      fontFamily:
                                                                      baseFont,
                                                                      shadows: [
                                                                        Shadow(
                                                                          color: Colors
                                                                              .black,
                                                                          blurRadius:
                                                                          0.2,
                                                                          // offset: Offset(0.5, 0.5)
                                                                        )
                                                                      ]),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller: _Phno,
                                                                  keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      color: darkBg,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      fontFamily:
                                                                      baseFont,
                                                                      letterSpacing:
                                                                      0.2),
                                                                  decoration:
                                                                  InputDecoration(
                                                                    hintText:
                                                                    "Re-enter Password",
                                                                    hintStyle: TextStyle(
                                                                        fontSize: 16,
                                                                        color: Color(
                                                                            0xFF9AC4C9),
                                                                        fontFamily:
                                                                        baseFont,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                    contentPadding:
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                        10,
                                                                        horizontal:
                                                                        20),
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                            darkBg,
                                                                            width:
                                                                            0.5),
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8))),
                                                                    disabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: Colors
                                                                                .black,
                                                                            width: 1),
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8))),
                                                                    focusColor:
                                                                    Colors.black,
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)),
                                                                        borderSide:
                                                                        BorderSide(
                                                                            width:
                                                                            1,
                                                                            color:
                                                                            darkBg)),
                                                                    focusedErrorBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)),
                                                                        borderSide: BorderSide(
                                                                            width: 1,
                                                                            color: Colors
                                                                                .black)),
                                                                    filled: true,
                                                                    fillColor: lightBg,
                                                                  ),
                                                                  enabled: false,
                                                                  validator: (value) {
                                                                    if (value == null ||
                                                                        value
                                                                            .trim()
                                                                            .isEmpty) {
                                                                      return "Phone number is required";
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),

                                                                // Password
                                                                Text(
                                                                  "Password",
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      color: darkBg,
                                                                      fontFamily:
                                                                      baseFont,
                                                                      shadows: [
                                                                        Shadow(
                                                                          color: Colors
                                                                              .black,
                                                                          blurRadius:
                                                                          0.2,
                                                                          // offset: Offset(0.5, 0.5)
                                                                        )
                                                                      ]),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller: _Password,
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      color: darkBg,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      fontFamily:
                                                                      baseFont,
                                                                      letterSpacing:
                                                                      0.2),
                                                                  decoration:
                                                                  InputDecoration(
                                                                    hintText:
                                                                    "Enter the Password",
                                                                    hintStyle: TextStyle(
                                                                        fontSize: 16,
                                                                        color: Color(
                                                                            0xFF9AC4C9),
                                                                        fontFamily:
                                                                        baseFont,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                    contentPadding:
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                        10,
                                                                        horizontal:
                                                                        20),
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                            darkBg,
                                                                            width:
                                                                            0.5),
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8))),
                                                                    disabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: Colors
                                                                                .black,
                                                                            width: 1),
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8))),
                                                                    focusColor:
                                                                    Colors.black,
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)),
                                                                        borderSide:
                                                                        BorderSide(
                                                                            width:
                                                                            1,
                                                                            color:
                                                                            darkBg)),
                                                                    focusedErrorBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)),
                                                                        borderSide: BorderSide(
                                                                            width: 1,
                                                                            color: Colors
                                                                                .black)),
                                                                    errorBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)),
                                                                        borderSide: BorderSide(
                                                                            width: 1,
                                                                            color: Color(
                                                                                0xFFFF8A80))),
                                                                  ),
                                                                  validator: (value) {
                                                                    if (value == null ||
                                                                        value
                                                                            .trim()
                                                                            .isEmpty) {
                                                                      return "Password is required";
                                                                    }
                                                                    //password length
                                                                    /*if (value.length < 6) {
                                              return "Password must be at least 6 characters";
                                            } */

                                                                    return null;
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),

                                                                // Re-Password
                                                                Text(
                                                                  "Re-Entry Password",
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      color: darkBg,
                                                                      fontFamily:
                                                                      baseFont,
                                                                      shadows: [
                                                                        Shadow(
                                                                          color: Colors
                                                                              .black,
                                                                          blurRadius:
                                                                          0.2,
                                                                          // offset: Offset(0.5, 0.5)
                                                                        )
                                                                      ]),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                  _Repassword,
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      color: darkBg,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      fontFamily:
                                                                      baseFont,
                                                                      letterSpacing:
                                                                      0.2),
                                                                  decoration:
                                                                  InputDecoration(
                                                                    hintText:
                                                                    "Re-Enter the Password",
                                                                    hintStyle: TextStyle(
                                                                        fontSize: 16,
                                                                        color: Color(
                                                                            0xFF9AC4C9),
                                                                        fontFamily:
                                                                        baseFont,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                    contentPadding:
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                        10,
                                                                        horizontal:
                                                                        20),
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                            darkBg,
                                                                            width:
                                                                            0.5),
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8))),
                                                                    disabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: Colors
                                                                                .black,
                                                                            width: 1),
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8))),
                                                                    focusColor:
                                                                    Colors.black,
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)),
                                                                        borderSide:
                                                                        BorderSide(
                                                                            width:
                                                                            1,
                                                                            color:
                                                                            darkBg)),
                                                                    focusedErrorBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)),
                                                                        borderSide: BorderSide(
                                                                            width: 1,
                                                                            color: Colors
                                                                                .black)),
                                                                    errorBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)),
                                                                        borderSide: BorderSide(
                                                                            width: 1,
                                                                            color: Color(
                                                                                0xFFFF8A80))),
                                                                  ),
                                                                  validator: (value) {
                                                                    if (value == null ||
                                                                        value
                                                                            .trim()
                                                                            .isEmpty) {
                                                                      return "Please re-enter password";
                                                                    }
                                                                    if (value !=
                                                                        _Password
                                                                            .text) {
                                                                      return "Passwords do not match";
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        //Btns
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        ElevatedButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(darkBg),
                                                              minimumSize:
                                                              MaterialStateProperty
                                                                  .all(Size(100,
                                                                  40)), // width: 80, height: 40
                                                            ),
                                                            onPressed: () async {
                                                              if (_formKey.currentState!
                                                                  .validate()) {
                                                                //call Update_password API
                                                                if (await updatePassword(
                                                                    context,
                                                                    phno: _Phno.text
                                                                        .trim()
                                                                        .toString(),
                                                                    pwd: _Password.text
                                                                        .trim()
                                                                        .toString())) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  _Password.clear();
                                                                  _Repassword.clear();
                                                                }
                                                              }
                                                            },
                                                            child: Text(
                                                              "Update",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontFamily: baseFont,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  shadows: [
                                                                    Shadow(
                                                                      color:
                                                                      Colors.white,
                                                                      blurRadius: 0.2,
                                                                    )
                                                                  ]),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Text(
                                        "Update\nPassword",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Edit Btn



                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

