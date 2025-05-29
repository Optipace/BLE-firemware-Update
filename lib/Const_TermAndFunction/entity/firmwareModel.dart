import 'package:hive/hive.dart';

part 'firmwareModel.g.dart';

@HiveType(typeId: 1)
class FirmwareModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String version;

  @HiveField(2)
  String releaseNote;

  @HiveField(3)
  String versionName;

  @HiveField(4)
  String deviceTypeId;

  @HiveField(5)
  String file;
  @HiveField(6)
  bool saved;
  @HiveField(7)
  String deviceType;

  FirmwareModel({
    required this.id,
    required this.version,
    required this.releaseNote,
    required this.versionName,
    required this.deviceTypeId,
    required this.file,
    required this.saved,
    required this.deviceType,
  });

  @override
  String toString() {
    return 'FirmwareModel{id: $id, version: $version, releaseNote: $releaseNote, versionName: $versionName, deviceTypeId: $deviceTypeId, file: $file, saved: $saved, deviceType: $deviceType}';
  }

  factory FirmwareModel.fromJson(Map<String, dynamic> json) {
    return FirmwareModel(
      id: json['id'] ?? 0,
      version: json['version'] ?? '',
      releaseNote: json['releaseNote'] ?? '',
      versionName: json['versionName'] ?? '',
      deviceTypeId: json['deviceTypeId'] ?? '',
      file: json['file'] ?? '',
      saved: true,
      deviceType: json['deviceType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'releaseNote': releaseNote,
      'versionName': versionName,
      'deviceTypeId': deviceTypeId,
      'file': file,
      'saved': saved,
      'deviceType': deviceType,
    };
  }
}
