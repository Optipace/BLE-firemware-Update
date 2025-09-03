import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareSeriesModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<void> saveFirmwareListToHive(List<Map<String, dynamic>> firmwareList) async {
  final firmwareBox = await Hive.openBox<FirmwareSeriesModel>('$firmwareHiveBox');

  for (var series in firmwareList) {
    List<FirmwareModel> firmwareModels = (series['firmware'] as List).map((f) {
      return FirmwareModel(
          id: f['id'],
          version: f['version'],
          releaseNote: f['releaseNote'],
          versionName: f['versionName'],
          deviceTypeId: f['deviceTypeId'],
          file: f['file'],
          saved: true,
          deviceType: f['deviceType']);
    }).toList();

    var seriesModel = FirmwareSeriesModel(
      id: series['id'],
      name: series['name'],
      firmware: firmwareModels,
    );

    await firmwareBox.put(series['id'], seriesModel);
  }
}

Future<FirmwareModel?> getFirmwareByVersion(String seriesId, String version) async {
  final firmwareBox = await Hive.openBox<FirmwareSeriesModel>('$firmwareHiveBox');
  final series = firmwareBox.get(seriesId);
  if (series != null) {
    return series.firmware.firstWhere(
      (fw) => fw.version == version,
      // orElse: () => null,
    );
  }
  return null;

  // how to use
  /*
  var firmware = await getFirmwareByVersion("3", "321.0.31");
  if (firmware != null) {
  printFunc("Found firmware: ${firmware.versionName}");
}
   */
}

Future<bool> addFirmware(FirmwareModel newFirmware) async {
// to add one by one
/*
final newFirmware = FirmwareModel(
  id: 321238,
  version: "321.0.35",
  releaseNote: "29/05/2025",
  versionName: "b6 2.0.3",
  deviceTypeid: "3",
  file: "Base64Data",
  saved : true,
  deviceType: "b12"
);
 */
  printFunc("Firmware model : \n${newFirmware.toJson()}");
  final firmwareBox = await Hive.openBox<FirmwareSeriesModel>('$firmwareHiveBox');

  newFirmware.saved = true;

// Try to get existing series
  FirmwareSeriesModel? series = firmwareBox.get(newFirmware.deviceTypeId);
  if (series == null) {
    // Series doesn't exist, create it
    series = FirmwareSeriesModel(
      id: newFirmware.deviceTypeId,
      name: newFirmware.deviceType,
      firmware: [newFirmware],
    );

    // Save to box
    await firmwareBox.put(newFirmware.deviceTypeId, series);
    printFunc("Series ${newFirmware.deviceTypeId} created and firmware ${newFirmware.version} added.");
  } else {
    // Series exists, add new firmware
    series.firmware.add(newFirmware);
    await series.save();
    printFunc("Firmware ${newFirmware.version} added to series ${newFirmware.deviceTypeId}.");
  }

  return true;
}

// to add one by one
/*
final newFirmware = FirmwareModel(
  id: 321238,
  version: "321.0.35",
  releaseNote: "29/05/2025",
  versionName: "b6 2.0.3",
  deviceTypeid: "3",
  file: "Base64Data",
);
 */
Future<List<Map<String, dynamic>>> getAllFirmware() async {
  final box = await Hive.openBox<FirmwareSeriesModel>('$firmwareHiveBox');

  return box.values.map((series) {
    return {
      "id": series.id,
      "name": series.name,
      "firmware": series.firmware.map((fw) {
        return {
          "id": fw.id,
          "version": fw.version,
          "releaseNote": fw.releaseNote,
          "versionName": fw.versionName,
          "deviceTypeId": fw.deviceTypeId,
          "file": fw.file,
          "saved": fw.saved,
          "deviceType": fw.deviceType
        };
      }).toList(),
    };
  }).toList();
}
