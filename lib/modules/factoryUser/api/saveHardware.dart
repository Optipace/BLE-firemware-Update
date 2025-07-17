import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<bool> saveHardware(BuildContext context,{required String macId,required String BatchId, required String productId,}) async{
  final body = {
    "macID": macId,
    "discription": "Description",
    "detailDiscription": "Detailed Description",
    "batchId":BatchId,
    "productId": productId
  };
  bool isSuccess = false;

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.saveHardware,
      bodyOrParams: body,
      onSuccess: (data){
        ShowSnackBarMessage(context, 'Hardware added successfully!', true);
        Navigator.of(context).pop();
        isSuccess = true;
      }
  );
  return isSuccess;
}