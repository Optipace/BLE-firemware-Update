import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<Map<String, dynamic>> getDesignation(BuildContext context) async {
  Map<String, dynamic> designationList = {
    "Admin": {
      "id": 1,
      "name": "admin",
      "priority": 1,
    },
    "Factory User": {
      "id": 2,
      "name": " Field User",
      "priority": 2,
    },
    "Field User": {"id": 3, "name": "Factory User", "priority": 3},
  };

  // return designationList;
  designationList.clear();
  await ApiService.callApi(
      context: context,
      method: 'GET',
      endpoint: ApiEndpoints.getAllDesignations,
      headerAuth: true,
      errorDisplay: false,
      onSuccess: (data) async {
        printFunc("Designation responce :$data");
        designationList.clear();

        for (var desig in data) {
          printFunc(" Designation -> $desig -> ${desig["name"]}");
          designationList[desig["name"]] = desig;
        }
      });
  printFunc("designationList : $designationList");
  return designationList;
}

Future<bool> addNewDesgination(BuildContext context, {required String name, required int priority}) async {
  final body = {"name": name, "priority": priority};
  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.saveDesignation,
      bodyOrParams: body,
      onSuccess: (data) {
        ShowSnackBarMessage(context, 'Designation added successfully!', true);
        isSuccess = true;
      });
  return isSuccess;
}
