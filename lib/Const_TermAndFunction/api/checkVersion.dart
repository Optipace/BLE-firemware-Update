import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:http/http.dart' as http;
import 'package:version/version.dart';


Future<bool> checkVersion(BuildContext context) async{
  bool isSuccess = false;
  final appVersion = "0.0.1";

  try{
    final userData = await getUserDataFromSharedPref();
    printFunc("USER DATA IN CHECK AUTH : $userData");

    final String? token = userData['accessToken'];

    if (token == null || token.isEmpty) {
      printFunc('No access token available');
      return false;
    }
    final Uri url =  Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.getVersion}');

    final response = await http.get(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },);


    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['response']['code'] == 1 &&
          jsonResponse['data'] != null &&
          jsonResponse['data'].toString().isNotEmpty) {

        Version latest = Version.parse(jsonResponse['data'].toString());
        Version appVer = Version.parse(appVersion.toString());
        print(latest);
        print(appVer);


        if (latest > appVer) {
          if (latest.major > appVer.major) {
            print("Latest version has a MAJOR update");
            //need to be log-out and alert box to update to be needed
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  // title: Text(""),
                  content: Text(
                    "Updated Required!!",
                    style: TextStyle(
                      color: darkBg,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: [
                    //OK btn that goes for next page
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(darkBg),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                    )
                  ],
                  backgroundColor: second_lightBg,
                );
              },
            );
            isSuccess = false;
          } else if (latest.minor > appVer.minor) {
            print("Latest version has a MINOR update");
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  // title: Text(""),
                  content: Text(
                    "Updated Required!!",
                    style: TextStyle(
                      color: darkBg,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: [
                    //OK btn that goes for next page
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(darkBg),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                    )
                  ],
                  backgroundColor: second_lightBg,
                );
              },
            );
            isSuccess = false;
          } else if (latest.patch > appVer.patch) {
            print("Latest version has a PATCH update");
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  // title: Text(""),
                  content: Text(
                    "Updated Required!!",
                    style: TextStyle(
                      color: darkBg,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: [
                    //OK btn that goes for next page
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(darkBg),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                    )
                  ],
                  backgroundColor: second_lightBg,
                );
              },
            );
            isSuccess = false;
          }
        } else {
          print("App is up to date");
          isSuccess = true;
        }
      }
    } else {
      printFunc("Failed to fetch version: ${response.statusCode}");
    }
  } catch (e) {
    printFunc('Error checking auth: $e');
    isSuccess= false;
  }
  return isSuccess;
}



