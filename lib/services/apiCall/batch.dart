import 'package:flutter/cupertino.dart';

Future<List<Map<String, dynamic>>> getBatchList(BuildContext context) async {
  List<Map<String, dynamic>> batchList = [{}];

  batchList = [
    {
      "id": "123",
      "name": "B1C1F1",
      "description": "abc",
      "saved": false,
      "profile": {
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
      "firmware": {
        "id": 1234,
        "version": "2.0.3",
        "releaseNote": "29/05/2025",
        "versionName": "b6 2.0.3",
        "deviceTypeId": "1",
        "file": "Base64Data",
        "saved": false,
        "deviceType": "B6"
      },
    },
    {
      "id": "124",
      "name": "B2C2F2",
      "description": "abcaa",
      "profile": {
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
      "firmware": {
        "id": 1235,
        "version": "2.0.2",
        "releaseNote": "28/04/2025",
        "versionName": "b6 2.0.2",
        "deviceTypeId": "1",
        "file": "Base64Data",
        "saved": false,
        "deviceType": "B6"
      },
    },
    {
      "id": "126",
      "name": "B2C2F3",
      "description": "abcwer",
      "firmware": {
        "id": 21234,
        "version": "1.0.3",
        "releaseNote": "01/03/2025",
        "versionName": "b6 2.0.3",
        "deviceTypeId": "2",
        "file": "Base64Data",
        "saved": false,
        "deviceType": "B6"
      },
      "profile": {
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
    },
    {
      "id": "127",
      "name": "B2C2F4",
      "description": "abcwer",
      "firmware": {
        "id": 21234,
        "version": "1.0.3",
        "releaseNote": "01/03/2025",
        "versionName": "b6 2.0.3",
        "deviceTypeId": "2",
        "file": "Base64Data",
        "saved": false,
        "deviceType": "B6"
      },
      "profile": {
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
    },
    {
      "id": "128",
      "name": "B2C2F5",
      "description": "abcwer",
      "firmware": {
        "id": 21234,
        "version": "1.0.3",
        "releaseNote": "01/03/2025",
        "versionName": "b6 2.0.3",
        "deviceTypeId": "2",
        "file": "Base64Data",
        "saved": false,
        "deviceType": "B6"
      },
      "profile": {
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
    },

  ];

  return batchList;
}

Future<List<Map<String, dynamic>>> getBatchByID(BuildContext context, String id) async {
  List<Map<String, dynamic>> batchList = [{}];
  List<Map<String, dynamic>> batchByID = [{}];

  batchList = await getBatchList(context);

  for (var index in batchList) {
    if (index["id"].toString() == id) {
      batchByID = index["batch"];
    }
  }

  return batchByID;
}
