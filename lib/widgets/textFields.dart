
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';


class TextFeildNewUser extends StatelessWidget{
  final String hintText;
  final dynamic maxLength;
  final TextEditingController Controller;
  final dynamic type;

  // final ValueChanged<String>? onChanged;

  // final IconData icon;
  final onChanged;
  final etext;
  final dynamic alignemnt;
  final dynamic validator;
  final bool enable;
  final dynamic inputFormatters;
  final double? width;
  final double? height;

  const TextFeildNewUser(
      {key,
        this.maxLength,
        required this.hintText,
        this.type,

        required this.Controller,
        // required this.hintcolor,
        // required this.icon,
        required this.onChanged,
        this.etext,
        this.alignemnt,
        this.height,
        this.width,
        this.validator,
        this.inputFormatters,
        required this.enable})
      : super(key: key);

  Widget build(BuildContext context) {
    if (maxLength != null) {}

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 60,
        width: size.width*0.85,

        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Center(
          child:TextField(
              inputFormatters: inputFormatters,
              cursorWidth: 1,
              style: TextStyle(
                  fontSize: 20,
                  color: enable?darkBg:Colors.black,
                  fontWeight: FontWeight.w300,
                  fontFamily: baseFont,
                  letterSpacing: 0.2
              ),
              keyboardType: type,
              controller: Controller,
              maxLength: maxLength,
              cursorColor: darkBg,
              onChanged: onChanged,
              enabled: enable,
              textAlign: alignemnt ?? TextAlign.left,
              // validator: validator,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkBg,width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width:1),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                focusColor: Colors.black,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        width: 1,
                        color:  etext==""?darkBg :Colors.black
                    )
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        width: 1,
                        color:  etext==""?Colors.black :Color(0xFFFF8A80)
                    )
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        width: 1,
                        color: etext=="" ? Colors.black : Color(0xFFFF8A80)
                    )
                ),
                filled: true,
                fillColor: enable?Colors.white:lightBg,
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF9AC4C9),
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w300
                ),
                errorText:etext=="" ? null : etext,
                errorStyle: TextStyle(
                  color:errorText
                ),
                counterText: ""


              )),
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget{
  final String text;

  const LabelText(
      {key,
        required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(text,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color:darkBg,
              fontFamily: baseFont,
              shadows: [Shadow(
                color: Colors.black,
                blurRadius: 0.2,
                // offset: Offset(0.5, 0.5)
              )]
          )
      ),
    );
  }


}

class SearchTextFieldContainer extends StatelessWidget {
  final Widget? child;

  const SearchTextFieldContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        width: size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.0),
          color: Colors.white,
        ),
        child: child);
  }
}

class CircularTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? Controller;
  final dynamic type;
  final dynamic maxLength;
  final bool obscure;
  final IconData? icon;
  final IconData? sufixicon;
  dynamic etext;
  final Color? color;
  final ValueChanged<String>? onSubmitted;

  final ValueChanged<String>? onChanged;

  CircularTextField({
    Key? key,
    this.type,
    this.etext,
    this.maxLength,
    this.Controller,
    this.icon/*= Icons.person*/,
    this.onChanged,
    this.sufixicon,
    this.obscure = false,
    this.onSubmitted,
    this.hintText,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchTextFieldContainer(
      child: TextField(
        controller: Controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29.0),
          ),
          suffixIcon: Icon(
            sufixicon,
            color: Colors.black,
            size: 20,
          ),
          prefix: Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
          hintText: hintText,
          fillColor: const Color(0xffffffff),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: Colors.black,
      ),
    );
  }
}
