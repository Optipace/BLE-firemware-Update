import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/Profile/edit_profile.dart';
import 'package:tracker_firmware/modules/deviceInfo/deviceInfoAPI.dart';
import 'package:tracker_firmware/modules/factoryUser/assignClient/qr_code.dart';
import 'package:tracker_firmware/widgets/buttons.dart';
import 'package:tracker_firmware/widgets/textFields.dart';

class deviceInfoMain extends StatefulWidget {
  const deviceInfoMain({super.key});

  @override
  State<deviceInfoMain> createState() => _deviceInfoMainState();
}

class _deviceInfoMainState extends State<deviceInfoMain> {
  bool deviceFound = false;
  Map<String, dynamic> HardwareDetail = {};
  TextEditingController _macIdController = new TextEditingController();
  bool macIdisEmpty = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkBg,
        child: Column(
          children: [
            Container(
              height:
              deviceFound
              ? screenSize.height * 0.06
              :screenSize.height * 0.15,
              // top section
              width: screenSize.width,
              padding:
              const EdgeInsets.fromLTRB(10, 28, 10, 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF56B6C2), // a lighter shade for smooth effect
                    Color(0xFF358A94),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  // Title
                  deviceFound
                  ? SizedBox()
                  : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              size: 30,
                              color: Colors.white,
                            )),
                        SizedBox(
                            width: 5
                        ),
                        Text(
                          "Device Info",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: screenSize.width,
                decoration: BoxDecoration(
                  color: lightBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child:deviceFound
                  ? MacIDDetails()
                  : MacIDCredentials(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MacIDDetails() {
    return Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: darkBg.withOpacity(0.1)),
                    width: screenSize.width * 0.85,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Title
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("EIONIC",style: TextStyle(color: darkBg, fontSize: 21,fontWeight: FontWeight.w800,shadows: [Shadow(color: Colors.black,blurRadius: 0.2 )]),),
                              Text("MAC-Id : ${HardwareDetail['MacId']}",style: TextStyle(color: darkBg, fontSize: 16,fontWeight: FontWeight.w600,),),
                            ],
                          ),
                        ),
                        Divider(color: darkBg,),
                        //Client and Battery
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Client
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                              width: (screenSize.width * 0.85)/2.3,
                              decoration: BoxDecoration(
                                  border: Border.all(color: darkBg),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white54

                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //title
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("Client Details",
                                      style: MainTitleStyle(),
                                    ),
                                  ),
                                  Divider(color: darkBg,),
                                  //Name
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Client Name:", style: TitleStyle(),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(HardwareDetail['ClientName'],style:ContentStyle())),
                                      ],
                                    ),
                                  ),
                                  //Client phno
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical:3.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Contact Number:",style:TitleStyle(),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(HardwareDetail['ClientContactNum'],style: ContentStyle())),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Battery
                            Container(
                              margin: EdgeInsets.symmetric(vertical:3.5),
                              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                              width: (screenSize.width * 0.85)/2.3,
                              decoration: BoxDecoration(
                                  border: Border.all(color: darkBg),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white54

                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //title
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("Battery Details",style:MainTitleStyle(),),
                                  ),
                                  Divider(color: darkBg,),
                                  //Battery serial number
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical:3.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Battery Sl.No:",style:TitleStyle(),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(HardwareDetail['BatSerialNum'],style: ContentStyle())),
                                      ],
                                    ),
                                  ),
                                  //device type
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Device Type:",style:TitleStyle(),),
                                        FittedBox(fit: BoxFit.scaleDown,child: Text(HardwareDetail['BatteryType'],style: ContentStyle())),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //Batch
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: darkBg),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white54

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Title
                              Center(child: Text("Batch Details",style:MainTitleStyle(),),),
                              Divider(color: darkBg,),
                              //Main Content
                              Container(
                                margin: EdgeInsets.symmetric(vertical:3.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Batch name
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical:3.5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Batch Name",style: TitleStyle(),),
                                          FittedBox(fit: BoxFit.scaleDown, child: Text(HardwareDetail['BatchName'],style: ContentStyle(),),)
                                        ],
                                      ),
                                    ),
                                    //FW name
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical:3.5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Firmware Name",style: TitleStyle(),),
                                          FittedBox(fit: BoxFit.scaleDown, child: Text(HardwareDetail['FWName'],style:ContentStyle(),),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                        ),
                        //Configure
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: darkBg),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white54

                          ),
                          child: Column(
                            children: [
                              //Title
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Center(
                                  child:
                                     Column(
                                  children: [
                                    Text("Configure Details",style: MainTitleStyle(),),
                                    FittedBox(fit : BoxFit.scaleDown,child: Text("${HardwareDetail['CName']}",
                                    style:  TextStyle(
                                        fontSize: 12,
                                        color: darkBg,
                                        fontWeight: FontWeight.w500
                                        ),)),
                                  ],
                                ),
                                ),
                              ),
                              Divider(color: darkBg,),
                              //main content
                              FittedBox(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      //Volt and thershold
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //U.Thershold
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("U. Threshold", style: TitleStyle(),),
                                              SizedBox(height: 2.5),
                                              Text("${HardwareDetail['UThershold']}V",style: ContentStyle(),),
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          //U.volt
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("U.Volt", style:TitleStyle(),),
                                              SizedBox(height: 2.5),
                                              Text("${HardwareDetail['UVoltage']}V", style: ContentStyle(),),
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          //L.Thershold
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("L.Threshold", style: TitleStyle(),),
                                              SizedBox(height: 2.5),
                                              Text("${HardwareDetail['LThershold']}V", style: ContentStyle(),),
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          //L.Volt
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Center(child: Text("L. Volt", style:TitleStyle(),)),
                                              SizedBox(height: 2.5),
                                              Text("${HardwareDetail['LVoltage']}V", style: ContentStyle(),),

                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      //Temp and Nvolt
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //N.volt
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("N. Volt", style: TitleStyle(),),
                                              SizedBox(height: 2.5),
                                              Text("${HardwareDetail['NVoltage']}V", style: ContentStyle(),),

                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          //u.Temp
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("U.Temp", style: TitleStyle(),),
                                              SizedBox(height: 2.5),
                                              Text(HardwareDetail['UTemp'], style:ContentStyle(),),
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          //L.Temp
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("L.Temp", style: TitleStyle(),),
                                              SizedBox(height: 2.5),
                                              Text(HardwareDetail['LTemp'], style: ContentStyle(),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Back btn
                        Padding(
                          padding: const EdgeInsets.only(top: 5,),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkBg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20),

                            ),
                            onPressed: () async {
                              setState(() {
                                _macIdController.clear();
                                deviceFound = false;
                              });
                            },
                            child: Text(
                              "Back",
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget MacIDCredentials() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Center(
              child: Text(
                "Enter Device Credentials",
                style: TextStyle(
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: darkBg,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          blurRadius: 0.5,
                          offset: Offset(0.5, 0.5))
                    ]),
              ),
            ),
          ),

          Divider(color: darkBg,),
          Divider(color: darkBg,),


          Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: darkBg),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white70),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 10),
              width: screenSize.width * 0.85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Scan or Enter Mac-Id",style: TextStyle(color: darkBg, fontSize: 21,fontWeight: FontWeight.w800,shadows: [Shadow(color: Colors.black,blurRadius: 0.2 )]),),
                  ),
                  Divider(color: darkBg,),
                  //QR-code
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QRScannerScreen(
                                  title: "Scan QR-Code"),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _macIdController.text = result;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          30, 15, 30, 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: darkBg),
                        color: Colors.white54,
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(CupertinoIcons.qrcode,
                                  size: 35,
                                  color: darkBg,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 0.4)
                                  ]),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Scan QR-Code",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: darkBg,
                                    fontWeight:
                                    FontWeight.w500,
                                    shadows: [
                                      Shadow(
                                          color:
                                          Colors.black,
                                          blurRadius: 0.4)
                                    ]),
                              ),
                            ],
                          ),
                          Icon(
                            CupertinoIcons.chevron_right_2,
                            color: darkBg,
                            shadows: [
                              Shadow(
                                  color: Colors.black,
                                  blurRadius: 0.4)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  //OR
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 30),
                            height: 1,
                            color: darkBg,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "OR",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: darkBg
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 30),
                            height: 1,
                            color: darkBg,
                          )
                      ),
                    ],
                  ),
                  //TextField
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 60,
                      width: screenSize.width * 0.85,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: TextField(
                          style: TextStyle(
                              fontSize: 18,
                              color: darkBg,
                              fontWeight: FontWeight.w500,
                              fontFamily: baseFont,
                              letterSpacing: 0.2),
                          controller: _macIdController,
                          cursorColor: darkBg,
                          textAlign: TextAlign.left,

                          decoration: InputDecoration(
                            contentPadding:EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: darkBg, width: 1.3),
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1, color:!macIdisEmpty ? darkBg : Colors.black)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color:!macIdisEmpty ? Colors.black : Color(0xFFFF8A80))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: !macIdisEmpty ? Colors.black : Color(0xFFFF8A80))),
                            filled: true,
                            fillColor:Colors.white54,
                            hintText:"Enter the MacID",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF9AC4C9),
                                fontFamily: baseFont,
                                fontWeight: FontWeight.w400),
                            errorText: !macIdisEmpty ? null :"Please Enter MAC-Id" ,
                            errorStyle: TextStyle(color: errorText),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //Search btn
                  Padding(
                    padding: const EdgeInsets.only(top: 5,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 14),

                          ),
                          onPressed: () async {
                            HardwareDetail = await getHardwareDetails(context, macId: _macIdController.text.trim());
                            setState(() {
                              if(_macIdController.text.trim().isEmpty) {
                                macIdisEmpty = true;
                              }else{
                                macIdisEmpty = false;
                              }
                             if(macIdisEmpty == false){
                               deviceFound = true;
                             }

                            });
                          },
                          child: Text(
                            "Search",
                            textAlign: TextAlign.center,
                            style:
                            TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle MainTitleStyle() {
    return TextStyle(
        fontSize: 16,
        color: darkBg,
        fontWeight: FontWeight.w700,
        shadows: [Shadow(color: Colors.black,blurRadius: 0.02)]
    );
  }

  TextStyle ContentStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: darkBg,
    );
  }

  TextStyle TitleStyle() {
    return TextStyle(
      fontSize: 10,
      color: darkBg,
      fontWeight: FontWeight.w400,
    );
  }

}
