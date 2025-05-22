import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final bool show;
  final String errorMsg;

  const ErrorContainer({
    required this.show,
    required this.errorMsg,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return show
        ? Container(
      // width: size.width,
      margin: const EdgeInsets.only(left: 0),
      alignment: Alignment.topLeft,
           child:
           Text("$errorMsg",
                textAlign: TextAlign.left,
                style: const TextStyle(
            fontSize: 12,
            // fontWeight: FontWeight.w500,
            color: Colors.red,
            fontFamily: "Graphik,light",
          )
        ),
    )
        : SizedBox();
  }
}