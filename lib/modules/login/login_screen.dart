import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/modules/login/api/api.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _showInfo = false;
  
  @override
  void initState(){
    super.initState();
    setDeviceId();
    // isSession = await checkSession();
  }
  
  @override
  void dispose(){
    super.dispose();
  }

  String? errorPhnMsg;
  String? errorPassMsg;
  Color focused_clr = Color(0xCCFFFFFF);
  Color error_clr = Color(0xFFE74C3C);
  Color base_clr = 	Color(0xCCFFFFFF);
  bool showPass = false;

  bool checkPhnNum(String phone){
    return phone.length == 10;
  }

  bool checkPass(String password){
    return password.length >=4;
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBg, lightBg], // Your gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child:Container(
            height: 450,
            width: 380,
            decoration: BoxDecoration(
                color:Color.fromRGBO(208, 209, 206, 0.2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  spreadRadius: 2, // How wide the shadow spreads
                  blurRadius: 2,  // How soft the shadow is
                )],
            ),
            child: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(bottom: 12),child: IconButton(
                              icon: Icon(
                                _showInfo ? Icons.info : Icons.info_outline,
                                color: lightBg,
                                size: 30,

                              ),
                              onPressed: () {
                                setState(() {
                                  _showInfo = !_showInfo;
                                });
                              },
                            ),)
                          ],
                        ),

                        AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _showInfo
                              ? Container(
                            width: 250,
                            height: 40,
                            margin: EdgeInsets.only(top: 10,bottom: 10),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(208, 209, 206, 0.2),
                              border: Border.all(color: lightBg),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child:Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'UUID : ',
                                  style: TextStyle(color:Color.fromRGBO(248, 250, 254, 1.0), fontSize: 18,fontWeight: FontWeight.w700,letterSpacing: 1.1),
                                ),
                              ),
                            )
                          )
                              : SizedBox.shrink(),
                        )
                      ],
                    ),
                ),
                SizedBox(height: 50,),
                Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //  login Text
                        Container(
                          child: Text("LOGIN",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: 	Color(0xCCFFFFFF)
                            ),),
                        ),
                        SizedBox(height: 20,),

                        //  Phone number
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: 300,
                                child: TextFormField(
                                  controller: phoneNumber,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],

                                  decoration: InputDecoration(
                                    hintText: 'Enter Your Phone number',
                                    hintStyle: TextStyle(color: Color(0xCCFFFFFF),fontWeight: FontWeight.w700,wordSpacing: 1.5,letterSpacing: 1.1),
                                    hintMaxLines: 1,
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(wordSpacing: 1.5,letterSpacing: 1.1,color: base_clr,fontWeight: FontWeight.w400),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: base_clr)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: base_clr,width: 1.5)),
                                    prefixIcon: Icon(CupertinoIcons.phone,color:  base_clr),
                                    floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                    floatingLabelStyle: TextStyle(color: focused_clr,fontWeight: FontWeight.w700,wordSpacing: 1.5,letterSpacing: 1.1),
                                  ),
                                  style: TextStyle(color: Color(0xCCFFFFFF)),
                                ),
                              ),
                              errorPhnMsg != null
                                  ? Padding(padding: EdgeInsets.only(top: 2,right: 100), child: Text(errorPhnMsg!,style: TextStyle(color: error_clr),),
                              )
                                  : SizedBox(height: 20,),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),

                        //  Password
                        Column(
                          children: [
                            Container(
                              width: 300,
                              child: TextFormField(
                                controller: _password,
                                obscureText: !showPass,
                                style: TextStyle(color: Color(0xCCFFFFFF)),
                                decoration: InputDecoration(
                                  hintText: 'Enter Your Password',
                                  hintStyle: TextStyle(color: focused_clr,fontWeight: FontWeight.w700,letterSpacing: 1.1,wordSpacing: 1.5),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(wordSpacing: 1.5,letterSpacing: 1.1,color: base_clr,fontWeight: FontWeight.w400),

                                  // border: OutlineInputBorder(borderSide: BorderSide(width: 1,),),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: base_clr)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: focused_clr,width: 1.5)),
                                  prefixIcon: Icon(CupertinoIcons.lock,color: base_clr,),
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        showPass = !showPass;
                                      });
                                    },
                                    icon:Icon(
                                        showPass?
                                        Icons.visibility_outlined
                                            :
                                        Icons.visibility_off_outlined
                                    ),color: base_clr,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  floatingLabelAlignment: FloatingLabelAlignment.start,
                                  floatingLabelStyle: TextStyle(color: focused_clr,wordSpacing: 1.5,letterSpacing: 1.1,fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            errorPassMsg != null
                                ? Padding(padding: EdgeInsets.only(top: 2,right: 40), child: Text(errorPassMsg!,style: TextStyle(color: Color.fromRGBO(250, 0, 0, 1)),),)
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(height: 20,),

                        //  Login Button
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryButton,
                                  minimumSize: Size(180, 40),
                                  elevation: 0,
                                  shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    // side: BorderSide(color: Colors.black,width: 1,strokeAlign: 2.5)
                                  )
                              ),
                              onPressed: () async {
                                // await DataBase.database;
                                // final exists = await DataBase.isDatabaseCreated();
                                // if(exists){
                                //   print("Database is created!!");
                                // }else{
                                //   print("Some issues");
                                // }
                                // print("Device Information : \n"
                                //     "uuid :  ${sharedPreferences.getString("UUID")}"
                                //     "\n version : ${sharedPreferences.getString("osVersion")}"
                                //     "\n model : ${sharedPreferences.getString("deviceModel")}");
                                setState(() {
                                  if(checkPhnNum(phoneNumber.text) && checkPass(_password.text)){
                                    errorPassMsg = null;
                                    errorPhnMsg = null;
                                    // await loginDetails(phoneNumber, _password);
                                  }else {
                                    if (!checkPhnNum(phoneNumber.text)) {
                                      errorPhnMsg = 'Please Enter the 10 Digit number';
                                    } else {
                                      errorPhnMsg = null;
                                    }
                                    if (!checkPass(_password.text)) {
                                      errorPassMsg = 'Password Must be greater than 4 Characters';
                                    } else {
                                      errorPassMsg = null;
                                    }
                                  };
                                  Future.delayed(Duration(seconds: 3), () {
                                    setState(() {
                                      errorPhnMsg = null;
                                      errorPassMsg = null;
                                    });
                                  });
                                });
                                print("DEMO DEMO ${checkPhnNum(phoneNumber.toString()) && checkPass(_password.toString())}");
                                if((checkPhnNum(phoneNumber.text) && checkPass(_password.text) )|| true) {
                                  print("Inside if cond");
                                  print("SIZE : $size");
                                  // await getEmpDetails(context, phoneNumber.text, _password.text);
                                  await logIn(context, phoneNumber.text, _password.text);
                                }else{
                                  print("inside Else cond");
                                }
                              },
                              child: Text("LOGIN",style: TextStyle(color: lightBg, fontSize: 16,fontWeight: FontWeight.w700,letterSpacing: 1.1),),
                            ),

                          ],
                        ),
                      ],
                    )
                ),


              ],
            )
          ),
        )
      ),
    );

  }
}