import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/batchModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/battery_model.dart';
// import 'package:tracker_firmware/Const_TermAndFunction/entity/batteryModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareSeriesModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/getNumberModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileSeriesModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/hive/hiveOperation.dart';
import 'package:tracker_firmware/widgets/splash_screen.dart';
import 'dev_options_checker.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  // final hiveService = HiveService('$firmwareBox');

  await Hive.openBox<ProfileSeriesModel>('$serviceHiveBox');

  Hive.registerAdapter(ProfileModelAdapter());
  Hive.registerAdapter(ProfileSeriesModelAdapter());

  Hive.registerAdapter(BatchModelAdapter());

  Hive.registerAdapter(FirmwareModelAdapter());
  Hive.registerAdapter(BatteryModelAdapter());

  Hive.registerAdapter(FirmwareSeriesModelAdapter());

  await Hive.openBox<BatchModel>('$batchHiveBox');
  // await Hive.deleteBoxFromDisk('$batchHiveBox');

  // Hive.registerAdapter(BatchModelAdapter());

  await Hive.openBox<FirmwareSeriesModel>('$firmwareHiveBox');

  // Hive box for Number

  Hive.registerAdapter(GetNumberModelAdapter());
  await Hive.openBox<GetNumberModel>('$getNumberHiveBox');

  // Hive box for battery Details


  // ✅ Register adapters BEFORE using any boxes
  // Hive.registerAdapter(FirmwareModelAdapter());
  // Hive.registerAdapter(FirmwareSeriesModelAdapter());
  //Without DEV-Option

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    runApp(MyApp());
  }); 

  //Dev-option
  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    bool isDevEnabled = await DevOptionsChecker.isDevOptionsEnabled();
    if (isDevEnabled) {
      runApp(MaterialApp(
        home: Scaffold(
          body: Center(
            child: AlertDialog(
              title: Text("Access Blocked"),
              content: Text("Developer Options or USB Debugging is enabled.\nPlease disable it to use this app."),
              actions: [
                TextButton(
                  onPressed: () => SystemNavigator.pop(), // Exit app
                  child: Text("Exit"),
                )
              ],
            ),
          ),
        ),
      ));
    } else {
      runApp(MyApp());
    }
  }); */
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRACKER FIRMWARE PROVISIONING',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: darkBg,
          elevation: 0.3,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all<Color>(Colors.white),
          trackColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.5)),
        ),
      ),
      home: splashScreen(),
    );
  }
}
