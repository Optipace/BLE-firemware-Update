import 'package:hive/hive.dart';

part 'battery_model.g.dart';

@HiveType(typeId: 7)
class BatteryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String batteryName;

  @HiveField(2)
  String batteryCode;



  BatteryModel(
      {required this.id,
        required this.batteryName,
        required this.batteryCode});

  @override
  String toString() {
    return 'BatteryModel { id : $id, batteryName : $batteryName, batteryCode : $batteryCode}';
  }

  factory BatteryModel.fromJson(Map<String, dynamic> json) {
    return BatteryModel(
        id: json['id'] ?? '',
        batteryName: json['name'] ?? '',
        batteryCode: json['Battery-Code'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batteryName': batteryName,
      'batteryCode': batteryCode
    };
  }
}