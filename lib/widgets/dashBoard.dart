import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/services/apiCall/logIn.dart';
import 'package:tracker_firmware/widgets/internetStatusWatcher.dart';

class Dashboard extends StatelessWidget {
  final String text;
  final Widget child;
  final bool? userProfile;
  final Function? onLogout;
  final Widget? add_Device;
  final Widget? view_Profile;
  final Widget? add_client;
  final Widget? add_battery;
  final Widget? add_designation;
  final Widget? floatingBtn;

  Dashboard({
    required this.text,
    this.userProfile = false,
    required this.child,
    this.onLogout,
    this.add_Device,
    this.view_Profile,
    this.add_client,
    this.add_battery,
    this.add_designation,
    this.floatingBtn
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    printFunc("DEMO IN DASHBOARD : ${sharedPreferences.toString()}");
    // TODO: implement build
    return Scaffold(
      // Createing Key
      key: _scaffoldKey,
      floatingActionButton: floatingBtn,
      drawer: UserProfileSlider(context, onLogout,add_Device,view_Profile,add_client,add_battery,add_designation,),
      body: InternetStatusWatcher(
        child: Column(
          children: [
            Container(
              height: screenSize.height / 3.5 + 30,
              child: Stack(
                children: [
                  Container(
                    color: lightBg,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: screenSize.height / 3.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF56B6C2),
                              Color(0xFF358A94),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
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
                          top: screenSize.height * 0.05,
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
                    padding: EdgeInsets.only(top: screenSize.height * 0.1),
                    width: screenSize.width,
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
                            // backgroundColor: darkBg,
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
      ),
    );
  }
}

UserProfileSlider(context, Function? onlogout, Widget? add_Device,Widget? view_Profile, Widget? add_client,Widget? add_battery, Widget? add_designation) {
  return Drawer(
    width: screenSize.width * 0.75,
    elevation: 100,
    backgroundColor: darkBg.withOpacity(0.8),
    child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            children: [
              // Profile Avatar
              Padding(
                padding: EdgeInsets.only(
                  top: screenSize.height * 0.05,
                  right: 12.0, // Added spacing between avatar and text
                ),
                child: CircleAvatar(
                  radius: 32, // Increased from 30
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: darkBg,
                      size: 40, // Increased from 32
                    ),
                  ),
                ),
              ),

              // User Information
              Expanded( // Added Expanded to prevent overflow
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name
                      Text(
                        UserData().name,
                        style: TextStyle(
                          fontSize: 24, // Reduced from 32
                          fontWeight: FontWeight.w900,
                          fontFamily: baseFont,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 0.5,
                              offset: Offset(0.5, 0.4),
                            ),
                          ],
                        ),
                      ),

                      // User Email
                      SizedBox(height: 4), // Added spacing between name and email
                      Text(
                        UserData().email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: baseFont,
                          color: Colors.white,
                          fontSize: 14, // Reduced from 18
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 0.3,
                              offset: Offset(0.5, 0.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Divider(color: Colors.white,),
        SizedBox(height: 10,),


        // Phone number, mail and Desiganation

        view_Profile??SizedBox(),

        add_Device??SizedBox(),
        // SizedBox(height: 15,),
        // SizedBox(height: 15,),
        add_client??SizedBox(),
        // SizedBox(height: 15,),
        add_battery??SizedBox(),
        // SizedBox(height: 15,),
        add_designation??SizedBox(),
        // SizedBox(height: 15,),
        Container(
          margin: EdgeInsets.only(left: 15),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
            onTap: () async {
            Navigator.of(context, rootNavigator: true).pop(); // Close the drawer first
            await setSharedPreference(await getEmployeeDetail(context, UserData().phone));
            await setUserData();
          },
            child: Row(
              children: [
                Icon(Icons.refresh_outlined,size: 22,color: Colors.white,shadows: [Shadow(
                  color: Colors.black,
                  blurRadius: 0.3,
                  offset: Offset(0.5, 0.4),
                )],),
                SizedBox(width: 20),
                Text(
                  "Refresh",
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
        SizedBox(),

        Spacer(),
        // Divider(color: Colors.white,),

        // Logout and Version at bottom
        // ListTile(
        //   leading: Icon(Icons.logout,
        //       color: Colors.white,
        //       size: 28,
        //       shadows: [Shadow(color: darkBg, blurRadius: 0.5, offset: Offset(0.4, 0.4))]),
        //   title: Row(
        //     children: [
        //       Expanded(
        //         child: Text(
        //           "Logout",
        //           style: TextStyle(
        //               fontFamily: baseFont,
        //               color: Colors.white,
        //               fontSize: 20,
        //               fontWeight: FontWeight.w500,
        //               shadows: [
        //                 Shadow(
        //                   color: Colors.black,
        //                   blurRadius: 0.3,
        //                   offset: Offset(0.5, 0.4),
        //                 )
        //               ]),
        //         ),
        //       ),
        //       IconButton(
        //         onPressed: () async {
        //           Navigator.of(context, rootNavigator: true).pop(); // Close the drawer first
        //           await setSharedPreference(await getEmployeeDetail(context, UserData().phone));
        //           await setUserData();
        //         },
        //         icon: Icon(Icons.refresh_outlined,
        //             color: Colors.white,
        //             size: 28,
        //             shadows: [Shadow(color: darkBg, blurRadius: 0.5, offset: Offset(0.4, 0.4))]),
        //       )
        //     ],
        //   ),
        //   onTap: onlogout != null
        //       ? onlogout as void Function()
        //       : () async {
        //           Navigator.of(context, rootNavigator: true).pop(); // Close the drawer first
        //           await Future.delayed(Duration(milliseconds: 300)); // Small delay for smooth UX
        //           await LogOutUser(context);
        //         },
        // ),

        Container(
          decoration: BoxDecoration(
            color: Colors.redAccent
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop(); // Close the drawer first
                    await Future.delayed(Duration(milliseconds: 300)); // Small delay for smooth UX
                    await LogOutUser(context);
                  },
               child: Text(
                "Logout",
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
              )),
              Icon(Icons.logout,size: 22,color: Colors.white,shadows: [Shadow(
                color: Colors.black,
                blurRadius: 0.3,
                offset: Offset(0.5, 0.4),
              )],),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              "Version ${appVersion}",
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontFamily: baseFont, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    )),
  );
}
