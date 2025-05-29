import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

class DataEntry {
  static Future<List<int>?> enterData(BuildContext context) async {
    ValueNotifier<bool> isHex = ValueNotifier(false);
    TextEditingController dataController = TextEditingController(text: '');
    double width = MediaQuery.sizeOf(context).width;

    String? res = await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: SizedBox(
              width: width - 20,
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: isHex,
                      builder: (context, value, _) => SegmentedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) => states.contains(MaterialState.selected) ? darkBg : lightBg,
                          ),
                          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) => states.contains(MaterialState.selected) ? lightBg : darkBg,
                          ),
                          side: MaterialStateProperty.resolveWith<BorderSide?>(
                            (states) => BorderSide(
                              color: states.contains(MaterialState.selected) ? darkBg : darkBg,
                              width: 0.8,
                            ),
                          ),
                        ),
                        segments: [
                          ButtonSegment(
                            value: false,
                            label: Text(
                              'String',
                              style:
                                  TextStyle(fontFamily: baseFont, fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ),
                          ButtonSegment(
                            value: true,
                            label: Text(
                              'Hex',
                              style:
                                  TextStyle(fontFamily: baseFont, fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                        selected: {value},
                        multiSelectionEnabled: false,
                        onSelectionChanged: (values) {
                          isHex.value = values.contains(true);
                          dataController.text = '';
                        },
                      ),
                    ),
                    TextFormField(
                      controller: dataController,
                      decoration: InputDecoration(
                        hintText: "Enter data",
                        hintStyle: TextStyle(
                            color: darkBg.withOpacity(0.8),
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w500),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: darkBg,
                          width: 1.8,
                        )),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: darkBg,
                          width: 0.4,
                        )),
                      ),
                      style: TextStyle(
                          color: darkBg, fontSize: 18, fontFamily: baseFont, fontWeight: FontWeight.w500),
                      minLines: 1,
                      maxLines: 10,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (isHex.value && _fromHex(value) == null) {
                            return "Invalid hex string";
                          }
                        }

                        return null;
                      },
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (value) => Navigator.pop(ctx, dataController.text),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: darkBg, fontFamily: baseFont, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, dataController.text),
                child: Text(
                  "Submit",
                  style: TextStyle(color: darkBg, fontFamily: baseFont, fontSize: 18),
                ),
              ),
            ],
          );
        });

    if (res == null || res.isEmpty) {
      return null;
    }
    printFunc("DEMO DEMO DEMO : $res");
    return isHex.value ? _fromHex(res) : utf8.encode(res);
  }

  static List<int>? _fromHex(String? value) {
    if (value == null || value.length % 2 != 0) {
      return null;
    }
    try {
      return [for (int i = 0; i < value.length; i += 2) int.parse(value.substring(i, i + 2), radix: 16)];
    } catch (_) {
      return null;
    }
  }
}
