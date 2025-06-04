import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';

import "characteristic_tile.dart";

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({super.key, required this.service, required this.characteristicTiles});

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${service.uuid.str.toUpperCase()}';
    return Text(uuid,
        style: TextStyle(
            fontSize: 16, fontFamily: baseFont, fontWeight: FontWeight.w300, color: darkBg.withOpacity(0.8)));
  }

  @override
  Widget build(BuildContext context) {
    return characteristicTiles.isNotEmpty
        ? ExpansionTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Service',
                    style: TextStyle(
                      color: darkBg,
                      fontWeight: FontWeight.w700,
                      fontFamily: baseFont,
                      fontSize: 20,
                    )),
                buildUuid(context),
              ],
            ),
            children: characteristicTiles,
          )
        : ListTile(
            title: Text(
              'Service',
              style: TextStyle(
                color: darkBg,
                fontWeight: FontWeight.w700,
                fontFamily: baseFont,
                fontSize: 20,
              ),
            ),
            subtitle: buildUuid(context),
          );
  }
}
