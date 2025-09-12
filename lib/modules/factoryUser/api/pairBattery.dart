import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<bool> saveMacandBattery(BuildContext context,
    {required String macId, required String BatterySerialNo}) async {
  final body = {"macId": macId, "batterySerialNumber": BatterySerialNo};
  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.saveMacandBattery,
      bodyOrParams: body,
      onSuccess: (data) {
        ShowSnackBarMessage(context, 'Battery Paired successfully!', true);
        // Navigator.of(context).pop();
        isSuccess = true;
      });
  return isSuccess;
}
