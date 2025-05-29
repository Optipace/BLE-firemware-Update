import 'package:hive/hive.dart';

part 'profileModel.g.dart';

@HiveType(typeId: 3)
class ProfileModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String releaseNote;

  @HiveField(3)
  String uT;
  @HiveField(4)
  String uV;
  @HiveField(5)
  String lT;
  @HiveField(6)
  String lV;

  @HiveField(7)
  String deviceType;

  @HiveField(8)
  String deviceTypeId;
  @HiveField(9)
  bool saved;

  ProfileModel({
    required this.id,
    required this.name,
    required this.releaseNote,
    required this.uT,
    required this.uV,
    required this.lT,
    required this.lV,
    required this.saved,
    required this.deviceTypeId,
    required this.deviceType,
  });

  @override
  String toString() {
    return 'ProfileModel{id: $id, name: $name, releaseNote: $releaseNote, uT: $uT, uV: $uV, lT: $lT, lV: $lV, deviceType: $deviceType, deviceTypeId: $deviceTypeId, saved: $saved}';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      releaseNote: json['releaseNote'] ?? '',
      uT: json['uT'] ?? '',
      uV: json['uV'] ?? '',
      lT: json['lT'] ?? '',
      lV: json['lV'] ?? '',
      saved: true,
      deviceTypeId: json['deviceTypeId'] ?? '',
      deviceType: json['deviceType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'releaseNote': releaseNote,
      'uT': uT,
      'uV': uV,
      'lT': lT,
      'lV': lV,
      'saved': saved,
      'deviceTypeId': deviceTypeId,
      'deviceType': deviceType,
    };
  }
}
