import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';

Future <Map<String,dynamic>> getHardwareDetails(BuildContext context,{required String macId}) async{
  final body = {"macId":macId};
  Map<String,dynamic> HardwareDetail = {};

  /*  HardwareDetail = {
    'MacId' : "06:1A:2B:3C:4D:5E",
    'ClientName' : "John",
    'ClientContactNum' : "9482956503",
    'BatSerialNum' : "12345678",
    'BatteryType' : "6s",
    'BatchName' : "BA-09",
    'FWName': "FW-09",
    'CName' : "DEMODEMO",
    'UThershold' : "4.0",
    'LThershold' : "3.7",
    'UVoltage' : "4.25",
    'LVoltage' : "2.916",
    'NVoltage' : "3.6",
    'UTemp' : "40",
    'LTemp' : "10"
  };*/


  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.getHardwareDetails,
      bodyOrParams: body,
      onSuccess: (data){
        var detail = data['hardwareResponce'];
        HardwareDetail.clear();
        HardwareDetail = {
          'MacId' : detail['macId'] ?? 'NA',
          'ClientName' : detail['clientResponce']['name'] ?? 'NA',
          'ClientContactNum' : detail['clientResponce']['contactNumber'] ?? 'NA',
          'BatSerialNum' : detail['batteryDetailResponce']['batterySerialNumber'] ?? 'NA',
          'BatteryType' : detail['batchResponce']['configuration']['device']['deviceName'] ?? 'NA',
          'BatchName' : detail['batchResponce']['batchName'] ?? 'NA',
          'FWName': detail['batchResponce']['firmware']['versionName'] ?? 'NA',
          'CName': detail['batchResponce']['configuration']['name'] ?? 'NA',
          'UThershold' : detail['batchResponce']['configuration']['upperThreshold'] ?? 'NA',
          'LThershold' : detail['batchResponce']['configuration']['lowerThreshold'] ?? 'NA',
          'UVoltage' : detail['batchResponce']['configuration']['upperVoltage'] ?? 'NA',
          'LVoltage' : detail['batchResponce']['configuration']['lowerVoltage'] ?? 'NA',
          'NVoltage' : detail['batchResponce']['configuration']['normalVoltage'] ?? 'NA',
          'UTemp' : detail['batchResponce']['configuration']['upperTemperature'] ?? 'NA',
          'LTemp' : detail['batchResponce']['configuration']['lowerTemperature'] ?? 'NA'
        };
      }
  );


  return HardwareDetail;
}