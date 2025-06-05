import 'package:hive/hive.dart';

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
  bool saved;

  BatchModel({
    required this.batchId,
    required this.batchName,
    required this.batchDescription,
    required this.firmware,
    required this.profile,
    required this.saved,
  });

  @override
  String toString() {
    return 'BatchModel{batchId: $batchId, batchName: $batchName, batchDescription: $batchDescription, firmware: $firmware, profile: $profile}';
  }

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      batchId: json['id'] ?? '',
      batchName: json['name'] ?? '',
      batchDescription: json['description'] ?? '',
      firmware: FirmwareModel.fromJson(json['firmware']),
      profile: ProfileModel.fromJson(json['profile']),
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
      'saved': saved,
    };
  }
}
