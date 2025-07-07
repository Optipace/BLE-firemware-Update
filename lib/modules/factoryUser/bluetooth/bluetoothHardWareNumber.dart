import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracker_firmware/Const_TermAndFunction/DataClasses.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/getNumberModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/widgets/BottomSheet.dart';
import 'package:tracker_firmware/widgets/CustomCard.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/dropDownButton.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class BluetoothHardwareNumber extends StatefulWidget {
  final DataController? SelectedBatch;
  final Map<String, dynamic>? allclients;

  BluetoothHardwareNumber({super.key, this.SelectedBatch, this.allclients});

  @override
  State<BluetoothHardwareNumber> createState() => BluetoothHardwareNumberState();
}

class BluetoothHardwareNumberState extends State<BluetoothHardwareNumber> {
  Map<String, dynamic> HardWareMap = {};
  List<Map<String, dynamic>> allClients = [{}];
  TextEditingController batchName = new TextEditingController();
  TextEditingController firmWareName = new TextEditingController();
  TextEditingController configName = new TextEditingController();
  DataController HardWareNumber = DataController();
  DataController ClientName = DataController();

  bool _validateDropDown = false;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    generateHardWareMap();
  }

  @override
  Widget build(BuildContext context) {
    batchName.text = widget.SelectedBatch?.obj['name'];
    firmWareName.text = widget.SelectedBatch?.obj['firmware']['versionName'];
    configName.text = widget.SelectedBatch?.obj['profile']['name'];
    HardWareNumber.setobj=HardWareMap.entries.first.value;
    HardWareNumber.setText=HardWareMap.entries.first.key;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Adding",
          style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
        ),
        toolbarHeight: screenSize.height / 13,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      body: Center(
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // <-- radius here
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: second_lightBg.withOpacity(0.5),
                border: Border.all(
                  color: darkBg,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Center(
                    child: Text(
                      "ENTER THE DETAILS",
                      style: TextStyle(
                          fontFamily: baseFont,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: darkBg,
                          shadows: [Shadow(color: Colors.black, blurRadius: 0.5, offset: Offset(0.5, 0.5))]),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        const LabelText(text: "Batch Name :"),
                        TextFeildNewUser(
                          hintText: batchName.text,
                          Controller: batchName,
                          onChanged: (value) {},
                          enable: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const LabelText(text: "FirmWare Name :"),
                        TextFeildNewUser(
                          hintText: firmWareName.text,
                          Controller: firmWareName,
                          onChanged: (value) {},
                          enable: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const LabelText(text: "Config Name :"),
                        TextFeildNewUser(
                          hintText: configName.text,
                          Controller: configName,
                          onChanged: (value) {},
                          enable: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: PrimeryDropDownButton(
                            isEnabled: true,
                            tail: ErrorContainer(
                                show: _validateDropDown && HardWareNumber.getText == "",
                                errorMsg: "Please Select the HardWare Number"),
                            mainText: "Select HardWare Number",
                            text:
                                HardWareNumber.Text != "" ? HardWareNumber.getText : "Select HardWare Number",
                            // icon: Icon(
                            //   Icons.keyboard_arrow_down_sharp,
                            //   color: darkBg,
                            // ),
                            press: () async {
                              await BottomSheet_Widget(context, [
                                MapListItemBuilder(
                                    listItems: HardWareMap,
                                    press: () {
                                      printFunc("Demo datacontroller - ${HardWareNumber.getText}");
                                    },
                                    selected: HardWareNumber)
                              ]);
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: PrimeryDropDownButton(
                            isEnabled: true,
                            tail: ErrorContainer(
                                show: _validateDropDown && ClientName.getText == "",
                                errorMsg: "Please Select the Client"),
                            mainText: "Select Client Name",
                            text: ClientName.Text != "" ? ClientName.getText : "Select Client Name",
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: darkBg,
                            ),
                            press: () async {
                              await BottomSheet_Widget(context, [
                                MapListItemBuilder(
                                    listItems: widget.allclients!,
                                    press: () {},
                                    selected: ClientName
                                )
                              ]);
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: manageUserBtn(
                      text: "Submit",
                      onPress: () async {
                        ValidateDropDown(HardWareNumber, ClientName);
                        await deleteByHardWareNumber();
                        AddedSuccess(HardWareNumber,ClientName);


                        if(_added){
                          ShowSnackBarMessage(context, 'Added successfully', true);
                          Navigator.of(context).pop();
                        }
                      }),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  void generateHardWareMap() {
    final box = Hive.box<GetNumberModel>('$getNumberHiveBox');
    HardWareMap = {
      for (var item in box.values)
        item.productId.toString(): {
          'id': item.id,
          'productId': item.productId,
          'discription': item.discription,
          'createdOn': item.createdOn,
          'active': item.active
        }
    };
  }

  void ValidateDropDown(DataController HardwareNumber, DataController ClientName) {
    if (HardWareNumber.getText == "" && ClientName.getText == "") {
      setState(() {
        _validateDropDown = true;
      });
    } else {
      setState(() {
        _validateDropDown = false;
      });
    }
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _validateDropDown = false;
      });
    });
  }

  Future<void> deleteByHardWareNumber() async {
    final box = Hive.box<GetNumberModel>('$getNumberHiveBox');

    final keyToDelete = box.keys.firstWhere(
        (key) => box.get(key)?.productId.toString() == HardWareNumber.getText,
        orElse: () => null);
    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }

  void AddedSuccess(DataController hardWareNumber, DataController clientName) {
    if(HardWareNumber.getText != "" && ClientName.getText != ""){
      setState(() {
        _added = true;
      });
    }
  }
}
