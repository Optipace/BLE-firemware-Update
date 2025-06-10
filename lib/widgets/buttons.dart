import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Widget? icon;
  final Widget? tailIcon;
  final double? width;
  final double? height;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPress,
    this.icon,
    this.width,
    this.height,
    this.color,
    this.tailIcon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = width ?? screenWidth * 0.65;

    return ElevatedButton(
      onPressed: onPress as void Function(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color ?? lightBg),
        foregroundColor: MaterialStateProperty.all(darkBg),
        elevation: MaterialStateProperty.all(5),
        shadowColor: MaterialStateProperty.all(darkBg),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: darkBg, width: 1),
          ),
        ),
      ),
      child: Container(
        width: buttonWidth,
        height: height ?? 40,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: lightBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: darkBg, width: 1),
                ),
                child: Center(child: icon),
              ),
            if (icon != null) SizedBox(width: 20),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: baseFont,
                    shadows: [Shadow(color: Colors.black, blurRadius: 0.1)],
                  ),
                ),
              ),
            ),
            tailIcon ??
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        CupertinoIcons.chevron_right_2,
                        size: 20,
                        shadows: [Shadow(color: darkBg, blurRadius: 0.5)],
                      )
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class manageUserBtn extends StatelessWidget {
  final Icon? icon;
  final String text;
  final Function onPress;
  final double? width;
  final double? height;

  const manageUserBtn({required this.text, required this.onPress, this.icon, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onPress as void Function(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(darkBg),
        elevation: MaterialStateProperty.all(5),
        shadowColor: MaterialStateProperty.all(darkBg),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), side: BorderSide(color: darkBg, width: 1)),
        ),
      ),
      child: Container(
        height: height ?? 50,
        width: width ?? size.width / 2.5,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!, // IconData? passed correctly
              if (icon != null) SizedBox(width: 5),
              Text(
                text,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: baseFont,
                  shadows: [Shadow(color: Colors.black, blurRadius: 0.1)],
                  overflow: TextOverflow.visible,
                ),
              )
            ],
          ),
        ),
      ),
    );
    // Container(
    //   color: Colors.green,
    //   width: size.width/2.5,      // Set your desired width
    //   height: 80,
    //   child:            FittedBox(fit:BoxFit.scaleDown,
    //
    //     child:
    //   ),
    // );
  }
}
