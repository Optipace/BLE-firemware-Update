import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/Profile/edit_profile.dart';
import 'package:tracker_firmware/modules/admin/api/api.dart';

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
              height: screenSize.height * 0.4, // top section
              width: screenSize.width,
              padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 10),
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
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.arrow_back_outlined,size: 30, color: Colors.white,)),
                      SizedBox(width: 10,),
                      Text(
                        "User Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: screenSize.width * 0.13,
                          backgroundColor: Colors.white60,
                          child: Icon(Icons.person,
                              size: screenSize.width * 0.15, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 12),
                        Text(
                            UserData().name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18)),
                        SizedBox(height: 4),
                        Text(UserData().designation,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                                fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
                child: Container(
                  height: screenSize.height * 0.7,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: lightBg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      //Edit Btn
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkBg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                              ),
                              onPressed: ()  {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditProfile()));
                              },
                              child:  Text(
                                "Edit",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //main content
                      Expanded(
                          child: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              thumbColor: MaterialStateProperty.all(darkBg),   // scrollbar thumb color
                              trackColor: MaterialStateProperty.all(Colors.black), // scrollbar track color
                              trackBorderColor: MaterialStateProperty.all(Colors.transparent),
                              thickness: MaterialStateProperty.all(6), // width of scrollbar
                              radius: const Radius.circular(8), // rounded edges
                            ),
                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Phone
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                                      margin: EdgeInsets.fromLTRB(5, 20, 15, 0),
                                      width: screenSize.width * 0.85,
                                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Phone Number",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Container(
                                                width: screenSize.width * 0.85 - 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(UserData().phone,
                                                        style:
                                                        TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //email
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                                      margin: EdgeInsets.fromLTRB(5, 20, 15, 0),
                                      width: screenSize.width * 0.85,
                                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Email-Id",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Container(
                                                width: screenSize.width * 0.85 - 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(UserData().email,
                                                        style:
                                                        TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //empRegisteredId
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                                      margin: EdgeInsets.fromLTRB(5, 20, 15, 0),
                                      width: screenSize.width * 0.85,
                                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "EmpReg-Id",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Container(
                                                width: screenSize.width * 0.85 - 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(UserData().empRegisteredId,
                                                        style:
                                                        TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //designation
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                                      margin: EdgeInsets.fromLTRB(5, 20, 15, 0),
                                      width: screenSize.width * 0.85,
                                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Designation",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Container(
                                                width: screenSize.width * 0.85 - 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(UserData().designation,
                                                        style:
                                                        TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //_UUID
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                                      margin: EdgeInsets.fromLTRB(5, 20, 15, 10),
                                      width: screenSize.width * 0.85,
                                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Device-Id",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Container(
                                                width: screenSize.width * 0.85 - 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(UserData().UUID,
                                                        style:
                                                        TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                      )
                    ],
                  ),
                )
            ),

          ],
        ),
      ),
    );

  }
}

/*
Expanded(
              child:Container(
                // margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                padding: EdgeInsets.symmetric(vertical: 25),
                height: screenSize.height * 0.7,
                width: screenSize.width,

                decoration: BoxDecoration(
                  color: lightBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),

                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkBg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                                // minimumSize: const Size(0, 0), // removes default min height
                              ),
                              onPressed: () async {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditProfile()));
                              },
                              child: Text(
                                "Edit\nProfile",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Phone
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                        margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
                        width: screenSize.width * 0.85,
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Phone Number",
                                  style: TextStyle(
                                    color: darkBg,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: screenSize.width * 0.85 - 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(UserData().phone,
                                          style:
                                          TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //email
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                        margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
                        width: screenSize.width * 0.85,
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Email-Id",
                                  style: TextStyle(
                                    color: darkBg,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: screenSize.width * 0.85 - 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(UserData().email,
                                          style:
                                          TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //empRegisteredId
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                        margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
                        width: screenSize.width * 0.85,
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "EmpReg-Id",
                                  style: TextStyle(
                                    color: darkBg,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: screenSize.width * 0.85 - 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(UserData().empRegisteredId,
                                          style:
                                          TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //designation
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                        margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
                        width: screenSize.width * 0.85,
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Designation",
                                  style: TextStyle(
                                    color: darkBg,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: screenSize.width * 0.85 - 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(UserData().designation,
                                          style:
                                          TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //_UUID
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkBg.withOpacity(0.2)),
                        margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
                        width: screenSize.width * 0.85,
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Device-Id",
                                  style: TextStyle(
                                    color: darkBg,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: screenSize.width * 0.85 - 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(UserData().UUID,
                                          style:
                                          TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
*/
