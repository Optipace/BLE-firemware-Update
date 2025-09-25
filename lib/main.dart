import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/dataBase/dbSetUp.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/batchModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/battery_model.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/firmwareSeriesModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/getNumberModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/profileSeriesModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/hive/hiveOperation.dart';
import 'package:tracker_firmware/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  DataBase.initializeDatabase();
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
  // await Hive.deleteBoxFromDisk('$getNumberHiveBox');

  // Hive box for battery Details

  // Register adapters BEFORE using any boxes
  // Hive.registerAdapter(FirmwareModelAdapter());
  // Hive.registerAdapter(FirmwareSeriesModelAdapter());

  //Without DEV-
  developerOption
   ? SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    runApp(MyApp());
  })

  // with Dev-option
   : SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    bool isDevEnabled = await DevOptionsChecker.isDevOptionsEnabled();
    if (isDevEnabled) {
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [darkBg, lightBg], // Your gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: AlertDialog(
                title: Text("Access Blocked"),
                content: Text("Developer Options or USB Debugging is enabled.\nPlease disable it to use this app."),
                actions: [
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    style:ButtonStyle(
                        elevation: MaterialStatePropertyAll(5),
                        backgroundColor: MaterialStatePropertyAll(darkBg),
                        shadowColor: MaterialStatePropertyAll(Colors.black),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                    child: Text("Exit",style: TextStyle(color: lightBg),),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    } else {
      runApp(MyApp());
    }
  });
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
          trackColor:
              MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.5)),
        ),
      ),
      home: splashScreen(),
    );
  }
}

class DevOptionsChecker {
  static const MethodChannel _channel = MethodChannel('dev_options_channel');

  static Future<bool> isDevOptionsEnabled() async {
    try {
      final bool result = await _channel.invokeMethod('checkDevOptions');
      return result;
    } catch (e) {
      printFunc("Error checking developer options: $e");
      return false;
    }
  }
}
