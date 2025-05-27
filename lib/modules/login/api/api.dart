import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entiry/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/admin/admin_main.dart';
import 'package:tracker_firmware/modules/factoryUser/factory_user_main.dart';
import 'package:tracker_firmware/modules/fieldOfficer/field_user_main.dart';

Future<bool> logIn(BuildContext context, String phoneNum, String password) async{
  var data = {
    "contact" : phoneNum,
    "password":password,
    "deviceId": sharedPreferences.getString("UUID"),
  };
  // String endPoint = "";
  var request = json.encode(data);
  print("DEMO REQUEST LOGIN API BODY : $request");

  // var response = "";

  if(/* response.statusCode == 200 */ true){
    // var jsonResponse = (json.decode(utf8.decode(response.bodyBytes)));
    if(/*jsonResponse["response"]["code"].toString]] == 1 */ true){
      /*for(var empdata in jsonResponse["data"]){
        if(empdata["designation_id"]== 1)){
         //   admin page
        }else if (empdata["designation_id"] == 2){
        // factory User page
        }else if(empdata["designation_id"] == 3){
        // field user page
        }
      }*/
     await setSharedPreference(await getEmployeeDetail(context, phoneNum)??{});
      sharedPreferences.setBool("user_logged_in", true);

      await setDeviceId();
      await setUserData();
      UserData userData=new UserData();

      navigateToDashBoard(context, int.tryParse(userData.designationCode)??1);
      return true;
    }
    //  --else cond --
    /*else{
      print("Login Failed");
    }*/


  }
  //--else cond --
  /*else if(response.statusCode == 198){
    showAlertDialog(context, "Alert", "Please make sure you have good internet");
  }else{
    showAlertDialog(context, "Alert", "Service not Available");
  }*/



  return false;
}


Future< Map<String, dynamic>?> getEmployeeDetail(BuildContext context, String contactNumber) async{
  sharedPreferences = await SharedPreferences.getInstance();

  var data = {
    "contact" : contactNumber,
  };
  // String endPoint = "";
  var request = json.encode(data);
  print("DEMO REQUEST LOGIN API BODY : $request");

  // var response = "";

  if(/* response.statusCode == 200 */ true){
    // var jsonResponse = (json.decode(utf8.decode(response.bodyBytes)));
    if(/*jsonResponse["response"]["code"].toString]] == 1 */ true){
      /*for(var empdata in jsonResponse["data"]){
        if(empdata["designation_id"]== 1)){
         //   admin page
        }else if (empdata["designation_id"] == 2){
        // factory User page
        }else if(empdata["designation_id"] == 3){
        // field user page
        }
      }*/

      String getDesgination(contactNumber){
        int result = ((int.parse(contactNumber)/1111111111).round());
        if(result == 1){return("Admin");}else if(result == 2){return ("Factory User");}else{return("Field User");};
      }
      Map<String, dynamic> userinfo =//from responce
      {
        'userId': 'U12345',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+91$contactNumber',
        'designationCode': "${((int.parse(contactNumber)/1111111111).round())}",
        'empRegisteredId': 'EMP56789',
        'designation': getDesgination(contactNumber),
        'accessToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        'refreshToken': 'd2ViLXRva2VuLXJlZnJlc2g=',
        'status': 'Active',
      };


      if(contactNumber=="1111111111"||contactNumber=="2222222222"||contactNumber=="3333333333")
      return userinfo;
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:Row(
              children: [
                Image.asset('assets/image/search.png',width: 24,height: 24,color: Color(0xFFFF6B6B),),
                SizedBox(width: 15,),
                Text('User Not Founded',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w300,
                    fontFamily: baseFont,
                    fontSize: 22,

                  ),),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: primaryButton,
            elevation: 5,
            margin: EdgeInsets.only(bottom: 50,left: 20,right: 20,),
            duration: Duration(seconds: 3),


          ),
        );
        return null;
      }
    }
    //  --else cond --
    /*else{
      print("Login Failed");
    }*/


  }
  //--else cond --
  /*else if(response.statusCode == 198){
    showAlertDialog(context, "Alert", "Please make sure you have good internet");
  }else{
    showAlertDialog(context, "Alert", "Service not Available");
  }*/



  return {};
}



List<Map<String, dynamic>> getFactoryLogs() {


  List<Map<String, dynamic>> empLogs = [
    {
      "empId": "EMP121",
      "Name": "John Dae",
      "DeviceID": "545",
      "status": "Success",
      "phone": "+91 9900711798",
      "firm_version": "2.3.0",
      "Battery-Service": "B6",
      "Battery-profile": "P1,B6",
      "Date-Time": "2025-05-26 10:30:00"
    },
    {
      "empId": "EMP122",
      "Name": "Alice mark",
      "DeviceID": "546",
      "status": "Failure",
      "phone": "+91 9876543210",
      "firm_version": "2.3.0",
      "Battery-Service": "B9",
      "Battery-profile": "P2,B9",
      "Date-Time": "2025-05-26 11:15:00"
    }
  ];
  return empLogs;
}


List<Map<String, dynamic>> getFeildLogs() {

  List<Map<String, dynamic>> FeildLogs = [
    {
      "empId": "EMP123",
      "Name": "David Stone",
      "DeviceID": "547",
      "status": "Failure",
      "phone": "+91 9812345678",
      "firm_version": "2.3.1",
      "Battery-Service": "B12",
      "Battery-profile": "P3,B12",
      "Date-Time": "2025-05-26 12:00:00"
    },
    {
      "empId": "EMP124",
      "Name": "Emma Clark",
      "DeviceID": "548",
      "status": "Success",
      "phone": "+91 9765432109",
      "firm_version": "2.2.9",
      "Battery-Service": "B6",
      "Battery-profile": "P4,B6",
      "Date-Time": "2025-05-26 12:45:00"
    }
  ];
  return FeildLogs;
}



void navigateToDashBoard(BuildContext context,int  designation_id){
  if(designation_id == 1){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (_) => AdminMain()));
  }else if(designation_id == 2){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (_) => FactoryMain()));
    return;
  }else if( designation_id == 3){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (_) => FieldMain()));
    return ;
  }
}