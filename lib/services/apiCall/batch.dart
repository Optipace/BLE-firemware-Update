import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<List<Map<String, dynamic>>> getBatchList(
  BuildContext context, {
  required String Status,
}) async {
  List<Map<String, dynamic>> batchList = [];
  final requestBody = {
    "active": Status,
  };
  await ApiService.callApi(
      context: context,
      method: 'POST',
      bodyOrParams: requestBody,
      endpoint: ApiEndpoints.getAllBatchDetails,
      headerAuth: true,
      onSuccess: (data) async {
        printFunc("Batch data : $data");

        for (var item in data) {
          final firmware = item['firmware'] ?? {};
          final config = item['configuration'] ?? {};
          final device = item['configuration']['device'] ?? {};
          config['nominalVoltage'] = 6.2;
          config['upperTemp'] = 26;
          config['lowerTemp'] = 17;

          Map<String, dynamic> formatted = {
            "id": item['id'].toString(),
            "name": item['batchName'] ?? '',
            "description": item['discription'] ?? '',
            "active": item['active'] ?? '',
            "saved": false,
            "profile": {
              "id": config['id'],
              "name": config['name'] ?? '',
              "releaseNote": '', // fill if needed
              "uT": config['upperThreshold']?.toString() ?? '',
              "uV": config['upperVoltage']?.toString() ?? '',
              "lT": config['lowerThreshold']?.toString() ?? '',
              "lV": config['lowerVoltage']?.toString() ?? '',
              "nV": config['nominalVoltage']?.toString() ?? '',
              "uTemp": config['upperTemp']?.toString() ?? '',
              "lTemp": config['lowerTemp']?.toString() ?? '',
              "deviceTypeId": config['deviceId']?.toString() ?? '',
              "file": "Base64Data",
              "saved": false,
              "deviceType": config['deviceId']?.toString() ?? '',
            },
            "firmware": {
              "id": firmware['id'],
              "version": firmware['versionName'] ?? '',
              "releaseDate": firmware['versionReleasedDate'] ?? '',
              "versionName": firmware['versionName'] ?? '',
              "deviceTypeId": firmware['deviceTypeId']?.toString() ?? config['deviceId']?.toString() ?? '',
              "file": firmware['file'],
              "saved": false,
              "deviceType": firmware['deviceTypeId']?.toString() ?? '',
            },
            "batteryDetails":{
              "id":   device['id']?.toString() ?? '',
              "name": device['deviceName']?.toString() ?? '',
              "Battery-Code": device['discription']?.toString() ?? '',
            }
          };

          batchList.add(formatted);
          // printFunc("Formatted data : $formatted");
        }

        print("Formatted data list : $batchList");
      });

  // batchList = [
  //   {
  //     "id": "123",
  //     "name": "B1C1F1",
  //     "description": "abc",
  //     "saved": false,
  //     "profile": {
  //       "id": 1234,
  //       "name": "B6P1", // changed from version to name
  //       "releaseNote": "31/05/2025",
  //       "uT": "4.20", // upper threshold voltage
  //       "uV": "4.15",
  //       "lT": "3.00",
  //       "lV": "3.10",
  //       "deviceTypeId": "1",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     },
  //     "firmware": {
  //       "id": 1234,
  //       "version": "2.0.3",
  //       "releaseNote": "29/05/2025",
  //       "versionName": "b6 2.0.3",
  //       "deviceTypeId": "1",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     },
  //   },
  //   {
  //     "id": "124",
  //     "name": "B2C2F2",
  //     "description": "abcaa",
  //     "profile": {
  //       "id": 1235,
  //       "name": "B6P2",
  //       "releaseNote": "30/05/2025",
  //       "uT": "4.25",
  //       "uV": "4.18",
  //       "lT": "3.05",
  //       "lV": "3.12",
  //       "deviceTypeId": "1",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     },
  //     "firmware": {
  //       "id": 1235,
  //       "version": "2.0.2",
  //       "releaseNote": "28/04/2025",
  //       "versionName": "b6 2.0.2",
  //       "deviceTypeId": "1",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     },
  //   },
  //   {
  //     "id": "126",
  //     "name": "B2C2F3",
  //     "description": "abcwer",
  //     "firmware": {
  //       "id": 21234,
  //       "version": "1.0.3",
  //       "releaseNote": "01/03/2025",
  //       "versionName": "b6 2.0.3",
  //       "deviceTypeId": "2",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     },
  //     "profile": {
  //       "id": 1236,
  //       "name": "B6P3",
  //       "releaseNote": "26/05/2025",
  //       "uT": "4.30",
  //       "uV": "4.20",
  //       "lT": "3.10",
  //       "lV": "3.15",
  //       "deviceTypeId": "1",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     }
  //   },
  //   {
  //     "id": "127",
  //     "name": "B2C2F4",
  //     "description": "abcwer",
  //     "firmware": {
  //       "id": 21234,
  //       "version": "1.0.3",
  //       "releaseNote": "01/03/2025",
  //       "versionName": "b6 2.0.3",
  //       "deviceTypeId": "2",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     },
  //     "profile": {
  //       "id": 1236,
  //       "name": "B6P3",
  //       "releaseNote": "26/05/2025",
  //       "uT": "4.30",
  //       "uV": "4.20",
  //       "lT": "3.10",
  //       "lV": "3.15",
  //       "deviceTypeId": "1",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     }
  //   },
  //   {
  //     "id": "128",
  //     "name": "B2C2F5",
  //     "description": "abcwer",
  //     "firmware": {
  //       "id": 21234,
  //       "version": "1.0.3",
  //       "releaseNote": "01/03/2025",
  //       "versionName": "b6 2.0.3",
  //       "deviceTypeId": "2",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     },
  //     "profile": {
  //       "id": 1236,
  //       "name": "B6P3",
  //       "releaseNote": "26/05/2025",
  //       "uT": "4.30",
  //       "uV": "4.20",
  //       "lT": "3.10",
  //       "lV": "3.15",
  //       "deviceTypeId": "1",
  //       "file": "Base64Data",
  //       "saved": false,
  //       "deviceType": "B6"
  //     }
  //   },
  // ];
  printFunc("Farmated data  list : $batchList");

  return batchList;
}

////////////////////// NOT IN USED /////////////////////////////////////
Future<List<Map<String, dynamic>>> getBatchByID(BuildContext context, String id) async {
  List<Map<String, dynamic>> batchList = [{}];
  List<Map<String, dynamic>> batchByID = [{}];

  batchList = await getBatchList(context, Status: "A");

  for (var index in batchList) {
    if (index["id"].toString() == id) {
      batchByID = index["batch"];
    }
  }

  return batchByID;
}
////////////////////// NOT IN USED /////////////////////////////////////



Future<bool> addNewBatch(
  BuildContext context, {
  required String config,
  required String firmware,
  required String batchName,
  required String description,
}) async {
  final body = {
    "firmwareId": firmware,
    "profileId": config,
    "discription": description,
    "batchName": batchName
  };

  bool isSuccess = false;

  await ApiService.callApi(
    context: context,
    method: 'POST',
    endpoint: ApiEndpoints.saveBatch,
    bodyOrParams: body,
    onSuccess: (data) {
      ShowSnackBarMessage(context, 'Batch Created successfully!', true);
      isSuccess = true;
    },
  );

  return isSuccess;
}
