import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/admin/admin_main.dart';
import 'package:tracker_firmware/modules/admin/log/admin_logs.dart';
import 'package:tracker_firmware/modules/factoryUser/factory_user_main.dart';
import 'package:tracker_firmware/modules/fieldOfficer/field_user_main.dart';

Future<bool> getAllLogs(BuildContext context) async{
  print("INSIDE LOGS API");
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
      var designation_id = 1;Navigator.of(context).push(
          MaterialPageRoute<void>(
              builder: (_) => AdminLogs()));
      return true;    }
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