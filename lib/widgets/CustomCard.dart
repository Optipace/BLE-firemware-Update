import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';

class ErrorContainer extends StatelessWidget {
  final bool show;
  final String errorMsg;

  const ErrorContainer({
    required this.show,
    required this.errorMsg,
  });

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            margin: const EdgeInsets.only(left: 28, top: 10),
            alignment: Alignment.topLeft,
            child: Text("$errorMsg",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 12,
                    // fontWeight: FontWeight.w500,
                    color: errorText)),
          )
        : SizedBox();
  }
}
