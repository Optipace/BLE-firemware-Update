import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<Map<String, Map<String, Object>>> getDesignation(BuildContext context) async {
  var designationList = {
    "Admin": {
      "id": 1,
      "name": "admin",
      "priority": 1,
    },
    "Factory User": {
      "id": 2,
      "name": "Factory User",
      "priority": 2,
    },
    "Field User": {"id": 3, "name": "Field User", "priority": 3},
  };

  return designationList;

  await ApiService.callApi(
      context: context,
      method: 'GET',
      endpoint: ApiEndpoints.yetToDevelop,
      headerAuth: true,
      errorDisplay: false,
      onSuccess: (data) async {
        printFunc("Designation responce :$data");
        designationList.clear();
        for (Map desig in data) {
          designationList[desig["name"]] = data;
        }
      });

  return designationList;
}
