import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/batchModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

// --------------------- This is not Used ------------------------------
// Future<void> saveBatchListToHive(List<Map<String, dynamic>> batchList) async {
//   final batchBox = await Hive.openBox<BatchModel>('$batchHiveBox');
//
//   for (var series in batchList) {
//     var firmware = series["firmware"];
//     var profile = series["profile"];
//
//     printFunc("DEMODEMODEMO path : ${firmware['file']}");
//     // Convert base64 into Zip
//
//     FirmwareModel firmwareModel = FirmwareModel(
//         id: firmware['id'],
//         version: firmware['version'],
//         releaseNote: firmware['releaseNote'],
//         versionName: firmware['versionName'],
//         deviceTypeId: firmware['deviceTypeId'],
//         file: firmware['file'],
//         saved: true,
//         deviceType: firmware['deviceType']);
//     ProfileModel profileModel = ProfileModel(
//       id: profile['id'] ?? 0,
//       name: profile['name'] ?? '',
//       releaseNote: profile['releaseNote'] ?? '',
//       uT: profile['uT'] ?? '',
//       uV: profile['uV'] ?? '',
//       lT: profile['lT'] ?? '',
//       lV: profile['lV'] ?? '',
//       saved: true,
//       deviceTypeId: profile['deviceTypeId'] ?? '',
//       deviceType: profile['deviceType'] ?? '',
//     );
//
//     BatteryModel Battery = BatteryModel(
//         id: '',
//         batteryName: '',
//         batteryCode: ''
//     );
//     // var batchModel = BatchModel(
//     //   batchId: series['id'],
//     //   batchName: series['name'],
//     //   batchDescription: series['description'],
//     //   firmware: firmwareModel,
//     //   profile: profileModel,
//     //   battery: Battery,
//     //   saved: true,
//     // );
//
//     // await batchBox.put(series['id'], batchModel);
//   }
// }
// -------------------------not used -----------------------------------

Future<bool> addBatch(BatchModel newBatch) async {
// to add one by one
  printFunc("Batch model : \n${newBatch.toJson()}");
  final batchBox = await Hive.openBox<BatchModel>('$batchHiveBox');

  // Convertion of base 64 to zip
  String zipPath =
      await saveBase64ZipToFile(newBatch.firmware.file, newBatch.batchName);
  printFunc("DEMO ZIP_PATH : $zipPath");
  if (zipPath == "" || zipPath == null) {
    return false;
  }
  newBatch.firmware.file = zipPath;

  newBatch.saved = true;
  // batch doesn't exist, create it
  BatchModel batch = BatchModel(
    batchId: newBatch.batchId,
    batchName: newBatch.batchName,
    batchDescription: newBatch.batchDescription,
    saved: true,
    firmware: newBatch.firmware,
    profile: newBatch.profile,
    battery: newBatch.battery,
  );

  // Save to box
  await batchBox.put(newBatch.batchId, batch);
  printFunc(
      "Series ${newBatch.batchId} created and batch ${newBatch.batchName} added. ${newBatch.firmware.file}");

  printFunc("DEM3."
      ".O  newBatch  _________________  \n"
      "batchId : ${newBatch.batchId}  \n"
      "batchName : ${newBatch.batchName}  \n"
      "batchDescription : ${newBatch.batchDescription}  \n"
      "firmware : ${newBatch.firmware}  \n"
      "profile : ${newBatch.profile}  \n"
      "battery : ${newBatch.battery}  \n");

  return true;
}

Future<String> saveBase64ZipToFile(String base64String, String fileName) async {
  try {
    // Decode Base64 to bytes
    printFunc("base 64 data : -> $base64String");

    Uint8List zipBytes = base64Decode(base64String);
    // Get the app's document directory
    Directory dir = await getApplicationDocumentsDirectory();

    // Construct the full path
    String filePath = '${dir.path}/$fileName.zip';

    // Write bytes to file
    File zipFile = File(filePath);
    await zipFile.writeAsBytes(zipBytes);

    printFunc('ZIP saved to: $filePath');
    return filePath;
  } catch (e) {
    printFunc('Error saving ZIP: $e');
    return "";
  }
}

/////////////////// Not in used ///////////////////////
Future<List<Map<String, dynamic>>> getAllBatchFromHive() async {
  final box = await Hive.openBox<BatchModel>('$batchHiveBox');

  return box.values.map((series) {
    return {
      "id": series.batchId,
      "name": series.batchName,
      "description": series.batchDescription,
      "saved": series.saved,
      "firmware": series.firmware.toJson(),
      "profile": series.profile.toJson(),
    };
  }).toList();
}

// to add one by one
/*
final newBatch = BatchModel(
  id: 321238,
  version: "321.0.35",
  releaseNote: "29/05/2025",
  versionName: "b6 2.0.3",
  deviceTypeid: "3",
  file: "Base64Data",
);
 */
