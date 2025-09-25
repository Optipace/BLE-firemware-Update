import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/modules/dfuModule/bluetoothMain.dart';
import 'package:tracker_firmware/modules/factoryUser/Calibration/calibration_main.dart';
import 'package:tracker_firmware/modules/factoryUser/Locate%5BFind_my_device%5D/locate_Device.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/assignClient.dart';
import 'package:tracker_firmware/modules/factoryUser/batchList/batchList.dart';
import 'package:tracker_firmware/modules/fieldOfficer/ScanBluetooth/bluetoothBatches.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';

import 'pairBattery/PairBattery.dart';

class FactoryMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: 'Factory User',
        userProfile: true,
        sliderChild: Column(
          children: [
            //Download Batches
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => BatchFactoryManagement()));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.download,
                          size: 22,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 0.3,
                              offset: Offset(0.5, 0.4),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Download Batches",
                          style: TextStyle(
                              fontFamily: baseFont,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 0.3,
                                  offset: Offset(0.5, 0.4),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
            //locate device
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => BluetoothMainScreen(
                                onBluetoothOn: () => locateHomePage(),
                              )));
                    },
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.location_solid,
                          size: 22,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 0.3,
                              offset: Offset(0.5, 0.4),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Locate Device",
                          style: TextStyle(
                              fontFamily: baseFont,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 0.3,
                                  offset: Offset(0.5, 0.4),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
            //calibration
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => BluetoothMainScreen(
                                onBluetoothOn: () => CalibrateDevice(),
                              )));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings_input_component,
                          size: 22,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 0.3,
                              offset: Offset(0.5, 0.4),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Calibration",
                          style: TextStyle(
                              fontFamily: baseFont,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 0.3,
                                  offset: Offset(0.5, 0.4),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ],
        ),
        floatingBtn: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(shape: BoxShape.circle, color: darkBg),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => BatchFactoryManagement()));
            },
            icon: Icon(
              Icons.download,
              size: 34,
              color: lightBg,
            ),
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
                  text: "Scan Device",
                  onPress: () {
                    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => SavedBatches()));
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
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => BluetoothMainScreen(
                              onBluetoothOn: () => PairBattery(),
                            )));
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
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => BluetoothMainScreen(
                              onBluetoothOn: () => AssignClient(),
                            )));
                  }),
              SizedBox(
                height: 15,
              ),

              //locate btn
              PrimaryButton(
                  icon: Icon(
                    CupertinoIcons.location_solid,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        24,
                    color: darkBg,
                  ),
                  text: "Locate Device",
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => BluetoothMainScreen(
                              onBluetoothOn: () => locateHomePage(),
                            )));
                  }),
              SizedBox(
                height: 15,
              ),

              //Calibration btn
              PrimaryButton(
                  icon: Icon(
                    Icons.settings_input_component,
                    size:
                        // Image.asset('assets/image/viewLog.png',width: 24,height:
                        18,
                    color: darkBg,
                  ),
                  text: "Calibration",
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => BluetoothMainScreen(
                              onBluetoothOn: () => CalibrateDevice(),
                            )));
                  }),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
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
              SizedBox(height: 15,),
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
