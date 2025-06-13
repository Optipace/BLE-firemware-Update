import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<bool> addNewUser(
  BuildContext context, {
  required String name,
  required String empRegisteredId,
  required String email,
  required String contact,
  required String password,
  required String designationId,
  required String deviveId,
}) async {
  final requestBody = {
    "name": name,
    "empRegisteredId": empRegisteredId,
    "email": email,
    "contact": contact,
    "password": password,
    // "createdBy": UserData.instance.userId,
    // "modifiedBy": UserData.instance.userId,
    "designationId": int.parse(designationId),
    "deviceId": deviveId,
  };

  bool isSuccess = false;

  await ApiService.callApi(
    context: context,
    method: 'POST',
    endpoint: ApiEndpoints.saveEmployee,
    bodyOrParams: requestBody,
    onSuccess: (data) {
      ShowSnackBarMessage(context, 'User added successfully!', true);
      isSuccess = true;
    },
  );

  return isSuccess;
}

Future<bool> updateUser(
  BuildContext context, {
  required String id,
  required String name,
  required String empRegisteredId,
  required String email,
  required String contact,
  required String password,
  required String designationId,
  required String deviveId,
}) async {
  final requestBody = {
    "id": id,
    "name": name,
    "empRegisteredId": empRegisteredId,
    "email": email,
    "contact": contact,
    "password": password,
    // "createdBy": UserData.instance.userId,
    // "modifiedBy": UserData.instance.userId,
    // "password":"abc@123",
    "designationId": designationId,
    "deviceId": deviveId,
  };

  bool isSuccess = false;

  await ApiService.callApi(
    context: context,
    method: 'PUT',
    endpoint: ApiEndpoints.updateEmployee,
    bodyOrParams: requestBody,
    onSuccess: (data) {
      ShowSnackBarMessage(context, 'User updated successfully!', true);
      isSuccess = true;
    },
  );

  return isSuccess;
}

Future<bool> setUserActive(
  BuildContext context, {
  required String id,
}) async {
  final requestBody = {"empId": id, "active": "N"};

  bool isSuccess = false;

  await ApiService.callApi(
    context: context,
    method: 'PUT',
    endpoint: ApiEndpoints.updateActive,
    bodyOrParams: requestBody,
    onSuccess: (data) {
      ShowSnackBarMessage(context, 'User activated successfully!', true);
      isSuccess = true;
    },
  );

  return isSuccess;
}

Future<bool> deActivateUser(
  BuildContext context, {
  required String id,
}) async {
  final requestBody = {"empId": id, "active": "Y"};

  bool isSuccess = false;

  await ApiService.callApi(
    context: context,
    method: 'PUT',
    endpoint: ApiEndpoints.updateDeactive,
    bodyOrParams: requestBody,
    onSuccess: (data) {
      ShowSnackBarMessage(context, 'User deactivated successfully!', true);
      isSuccess = true;
    },
  );

  return isSuccess;
}
