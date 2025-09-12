import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<List<dynamic>> getProductIdbyMac(BuildContext context,
    {required String mac_ID}) async {
  Map<String, dynamic> productIdDetails = {};
  bool isSuccess = false;

  final requestBody = {"macId": mac_ID};

  await ApiService.callApi(
    context: context,
    method: 'POST',
    endpoint: ApiEndpoints.productIDbyMac,
    errorDisplay: false,
    bodyOrParams: requestBody,
    onSuccess: (data) async {
      printFunc("Product DATA :$data");

      if (data != null && data['product'] != null) {
        productIdDetails = {
          "macId": data['macId'],
          ...data['product'],
        };
        isSuccess = true;
      }
    },
    showLoader: false,
  );
  return [isSuccess, productIdDetails];
}
