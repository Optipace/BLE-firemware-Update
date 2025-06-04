import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/bluetoothMain.dart';
import 'package:tracker_firmware/modules/fieldOfficer/firmwares/firmwareFieldManagement.dart';
import 'package:tracker_firmware/modules/fieldOfficer/profiles/profileFieldManagement.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';

class FieldMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: 'Field User',
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
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => FirmwareFieldManagement()));
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
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => ProfileFieldManagement()));
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

                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => FlutterBlueApp()));
                  }),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ));
  }
}
