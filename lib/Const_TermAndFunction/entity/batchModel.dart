import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'battery_model.dart';

import 'firmwareModel.dart';
import 'profileModel.dart';

part 'batchModel.g.dart';

@HiveType(typeId: 5)
class BatchModel extends HiveObject {
  @HiveField(0)
  String batchId;

  @HiveField(1)
  String batchName;

  @HiveField(2)
  String batchDescription;

  @HiveField(3)
  FirmwareModel firmware;

  @HiveField(4)
  ProfileModel profile;

  @HiveField(5)
  BatteryModel battery;

  @HiveField(6)
  bool saved;

  BatchModel({
    required this.batchId,
    required this.batchName,
    required this.batchDescription,
    required this.firmware,
    required this.profile,
    required this.battery,
    required this.saved,
  });

  @override
  String toString() {
    return 'BatchModel{batchId: $batchId, batchName: $batchName, batchDescription: $batchDescription, firmware: $firmware, profile: $profile, Battery: $battery}';
  }

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    printFunc("DEMO DEMO : $json");

    return BatchModel(
      batchId: json['id'] ?? '',
      batchName: json['name'] ?? '',
      batchDescription: json['description'] ?? '',
      firmware: FirmwareModel.fromJson(json['firmware']),
      profile: ProfileModel.fromJson(json['profile']),
      battery: BatteryModel.fromJson(json['batteryDetails']),
      saved: json['saved'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': batchId,
      'name': batchName,
      'description': batchDescription,
      'firmware': firmware.toJson(),
      'profile': profile.toJson(),
      'battery' : battery.toJson(),
      'saved': saved,
    };
  }
}
