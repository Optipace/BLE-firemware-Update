import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/modules/fieldOfficer/ScanBluetooth/bluetoothBatches.dart';
import 'package:tracker_firmware/modules/fieldOfficer/batchList/fieldBatchUser.dart';
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
              // FirmWares
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
                        .push(MaterialPageRoute<void>(builder: (_) => FirmwareFieldManagement()));
                  }),
              //SizedBox
              /*
              SizedBox(
                height: 25,
              ),*/
              // Config/Service
              PrimaryButton(
                  enable: false,
                  icon: Icon(
                    Icons.handyman_outlined,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Profiles/Config",
                  onPress: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (_) => ProfileFieldManagement()));
                  }),
              SizedBox(
                height: 25,
              ),
              // Batch/Profile
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
                        .push(MaterialPageRoute<void>(builder: (_) => BatchFeildManagement()));
                  }),
              SizedBox(
                height: 15,
              ),
              // scan-device
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
                    // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => BlueetoothBatches()));
                  }),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ));
  }
}
