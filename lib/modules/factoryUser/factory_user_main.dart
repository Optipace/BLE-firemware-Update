import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/assignClient.dart';
import 'package:tracker_firmware/modules/factoryUser/batchList/batchList.dart';
import 'package:tracker_firmware/modules/fieldOfficer/ScanBluetooth/bluetoothBatches.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';

import 'firmwares/firmwareFactoryManagement.dart';
import 'pairBattery/PairBattery.dart';

class FactoryMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: 'Factory User',
        userProfile: true,
        floatingBtn: Container(
          padding: EdgeInsets.all(5),
          decoration:BoxDecoration(
            shape: BoxShape.circle,
            color: darkBg
          ) ,
          child: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (_) => BatchFactoryManagement()));
            },
            icon: Icon(Icons.download,size: 34,color: lightBg,),

          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Scan Device
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

                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => SavedBatches()));
                  }),
              SizedBox(
                height: 15,
              ),
              //Pairing Battery
              PrimaryButton(
                  icon: Icon(
                  Icons.battery_full_outlined,
                    size: 24,
                    color: darkBg,
                  ),
                  text: "Pair Battery",
                  onPress: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (_) => PairBattery()));
                  }),
              SizedBox(
                height: 15,
              ),
              //Assign Customer
              PrimaryButton(
                  icon: Icon(
                    CupertinoIcons.person_add,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Assign Client",
                  onPress: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (_) => AssignClient()));
                  }),
              SizedBox(
                height: 15,
              ),



            ],
          ),
        )
    );
  }
}

/*
 //Firmware[Not in used]
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
              //Config/profile [Not in used]
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
              //Batch Download [ not in used]
              PrimaryButton(
                enable: false,
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
              ),*/