import 'package:flutter/cupertino.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

Future<List<Map<String, dynamic>>> getAllConfigurationList(BuildContext context,
    {required String active}) async {
  List<Map<String, dynamic>> configurationList = [{}];

  final requestBody = {
    "active": active,
  };

  await ApiService.callApi(
      context: context,
      method: 'POST',
      endpoint: ApiEndpoints.getAllProfileDetails,
      headerAuth: true,
      bodyOrParams: requestBody,
      onSuccess: (data) async {
        printFunc("Configuration data : $data");
        configurationList.clear();

        for (Map<String, dynamic> config in data) {
          configurationList.add(config);
        }

        printFunc("Configuration required : $configurationList");
      });
  return configurationList;
}

Future<bool> addNewConfig(
    BuildContext context, {
      required String configName,
      required String upperThreshold,
      required String upperVoltage,
      required String lowerThreshold,
      required String lowerVoltage,
      required String description,
      required String batterySeriesId,
      required String nominalVoltage,
      required String upperTemp,
      required String lowerTemp
    }) async {
  final body = {
    "name": configName,
    "upperVoltage": upperVoltage,
    "upperThreshold": upperThreshold,
    "lowerVoltage": lowerVoltage,
    "lowerThreshold": lowerThreshold,
    "discription": description,
    "deviceId": batterySeriesId
  };

  bool isSuccess = false;

  await ApiService.callApi(
    context: context,
    method: 'POST',
    endpoint: ApiEndpoints.saveProfile,
    bodyOrParams: body,
    onSuccess: (data) {
      ShowSnackBarMessage(context, 'Configuration uploaded successfully!', true);
      isSuccess = true;
    },
  );

  return isSuccess;
}


Future<List<Map<String, dynamic>>> getProfileList(BuildContext context) async {
  List<Map<String, dynamic>> profileList = [{}];

  profileList = [
    {
      "id": "1",
      "name": "B6",
      "profile": [
        {
          "id": 1234,
          "name": "B6P1", // changed from version to name
          "releaseNote": "31/05/2025",
          "uT": "4.20", // upper threshold voltage
          "uV": "4.15",
          "lT": "3.00",
          "lV": "3.10",
          "deviceTypeId": "1",
          "file": "Base64Data",
          "saved": false,
          "deviceType": "B6"
        },
        {
          "id": 1235,
          "name": "B6P2",
          "releaseNote": "30/05/2025",
          "uT": "4.25",
          "uV": "4.18",
          "lT": "3.05",
          "lV": "3.12",
          "deviceTypeId": "1",
          "file": "Base64Data",
          "saved": false,
          "deviceType": "B6"
        },
        {
          "id": 1236,
          "name": "B6P3",
          "releaseNote": "26/05/2025",
          "uT": "4.30",
          "uV": "4.20",
          "lT": "3.10",
          "lV": "3.15",
          "deviceTypeId": "1",
          "file": "Base64Data",
          "saved": false,
          "deviceType": "B6"
        }
      ]
    },
    {
      "id": "2",
      "name": "B9",
      "profile": [
        {
          "id": 21234,
          "name": "B9P1",
          "releaseNote": "29/05/2025",
          "uT": "4.30",
          "uV": "4.25",
          "lT": "3.10",
          "lV": "3.15",
          "deviceTypeId": "2",
          "file": "Base64Data",
          "saved": false,
          "deviceType": "B9"
        },
        {
          "id": 21235,
          "name": "B9P2",
          "releaseNote": "20/05/2025",
          "uT": "4.35",
          "uV": "4.28",
          "lT": "3.12",
          "lV": "3.18",
          "deviceTypeId": "2",
          "file": "Base64Data",
          "saved": false,
          "deviceType": "B9"
        }
      ]
    },
    {
      "id": "3",
      "name": "B12",
      "profile": [
        {
          "id": 321234,
          "name": "B12P1",
          "releaseNote": "28/05/2025",
          "uT": "4.40",
          "uV": "4.35",
          "lT": "3.20",
          "lV": "3.25",
          "deviceTypeId": "3",
          "file": "Base64Data",
          "saved": false,
          "deviceType": "B12"
        },
        {
          "id": 321235,
          "name": "B12P2",
          "releaseNote": "25/05/2025",
          "uT": "4.45",
          "uV": "4.38",
          "lT": "3.22",
          "lV": "3.28",
          "deviceTypeId": "3",
          "file": "Base64Data",
          "saved": false,
          "deviceType": "B12"
        }
      ]
    },
  ];

  return profileList;
}

/////////////////// NOT IN USED /////////////////////////////////
Future<List<Map<String, dynamic>>> getProfileByID(BuildContext context, String id) async {
  List<Map<String, dynamic>> profileList = [{}];
  List<Map<String, dynamic>> profileByID = [{}];

  profileList = await getProfileList(context);

  for (var index in profileList) {
    if (index["id"].toString() == id) {
      profileByID = index["profile"];
    }
  }

  return profileByID;
}



