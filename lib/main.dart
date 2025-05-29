import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/widgets/splash_screen.dart';

import 'Const_TermAndFunction/entiry/firmwareModel.dart';
import 'Const_TermAndFunction/entiry/firmwareSeriesModel.dart';
import 'Const_TermAndFunction/hive/hiveOperation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  final hiveService = HiveService('$serviceBox');
  // ✅ Register adapters BEFORE using any boxes
  Hive.registerAdapter(FirmwareModelAdapter());
  Hive.registerAdapter(FirmwareSeriesModelAdapter());
  // final Hive6 = HiveService('$seriesSix');
  // final hive9 = HiveService('$seriesNine');
  // final hive12 = HiveService('$seriesTwelve');
  await hiveService.openBox();
  // await Hive6.openBox();
  // await hive9.openBox();
  // await hive12.openBox();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    runApp(MyApp());
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
          trackColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.5)),
        ),
      ),
      home: splashScreen(),
    );
  }
}
