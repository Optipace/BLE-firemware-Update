import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/batchModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';


// --------------------- This is not Used ------------------------------
Future<void> saveBatchListToHive(List<Map<String, dynamic>> batchList) async {
  final batchBox = await Hive.openBox<BatchModel>('$batchHiveBox');

  for (var series in batchList) {
    var firmware = series["firmware"];
    var profile = series["profile"];

    printFunc("DEMODEMODEMO path : ${ firmware['file']}");
    // Convert base64 into Zip


    FirmwareModel firmwareModel = FirmwareModel(
        id: firmware['id'],
        version: firmware['version'],
        releaseNote: firmware['releaseNote'],
        versionName: firmware['versionName'],
        deviceTypeId: firmware['deviceTypeId'],
        file: firmware['file'],
        saved: true,
        deviceType: firmware['deviceType']);
    ProfileModel profileModel = ProfileModel(
      id: profile['id'] ?? 0,
      name: profile['name'] ?? '',
      releaseNote: profile['releaseNote'] ?? '',
      uT: profile['uT'] ?? '',
      uV: profile['uV'] ?? '',
      lT: profile['lT'] ?? '',
      lV: profile['lV'] ?? '',
      saved: true,
      deviceTypeId: profile['deviceTypeId'] ?? '',
      deviceType: profile['deviceType'] ?? '',
    );
    var batchModel = BatchModel(
      batchId: series['id'],
      batchName: series['name'],
      batchDescription: series['description'],
      firmware: firmwareModel,
      profile: profileModel,
      saved: true,
    );

    await batchBox.put(series['id'], batchModel);
  }
}
// -------------------------not used -----------------------------------

Future<bool> addBatch(BatchModel newBatch) async {
// to add one by one
  printFunc("Batch model : \n${newBatch.toJson()}");
  final batchBox = await Hive.openBox<BatchModel>('$batchHiveBox');


  // Convertion of base 64 to zip
  String zipPath = await ConvertionBase64ToZip(newBatch.firmware.file, newBatch.batchName);
  printFunc("DEMO ZIP_PATH : $zipPath");

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
  );

  // Save to box
  await batchBox.put(newBatch.batchId, batch);
  print("Series ${newBatch.batchId} created and batch ${newBatch.batchName} added. ${newBatch.firmware.file}");

  return true;
}

Future<String> ConvertionBase64ToZip(String base64String, String fileName) async {
  try{
    Uint8List bytes = base64Decode(base64String);

    Directory appDocDir = await getApplicationDocumentsDirectory();

    String filePath = '${appDocDir.path}/$fileName.zip';

    File file = File(filePath);

    await file.writeAsBytes(bytes);

    return filePath;
  }catch(e){
    return 'e';
  }
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
// Future<List<Map<String, dynamic>>> getAllBatch() async
// {
//
// }
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
