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
      setSharedPreference(await getEmployeeDetail(context, phoneNum)??{});
      sharedPreferences.setBool("user_logged_in", true);

      setDeviceId();
      setUserData();
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


      Map<String, dynamic> userinfo =//from responce
      {
        'userId': 'U12345',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+91$contactNumber',
        'designationCode': '1',
        'empRegisteredId': 'EMP56789',
        'designation': 'Software Engineer',
        'accessToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        'refreshToken': 'd2ViLXRva2VuLXJlZnJlc2g=',
        'status': 'active',
      };
      if(contactNumber=="1111111111"||contactNumber=="2222222222")
      return userinfo;
      else {

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