import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/bluetoothMain.dart';
import 'package:tracker_firmware/modules/factoryUser/batchList/batchList.dart';
import 'package:tracker_firmware/modules/factoryUser/profiles/profileFactoryManagement.dart';
import 'package:tracker_firmware/modules/fieldOfficer/ScanBluetooth/bluetoothBatches.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';

import 'firmwares/firmwareFactoryManagement.dart';

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
                  enable: false,
                  icon: Icon(
                    Icons.system_update_outlined,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Firmwares",
                  onPress: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (_) => FirmwareFactoryManagement()));
                  }),
              SizedBox(
                height: 15,
              ),
              PrimaryButton(
                  enable: false,
                  icon: Icon(
                    Icons.handyman_outlined,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Config/Service",
                  onPress: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (_) => ProfileFactoryManagement()));
                  }),
              SizedBox(
                height: 15,
              ),
              PrimaryButton(
                  icon: Icon(
                    Icons.handyman_outlined,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Batch/Profile",
                  onPress: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (_) => BatchFactoryManagement()));
                  }),
              SizedBox(
                height: 15,
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

                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => BlueetoothBatches()));
                  }),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }
}
