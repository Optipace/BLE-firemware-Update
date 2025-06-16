import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileSeriesModel.dart';

Future<void> saveProfileListToHive(List<Map<String, dynamic>> profileList) async {
  final profileBox = await Hive.openBox<ProfileSeriesModel>('$serviceHiveBox');

  for (var series in profileList) {
    List<ProfileModel> profileModels = (series['configuration'] as List).map((f) {
      return ProfileModel(
        id: f['id'] ?? 0,
        name: f['name'] ?? '',
        releaseNote: f['discription'] ?? '',
        uT: f['upperThreshold'] ?? '',
        uV: f['upperVoltage'] ?? '',
        lT: f['lowerThreshold'] ?? '',
        lV: f['lowerVoltage'] ?? '',
        saved: true,
        deviceTypeId: f['deviceId'] ?? '',
        deviceType: f['deviceType'] ?? '',
      );
    }).toList();

    var seriesModel = ProfileSeriesModel(
      id: series['id'],
      name: series['deviceName'],
      profile: profileModels,
    );

    await profileBox.put(series['id'], seriesModel);
  }
}

Future<ProfileModel?> getProfileByVersion(String seriesId, String name) async {
  final profileBox = await Hive.openBox<ProfileSeriesModel>('$serviceHiveBox');
  final series = profileBox.get(seriesId);
  if (series != null) {
    return series.profile.firstWhere(
      (fw) => fw.name == name,
      // orElse: () => null,
    );
  }
  return null;
}

Future<bool> addProfile(ProfileModel newProfile) async {
// to add one by one
/*
final newProfile = ProfileModel(
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

  final profileBox = await Hive.openBox<ProfileSeriesModel>('$serviceHiveBox');

  newProfile.saved = true;

// Try to get existing series
  ProfileSeriesModel? series = profileBox.get(newProfile.deviceTypeId);
  if (series == null) {
    // Series doesn't exist, create it
    series = ProfileSeriesModel(
      id: newProfile.deviceTypeId,
      name: newProfile.deviceType,
      profile: [newProfile],
    );

    // Save to box
    await profileBox.put(newProfile.deviceTypeId, series);
    print("Series ${newProfile.deviceTypeId} created and profile ${newProfile.name} added.");
  } else {
    // Series exists, add new profile
    series.profile.add(newProfile);
    await series.save();
    print("Profile ${newProfile.name} added to series ${newProfile.deviceTypeId}.");
  }

  return true;
}

Future<List<Map<String, dynamic>>> getAllProfile() async {
  final box = await Hive.openBox<ProfileSeriesModel>('$serviceHiveBox');

  return box.values.map((series) {
    return {
      "id": series.id,
      "name": series.name,
      "profile": series.profile.map((fw) {
        return {
          "id": fw.id,
          "version": fw.name,
          "releaseNote": fw.releaseNote,
          "versionName": fw.uT,
          "uV": fw.uV,
          "lT": fw.lT,
          "lV": fw.lV,
          "deviceTypeId": fw.deviceTypeId,
          "saved": fw.saved,
          "deviceType": fw.deviceType
        };
        ;
      }).toList(),
    };
  }).toList();
}
