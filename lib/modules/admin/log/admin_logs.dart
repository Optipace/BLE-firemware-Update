import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';

class AdminLogs extends StatefulWidget{
  @override
  State<AdminLogs> createState()  => AdminLogsState();


}

class AdminLogsState extends State<AdminLogs>{
  int selectedbutton =1;

  @override
  Widget build(BuildContext context) {
    print("Inside Logs Page");
    print("Inside Logs Page");
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text("Logs", style: TextStyle(fontFamily: baseFont,fontWeight: FontWeight.w800, fontSize: 24,color: lightBg),),
        toolbarHeight: 80,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: lightBg,
      body:Column(
        children: [
          SizedBox(height: 5,),
          Card(
            // elevation: ,
            // shadowColor: Colors.black,
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
            child: Container(
              height: 52,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedbutton =1;
                      });
                    },
                    child: Container(
                      width:  MediaQuery.of(context).size.width/2,
                      height: 52,
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
                      width: MediaQuery.of(context).size.width/2.1,
                      height: 52,
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
                        child: Center(child: Text("Field User",style: TextStyle(
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
                  )
                ],
              ),
            )
          )
        ],
      )
    );

  }
}