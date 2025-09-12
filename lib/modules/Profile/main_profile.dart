import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/Profile/edit_profile.dart';
import 'package:tracker_firmware/modules/admin/api/api.dart';
import 'package:tracker_firmware/widgets/internetStatusWatcher.dart';

class mainProfile extends StatefulWidget {
  const mainProfile({super.key});

  @override
  State<mainProfile> createState() => _mainProfileState();
}

class _mainProfileState extends State<mainProfile> {
  final ScrollController _scrollController = ScrollController();

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
                  child:Column(
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
                                  ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}

