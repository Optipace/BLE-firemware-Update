import 'package:hive/hive.dart';

import 'firmwareModel.dart';

part 'firmwareSeriesModel.g.dart';

@HiveType(typeId: 2)
class FirmwareSeriesModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<FirmwareModel> firmware;

  FirmwareSeriesModel({
    required this.id,
    required this.name,
    required this.firmware,
  });
}
