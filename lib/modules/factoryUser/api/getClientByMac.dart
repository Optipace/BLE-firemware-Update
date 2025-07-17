import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<List<dynamic>> GetClientByMac(BuildContext context, {required String macId}) async{
  Map<String, dynamic> ClientDetails ={};
  bool isSuccess = false;
  final requestBody = {"macId":macId};

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.clientbyMac,
      bodyOrParams: requestBody,
      onSuccess: (data) async{
        printFunc("Client Data : $data}");


        if (data != null && data['client'] != null ) {
          ClientDetails = {
            "macId": data['macId'],
            ...data['client'],
          };
        }
        isSuccess = true;
      },
    errorDisplay:  false
  );
  return [isSuccess, ClientDetails ];
}