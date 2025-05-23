import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

BottomSheet_Widget(context, childrens, {String? isFixed, Color? color}) {
  ScrollController _scrollController = ScrollController();

  printFunc("isFixed :$isFixed");
  return showModalBottomSheet(
    showDragHandle: true,

    isScrollControlled: true,
    isDismissible: false,
    enableDrag: isFixed == "true" ? false : true,
    constraints: BoxConstraints(maxHeight: size.height * 0.75),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25),),
    ),
    backgroundColor: color ?? Color(0xFF5FAAB0),
    context: context,
    builder: (context) =>
    //   Stack(
    // children: [
    Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      controller: _scrollController,
      thickness: 6,
      // scrollbarOrientation:ScrollbarOrientation.right,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child:
          Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: childrens,
            ),
            SizedBox(height: 20),
          ]),
        ),
      ),
    ),
  );
}
