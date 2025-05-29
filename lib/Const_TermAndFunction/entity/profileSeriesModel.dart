import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileModel.dart';

part 'profileSeriesModel.g.dart';

@HiveType(typeId: 4)
class ProfileSeriesModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<ProfileModel> profile;

  ProfileSeriesModel({
    required this.id,
    required this.name,
    required this.profile,
  });
}
