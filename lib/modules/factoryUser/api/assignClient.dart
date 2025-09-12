import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<bool> saveMacandClient(BuildContext context,
    {required String macId, required String clientId}) async {
  final body = {"macId": macId, "clientId": clientId};
  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.saveMacandClient,
      bodyOrParams: body,
      onSuccess: (data) {
        ShowSnackBarMessage(context, 'Client assigned successfully!', true);
        isSuccess = true;
      });
  return isSuccess;
}
