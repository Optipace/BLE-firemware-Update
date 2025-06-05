import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';

class Dashboard extends StatelessWidget {
  final String text;
  final Widget child;
  final bool? userProfile;
  final Function? onLogout;

  Dashboard({
    required this.text,
    this.userProfile = false,
    required this.child,
    this.onLogout,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    printFunc("DEMO IN DASHBOARD : ${sharedPreferences.toString()}");
    // TODO: implement build
    return Scaffold(
      // Createing Key
      key: _scaffoldKey,
      drawer: UserProfileSlider(context, onLogout),
      body: Column(
        children: [
          Container(
            height: size.height / 3.5 + 30,
            child: Stack(
              children: [
                Container(
                  color: lightBg,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: size.height / 3.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: darkBg,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(300),
                          bottomRight: Radius.circular(300),
                        ),
                        border: Border.all(color: Colors.black, width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: darkBg,
                            blurRadius: 30,
                          )
                        ]),
                  ),
                ),

                // View Profile
                userProfile == true
                    ? Positioned(
                        top: size.height * 0.05,
                        left: 10,
                        child: IconButton(
                            onPressed: () {
                              // Useing key
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            icon: Icon(
                              CupertinoIcons.line_horizontal_3_decrease_circle_fill,
                              size: 40,
                              color: lightBg,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 2.5,
                                )
                              ],
                            )))
                    : SizedBox(),
                Container(
                  padding: EdgeInsets.only(top: size.height * 0.1),
                  width: size.width,
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 34,
                          color: lightBg,
                          fontFamily: baseFont,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          backgroundColor: darkBg,
                          shadows: [
                            Shadow(
                              blurRadius: 2,
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: lightBg,
                  child: SingleChildScrollView(child: child)))
        ],
      ),
    );
  }
}

UserProfileSlider(context, Function? onlogout) {
  return Drawer(
    width: size.width * 0.75,
    elevation: 20,
    backgroundColor: lightBg,
    child: SafeArea(
        child: Column(
      children: [
        // Icon
        Padding(
            padding: EdgeInsets.only(top: size.height * 0.05),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: darkBg,
              child: Center(
                child: Icon(
                  Icons.person,
                  color: lightBg,
                  size: 58,
                ),
              ),
            )

            /* Icon(CupertinoIcons.person_circle_fill,color: darkBg,size: 100,shadows: [
                    Shadow(color: Colors.black,blurRadius: 0.5,offset: Offset(0.4, 0.4))
                  ])*/
            ),
        SizedBox(
          height: 20,
        ),

        // Name
        Text("${sharedPreferences.getString("name")}",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                fontFamily: baseFont,
                color: darkBg,
                shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.4))])),
        Divider(),

        // Phone number, mail and Desiganation
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            "${sharedPreferences.getString("designation")}",
                            style: TextStyle(
                                fontFamily: baseFont,
                                color: darkBg,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 0.3,
                                    offset: Offset(0.5, 0.4),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.phone,
                            color: darkBg,
                            size: 20,
                            shadows: [Shadow(color: darkBg, blurRadius: 0.5, offset: Offset(0.4, 0.4))],
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${sharedPreferences.getString("phone")}",
                            style: TextStyle(
                                fontFamily: baseFont,
                                color: darkBg,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 0.3,
                                    offset: Offset(0.5, 0.4),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.mail,
                              color: darkBg,
                              size: 20,
                              shadows: [Shadow(color: darkBg, blurRadius: 0.5, offset: Offset(0.4, 0.4))]),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${sharedPreferences.getString("email")}",
                            style: TextStyle(
                                fontFamily: baseFont,
                                color: darkBg,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 0.3,
                                    offset: Offset(0.5, 0.4),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Divider(),

        // Logout and Version at bottom
        ListTile(
          leading: Icon(Icons.logout,
              color: darkBg,
              size: 28,
              shadows: [Shadow(color: darkBg, blurRadius: 0.5, offset: Offset(0.4, 0.4))]),
          title: Text(
            "Logout",
            style: TextStyle(
                fontFamily: baseFont,
                color: darkBg,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 0.3,
                    offset: Offset(0.5, 0.4),
                  )
                ]),
          ),
          onTap: onlogout != null
              ? onlogout as void Function()
              : () async {
                  Navigator.of(context).pop(); // Close the drawer first
                  await Future.delayed(Duration(milliseconds: 300)); // Small delay for smooth UX
                  await LogOut(context);
                },
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Version ${appVersion}",
            style: TextStyle(color: secondaryText, fontFamily: baseFont, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    )),
  );
}
