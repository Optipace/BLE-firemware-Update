import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';


class AdminMainBtn extends StatelessWidget{
  final String text;
  final Function onpress;
  final Image icon;
  const AdminMainBtn({required this.text,required this.onpress,required this.icon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: size.width/1.2,      // Set your desired width
      height: size.height/15,
      child: ElevatedButton(
        onPressed: onpress as void Function(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
              if (states.contains(MaterialState.pressed)) {
                return darkBg; // Color on hover
              }
              return lightBg; // Default color
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
              if (states.contains(MaterialState.pressed)) {
                return lightBg; // Color on hover
              }
              return darkBg; // Default color
            },
          ),

          elevation: MaterialStateProperty.all(5),
          shadowColor: MaterialStateProperty.all(darkBg),
          shape:MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(
                    color: darkBg,
                    width: 1
                )
            ),
          ),
        ),


        //    ElevatedButton.styleFrom(
        //           elevation: 8,
        //             shadowColor: darkBg,
        //             // padding: EdgeInsets.symmetric(vertical: 16),
        //             shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(25),
        //                 side: BorderSide(
        //                   color: darkBg,
        //                   width: 1
        //                 )
        //             ),
        //         ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: lightBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: darkBg,
                      width: 1
                  )
              ),
              child: Center(
                child: icon,
              ),
            ),
            SizedBox(width: 20,),
            Text(text,style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: baseFont,
                shadows: [Shadow(
                    color: Colors.black,
                    blurRadius:0.1
                )]
            ),),
            Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(CupertinoIcons.chevron_right_2,
                  // color: darkBg,
                  shadows: [Shadow(
                      color: darkBg,
                      blurRadius: 0.5
                  )]),
            )
          ],
        ),
      ),
    );
  }
}

class manageUserBtn extends StatelessWidget{
  final Icon? icon;
  final String text;
  final Function onPress;
  const manageUserBtn({required this.text, required this.onPress,this.icon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: size.width/3,      // Set your desired width
      height: 40,
      child: ElevatedButton(
        onPressed: onPress as void Function(),
        style: ButtonStyle(

          backgroundColor: MaterialStateProperty.all(darkBg),
          elevation: MaterialStateProperty.all(5),
          shadowColor: MaterialStateProperty.all(darkBg),
          shape:MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(
                    color: darkBg,
                    width: 1
                )
            ),
          ),
        ),


        //    ElevatedButton.styleFrom(
        //           elevation: 8,
        //             shadowColor: darkBg,
        //             // padding: EdgeInsets.symmetric(vertical: 16),
        //             shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(25),
        //                 side: BorderSide(
        //                   color: darkBg,
        //                   width: 1
        //                 )
        //             ),
        //         ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
             icon!, // IconData? passed correctly
            if (icon != null)
              SizedBox(width: 5),
            Text(text,style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: baseFont,
                shadows: [Shadow(
                    color: Colors.black,
                    blurRadius:0.1
                )]
            ),)
          ],
        ),
      ),
    );
  }


}
