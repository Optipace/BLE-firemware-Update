import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/admin_logs.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/bluetoothMain.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';

import '../../widgets/buttons.dart';

class FactoryMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: 'Factory User',
        userProfile: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                  icon: Icon(
                    Icons.system_update_outlined,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Firmwares",
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AdminLogs()));
                  }),
              SizedBox(
                height: 25,
              ),
              PrimaryButton(
                  icon: Icon(
                    Icons.handyman_outlined,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Profiles/Service",
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AdminLogs()));
                  }),
              SizedBox(
                height: 25,
              ),
              PrimaryButton(
                  icon: Icon(
                    Icons.bluetooth_audio_outlined,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Scan device",
                  onPress: () {
                    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => FlutterBlueApp()));
                  }),
              SizedBox(
                height: 25,
              ),

//----logout----------
              SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    await LogOut(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: darkBg,
                      elevation: 8,
                      shadowColor: darkBg,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Colors.black, width: 0.5))),
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontSize: 22,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                        shadows: [Shadow(color: Colors.black, blurRadius: 0.1)]),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