//For reference
/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<bool> checkVersion(BuildContext context, {bool isSeasonDateRequired = true}) async {
  bool isLoading = false;
  if (await isVersionDetailsUpToDate(context, await getDivision())) {
    await getHangamaOnline(context);
    return true;
  }
  try {
    String endPoint = (BaseIP != ""
        ? BaseIP
        : "${(isTesting ? isInternal ? Ip_list_Internal[2] : Ip_list_UIT[2] : BaseAddressLive)}/kok/") +
        ApiEndpoints.version;
    // ComonApi.getVersion;
    printFunc("url version: ");
    printFunc(endPoint);
    printFunc(BaseIP == null);
    printFunc(BaseIP == "");
    if (await checkInternet(context) == 0 ) {
      isLoading = true;
      showAlertProgres(context, "Loading Data...");

      var response = await http
          .get(
        Uri.parse(endPoint),
      )
          .timeout(
        Duration(seconds: 90),
        onTimeout: () {
// Time has run out, do what you wanted to do.
          return http.Response('Error', 198); // Replace 500 with your http code.
        },
      );
      Navigator.of(context, rootNavigator: true).pop();
      isLoading = false;
      printFunc("version responses");
      printFunc("baseIp");
      printFunc(BaseIP);
      printFunc(response.statusCode);
      printFunc(response.body);
      if (BaseIP != "") {
        await getHangamaOnline(context);
      }
      if (response.statusCode == 200) {
        await setUpdateVersionDetails(context, await getDivision());

        printFunc("version responses 200");
        printFunc(response.body);
        var jsonResponse = response.body.toString();
        if (jsonResponse != null && jsonResponse != "") {
          // await Database.database.close();//(Database.dbPath);

          printFunc(jsonResponse.toString());
          printFunc(appVersion);
          // Version latest = Version.parse("0.0.22");
          Version latest = Version.parse(
              jsonResponse.toString()); //.substring(2,jsonResponse.toString().length));//from api
          Version appVer = Version.parse(appVersion.toString()); //.substring(2,appVersion.length));
          printFunc("version converted");

          printFunc(latest);
          printFunc(appVer);
          if (latest.major > appVer.major) {
            printFunc("Latest version has a major update");
            await DeleteSurveyourTablesContent();
            await DeleteFarmerTablesContent();
            await DeleteMasterTables();
            await ClearUserData();
            await deleteOldDatabase();
            await deleteExistingDatabase();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                // builder: (context) => LoginPageFarmer(),
                builder: (context) => WelcomePage(),
              ),
                  (route) => true,
            );

            Future.delayed(Duration(milliseconds: 500), () {
              // showAboutDialog(context: context);
              showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                  LanguageTextSelection.applicationUpdate[selectedLanguage], () {
                    // Navigator.of(context).pop();
                    printFunc(ModalRoute
                        .of(context)!
                        .settings
                        .name);
                    launchUrl(
                        Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                  }, willPopScope: () async {
                    printFunc("app exited ");
                    // Navigator.of(context, rootNavigator: true).pop();
                    // exit(0);
// return true;
                    return false;
                  });
            });

            return false;
          }
          else if (latest.minor > appVer.minor) {
            printFunc("Latest version has a minor update");
            await clearSurveyourOflineContent();
            await clearFarmerOflineContent();
            await ClearUserData();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                // builder: (context) => LoginPageFarmer(),
                builder: (context) => WelcomePage(),
              ),
                  (route) => true,
            );

            Future.delayed(Duration(milliseconds: 500), () {
              // showAboutDialog(context: context);
              showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                  LanguageTextSelection.applicationUpdate[selectedLanguage], () {
                    // Navigator.of(context).pop();
                    printFunc(ModalRoute
                        .of(context)!
                        .settings
                        .name);
                    launchUrl(
                        Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                  }, willPopScope: () async {
                    printFunc("app exited ");
                    // Navigator.of(context, rootNavigator: true).pop();
                    // exit(0);
// return true;
                    return false;
                  });
            });

            return false;
          }
          else if (latest.patch > appVer.patch) {
            printFunc("Latest version has a patch update");

            await ClearUserData();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                // builder: (context) => LoginPageFarmer(),
                builder: (context) => WelcomePage(),
              ),
                  (route) => true,
            );

            Future.delayed(Duration(milliseconds: 500), () {
              // showAboutDialog(context: context);
              showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                  LanguageTextSelection.applicationUpdate[selectedLanguage], () {
                    launchUrl(
                        Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                    // Navigator.of(context,rootNavigator: true).pop();
                  }, willPopScope: () async {
                    printFunc("app exited ");
                    // Navigator.of(context, rootNavigator: true).pop();
                    // exit(0);
                    // return true;
                    return false;
                  });
            });

            return false;
          }
          else {
            printFunc("Latest version is the same as or older than the current version");
            // return true;
            printFunc("date tiem check");
            printFunc(DateTime.now());

            if (isSeasonDateRequired) {
              if (userData["type"] == "farmer") {
                if (!isFarmerAllowed()) {
                  await clearFarmerOflineContent();
                  await ClearUserData();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      // builder: (context) => LoginPageFarmer(),firebase
                      builder: (context) => WelcomePage(),
                    ),
                        (route) => true,
                  );

                  Future.delayed(Duration(milliseconds: 500), () {
                    // showAboutDialog(context: context);
                    showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                        LanguageTextSelection.farmerEndDate[selectedLanguage], () {
                          exit(0);
                          Navigator.of(context).pop();
                          printFunc(ModalRoute
                              .of(context)!
                              .settings
                              .name);

                          // launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                        }, willPopScope: () async {
                          printFunc("app exited ");
                          // Navigator.of(context, rootNavigator: true).pop();
                          // exit(0);
// return true;
                          return false;
                        });
                  });
                  return false;
                }
              } else if (userData["type"] == "Surveyor") {
                if (!isDepartmentAllowed()) {
                  await clearSurveyourOflineContent();
                  await ClearUserData();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      // builder: (context) => LoginPageFarmer(),
                      builder: (context) => WelcomePage(),
                    ),
                        (route) => true,
                  );

                  Future.delayed(Duration(milliseconds: 500), () {
                    // showAboutDialog(context: context);
                    showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                        LanguageTextSelection.surveyorEndDate[selectedLanguage], () {
                          exit(0);
                          Navigator.of(context, rootNavigator: true).pop();
                          printFunc(ModalRoute
                              .of(context)!
                              .settings
                              .name);

                          // launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                        }, willPopScope: () async {
                          printFunc("app exited ");
                          // Navigator.of(context, rootNavigator: true).pop();
                          // exit(0);
// return true;
                          return false;
                        });
                  });

                  return false;
                }
              }
            }
            return true;
          }
        }
      } else {
        if (isSeasonDateRequired) {
          if (userData["type"] == "farmer") {
            if (!isFarmerAllowed()) {
              await clearFarmerOflineContent();
              await ClearUserData();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  // builder: (context) => LoginPageFarmer(),
                  builder: (context) => WelcomePage(),
                ),
                    (route) => true,
              );

              Future.delayed(Duration(milliseconds: 500), () {
                // showAboutDialog(context: context);
                showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                    LanguageTextSelection.farmerEndDate[selectedLanguage], () {
                      exit(0);
                      Navigator.of(context).pop();
                      printFunc(ModalRoute
                          .of(context)!
                          .settings
                          .name);

                      // launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                    }, willPopScope: () async {
                      printFunc("app exited ");
                      // Navigator.of(context, rootNavigator: true).pop();
                      // exit(0);
// return true;
                      return false;
                    });
              });
              return false;
            }
          } else if (userData["type"] == "Surveyor") {
            if (!isDepartmentAllowed()) {
              await clearSurveyourOflineContent();
              await ClearUserData();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  // builder: (context) => LoginPageFarmer(),
                  builder: (context) => WelcomePage(),
                ),
                    (route) => true,
              );

              Future.delayed(Duration(milliseconds: 500), () {
                // showAboutDialog(context: context);
                showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                    LanguageTextSelection.surveyorEndDate[selectedLanguage], () {
                      exit(0);
                      Navigator.of(context, rootNavigator: true).pop();
                      printFunc(ModalRoute
                          .of(context)!
                          .settings
                          .name);

                      // launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                    }, willPopScope: () async {
                      printFunc("app exited ");
                      // Navigator.of(context, rootNavigator: true).pop();
                      // exit(0);
// return true;
                      return false;
                    });
              });

              return false;
            }
          }
        }
        return true;
      }
    }
    else {
      await checkDeviceSettings(context);

      if (isSeasonDateRequired) {
        if (userData["type"] == "farmer") {
          if (!isFarmerAllowed()) {
            await clearFarmerOflineContent();
            await ClearUserData();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                // builder: (context) => LoginPageFarmer(),
                builder: (context) => WelcomePage(),
              ),
                  (route) => true,
            );

            Future.delayed(Duration(milliseconds: 500), () {
              // showAboutDialog(context: context);
              showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                  LanguageTextSelection.farmerEndDate[selectedLanguage], () {
                    exit(0);
                    Navigator.of(context).pop();
                    printFunc(ModalRoute
                        .of(context)!
                        .settings
                        .name);

                    // launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                  }, willPopScope: () async {
                    printFunc("app exited ");
                    // Navigator.of(context, rootNavigator: true).pop();
                    // exit(0);
// return true;
                    return false;
                  });
            });
            return false;
          }
        } else if (userData["type"] == "Surveyor") {
          if (!isDepartmentAllowed()) {
            await clearSurveyourOflineContent();
            await ClearUserData();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                // builder: (context) => LoginPageFarmer(),
                builder: (context) => WelcomePage(),
              ),
                  (route) => true,
            );

            Future.delayed(Duration(milliseconds: 500), () {
              // showAboutDialog(context: context);
              showAlertNavigtor(context, LanguageTextSelection.note[selectedLanguage],
                  LanguageTextSelection.surveyorEndDate[selectedLanguage], () {
                    exit(0);
                    Navigator.of(context, rootNavigator: true).pop();
                    printFunc(ModalRoute
                        .of(context)!
                        .settings
                        .name);

                    // launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=io.sc.eppCordova&hl=en'));
                  }, willPopScope: () async {
                    printFunc("app exited ");
                    // Navigator.of(context, rootNavigator: true).pop();
                    // exit(0);
// return true;
                    return false;
                  });
            });

            return false;
          }
        }
      }
      printFunc("internet is not there");
      return true;
    }
  } catch (e) {
    printFunc("Exception ${e.toString()}");
    if (isLoading) Navigator.of(context, rootNavigator: true).pop();
    isLoading = false;
    return true;
  }
  return true;
}*/
