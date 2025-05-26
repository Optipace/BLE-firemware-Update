import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/login/api/api.dart';

class AdminLogs extends StatefulWidget{
  @override
  State<AdminLogs> createState()  => AdminLogsState();


}

class AdminLogsState extends State<AdminLogs>{
  int selectedbutton =1;
  var empLogs=getAllEmployeeLogs();

  @override
  Widget build(BuildContext context) {
    print("Inside Logs Page");
    print("Inside Logs Page");
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text("Logs", style: TextStyle(fontFamily: baseFont,fontWeight: FontWeight.w800, fontSize: 24,color: lightBg),),
        toolbarHeight: size.height/11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: lightBg,
      body:Column(
        children: [
          SizedBox(height: 5,),
          Card(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: darkBg,
                width: 0.5,
              ),
              borderRadius:  BorderRadius.all(
                 Radius.circular(28)
              )),
            color: lightBg,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedbutton =1;
                    });
                  },
                  child: Container(
                    width:  size.width * 0.48,
                    height: 60,
                    decoration: BoxDecoration(
                        color:  selectedbutton == 1 ? darkBg :lightBg,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            bottomLeft: Radius.circular(28)
                        ),
                        border: Border.all(
                            width: 0.5,
                            color: darkBg
                        ),
                        boxShadow: [BoxShadow(
                            blurRadius: 0.5,
                            color: darkBg
                        )]
                    ),
                    child: Center(
                        heightFactor: 2,
                        child: Center(child: Text("Factory User",
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w600,
                            color: selectedbutton == 1 ? lightBg : darkBg,
                            shadows: [
                              Shadow(offset: Offset(0.3, 0.3), color:  selectedbutton == 1 ? lightBg : darkBg),
                              Shadow(offset: Offset(-0.3, 0.3), color:  selectedbutton == 1 ? lightBg : darkBg),
                            ],
                          ),),)
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      selectedbutton =2;
                    });
                  },
                  child: Container(
                    width:  size.width * 0.49,
                    height: 60,
                    decoration: BoxDecoration(
                        color: selectedbutton == 2  ? darkBg : lightBg,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(28),
                            bottomRight: Radius.circular(28)
                        ),

                        boxShadow: [BoxShadow(
                            blurRadius: 0.5,
                            color: darkBg
                        )]

                    ),
                    child: Center(
                      heightFactor: 2,
                      child: Center(
                        child:
                        Text(
                          "Field User",style:
                        TextStyle(
                          fontSize: 22,
                          fontFamily: baseFont,
                          fontWeight: FontWeight.w600,
                          color: selectedbutton == 1 ? darkBg : lightBg,
                          shadows: [
                            Shadow(offset: Offset(0.3, 0.3), color:  selectedbutton == 1 ? darkBg : lightBg,),
                            Shadow(offset: Offset(-0.3, 0.3), color:  selectedbutton == 1 ? darkBg : lightBg,),
                          ],
                        ),),),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(selectedbutton == 1) ...? factoryUserLog(),
                    if(selectedbutton == 2) ...? fieldUserLog(),
                  ],
                ),
              )
          ),
        ],
      )
    );
  }


  List<Widget> factoryUserLog(){
    printFunc("DEMO EMP LOGS : ${empLogs[0]['designation_id']}");
    List<Widget> FactoryUsersList = [];

    for(int index = 0;index <empLogs.length;index++){
      if(empLogs[index]['designation_id'] == 2){
        ValueNotifier moreInfo = ValueNotifier<bool>(false);
        FactoryUsersList.add(ValueListenableBuilder(
            valueListenable: moreInfo,
            builder: (ctx, value, child){
              return Container(
                child: Column(
                  children: [
                    // Active users
                    Container(
                      child: empLogs[index]['status'] == "active"
                      ?Card(
                        elevation: 5,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Active")
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("NAME"),
                                  Text("EmpID"),
                                  Text("DeviceID"),
                                  Text("Phone number")
                                ],
                              )

                            ],
                          ),
                        ),
                      )
                      :SizedBox()
                    ),
                    // InActive Users
                    Container(
                      child: empLogs[index]['status'] == "inactive"
                      ? Card(
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("InActive")
                                ],
                              ),
                              Column(
                                children: [
                                  Text("NAME"),
                                  Text("EmpID"),
                                  Text("DeviceID"),
                                  Text("Phone number")
                                ],
                              )

                            ],
                          ),
                        ),
                      )
                      : SizedBox()
                    )
                  ],
                ),
              );
            }
        ));
      }
    }

    setState(() {});
    return FactoryUsersList;

  }

  List<Widget> fieldUserLog(){
    List<Widget> FieldUsersList = [];

    setState(() {});
    return FieldUsersList;

  }
}