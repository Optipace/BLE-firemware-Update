import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class PrimeryDropDownButton extends StatelessWidget {
  final bool isEnabled;
  final bool isMandatory;
  final String? mainText;
  final String? text;
  final Icon? icon;
  final double? width;
  final double? height;
  final Function? press;
  final Color? color, textColor;
  final Widget? tail;
  final Widget? anchor;

  const PrimeryDropDownButton({
    Key? key,
    this.color,
    this.textColor = Colors.black,
    this.text,
    this.mainText,
    this.icon,
    this.width,
    this.height,
    this.press,
    this.isEnabled = true,
    this.isMandatory = false,
    this.tail,
    this.anchor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? size.width * 0.90,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              anchor ?? SizedBox(),
              Container(
                  margin: EdgeInsets.only(
                    // left: 25,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${mainText.toString()} ",
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500,fontFamily: baseFont),
                      ),
                      isMandatory
                          ? Text(
                        "*",
                        style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w500,fontFamily: baseFont),
                      )
                          : SizedBox(),
                    ],
                  )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 5.0,
            ),
            decoration: BoxDecoration(
                color: isEnabled ? color ?? darkBg : lightBg,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.3)),
            height: height ?? 45,
            width: width ?? size.width * 0.90,
            child: InkWell(
              // color: color,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          text!,
                          style: TextStyle(
                            color: isEnabled ? Colors.black87 : Colors.black87,
                            fontSize: 16,
                            fontFamily: baseFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20, bottom: 10),
                      child: Center(
                        child: icon,
                      ),
                    ),
                  ],
                ),
                onTap: isEnabled ? press as void Function()? : () {}),
          ),
          tail ?? SizedBox(),
        ],
      ),
    );
  }
}


class MapListItemBuilder extends StatefulWidget {
  final Map<String, dynamic> listItems;
  final Function()? press;
  final DataController? selected;
  final bool searchEnable;

  const MapListItemBuilder(
      {Key? key, required this.listItems, this.press, this.selected, this.searchEnable = false})
      : super(key: key);

  @override
  State<MapListItemBuilder> createState() => _MapListItemBuilderState();
}

class _MapListItemBuilderState extends State<MapListItemBuilder> {
  TextEditingController search = TextEditingController();

  Map<String, dynamic> suggestionList = {};

  // Track selected item
  String? selectedItem;

  @override
  void initState() {
    super.initState();

    suggestionList.addAll(widget.listItems);
    search.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 1.0,
        ),
        widget.searchEnable
            ? CircularTextField(
            hintText: "Search",
            Controller: search,
            sufixicon: Icons.search_outlined,
            onChanged: (value) {
              suggestionList.clear();
              printFunc("search texts $value");
              printFunc(widget.listItems);
              widget.listItems.entries.forEach((e) {
                printFunc("search text $value");
                printFunc(e);
                if (e.key.toLowerCase().contains(value.toLowerCase())) {
                  suggestionList[e.key] = e.value;
                }
              });

              (context as Element).markNeedsBuild();
            })
            : SizedBox(),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 5, right: 5, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 0.7,
                child: Text(
                  "SELECT",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    // color: Color(0xff817f98),
                    color: Colors.white24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              /*
              Radio(
                // activeColor:Colors.green,
                fillColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white24;
                    }
                    return Colors.white24;
                  },
                ),
                // overlayColor:Color(0xFFFFFFFF),
                // fillColor:Colors.green,
                value:"SELECT",

                groupValue: widget.selected?.getText,
                onChanged: (value) {},
              ),*/
            ],
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount:
          search.text == "null" || search.text == "" ? widget.listItems.length : suggestionList.length,
          itemBuilder: (context, index) {
            final entry = search.text == "null" || search.text == ""
                ? widget.listItems.entries.toList()[index]
                : suggestionList.entries.toList()[index];

            return Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 5, right: 5, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Container(
                      width: size.width * 0.7,
                      child: Text(
                        entry.key.trim(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          // color: Color(0xff817f98),
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedItem = entry.key;
                        widget.selected?.setobj = entry.value;
                        widget.selected!.setText = entry.key;
                        if (widget.press != null) {
                          widget.press!();
                        }
                      });

                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  /*
                  Radio(
                    // activeColor:Colors.green,
                    fillColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      },
                    ),
                    // overlayColor:Color(0xFFFFFFFF),
                    // fillColor:Colors.green,
                    value: entry.key,
                    groupValue: widget.selected?.getText,
                    onChanged: (value) {
                      setState(() {
                        setState(() {
                          selectedItem = entry.key;
                          widget.selected?.setobj = entry.value;
                          widget.selected!.setText = entry.key;
                          if (widget.press != null) {
                            widget.press!();
                          }
                        });

                        Navigator.of(context, rootNavigator: true).pop();
                        printFunc(value);
                        printFunc(widget.selected?.getText.toString());
                        // selectedItem = value.toString();
                      });
                    },
                  ),*/
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}


