import 'package:flutter/material.dart';

import '../Const_TermAndFunction/constants.dart';
import '../Const_TermAndFunction/generalMethods.dart';

class Dashboard extends StatelessWidget {
  final String text;
  final Image? icon;
  final Widget child;

  const Dashboard({required this.text, this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
// resizeToAvoidBottomInset: true,
        body: Column(
      children: [
        Container(
          height: size.height / 3.5 + 30,
          child: Stack(
            children: [
              Container(
                color: lightBg,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: darkBg,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(150),
                        bottomRight: Radius.circular(150),
                      ),
                      border: Border.all(color: Colors.black, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: darkBg,
                          blurRadius: 30,
                        )
                      ]),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: size.height * 0.1),
                width: size.width,
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 38,
                        color: lightBg,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                        backgroundColor: darkBg,
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: lightBg,
                child: SingleChildScrollView(child: child)))
      ],
    ));
  }
}
