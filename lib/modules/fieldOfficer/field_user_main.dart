import 'package:flutter/material.dart';
import 'package:tracker_firmware/widgets/dashBoard.dart';

class FieldMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dashboard(
        text: "Feild-User \n DashBoard",
        userProfile: true,
        child: Center(
          child: Text("FIELD USER MENU"),
        ));
  }
}
