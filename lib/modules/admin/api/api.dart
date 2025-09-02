import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/admin_logs.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<bool> getAllLogs(BuildContext context) async {
  printFunc("INSIDE LOGS API");
  // var response = "";

  if (/* response.statusCode == 200 */ true) {
    // var jsonResponse = (json.decode(utf8.decode(response.bodyBytes)));
    if (/*jsonResponse["response"]["code"].toString]] == 1 */ true) {
      /*for(var empdata in jsonResponse["data"]){
        if(empdata["designation_id"]== 1)){
         //   admin page
        }else if (empdata["designation_id"] == 2){
        // factory User page
        }else if(empdata["designation_id"] == 3){
        // field user page
        }
      }*/
      var designation_id = 1;
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AdminLogs()));
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


Future<bool> saveClient(
    BuildContext context,{
      required String name,
      required String address,
      required String contactNumber,
      required String email,
      required String contactPerson,
      required String discription,
      required String code,
}) async{
  final body =
  {
    "name": name,
    "address": address,
    "contactNumber": contactNumber,
    "email": email,
    "contactPerson": contactPerson,
    "discription": discription,
    "code": code
  };

  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.saveClient,
      bodyOrParams: body,
      onSuccess: (data){
        ShowSnackBarMessage(context, 'Client Created successfully!', true);
        isSuccess = true;
      }
  );
  return isSuccess;
}


Future<bool> updatePassword(
    BuildContext context,{
      required String phno,
      required String pwd,
    }) async{
  final body =
  {
    "contact": phno,
    "password":pwd
  };

  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'PUT',
      endpoint: ApiEndpoints.updatePassword,
      bodyOrParams: body,
      onSuccess: (data){
        ShowSnackBarMessage(context, 'Password Changed!!', true);
        isSuccess = true;
      }
  );
  return isSuccess;
}