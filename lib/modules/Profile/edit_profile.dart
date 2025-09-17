import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/api/api.dart';
import 'package:tracker_firmware/services/apiCall/Admin/userManagement.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //Controllers for edit User
  TextEditingController _Uid = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _empRegisteredId = TextEditingController();
  TextEditingController _designation = TextEditingController();
  TextEditingController _deviceId = TextEditingController();

  // Controllers for update password
  final _formKey = GlobalKey<FormState>();

  TextEditingController _Phno = TextEditingController();
  TextEditingController _Password = TextEditingController();
  TextEditingController _Repassword = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    _Uid.text = UserData().userId;
    _name.text = UserData().name;
    _phone.text = UserData().phone;
    _email.text = UserData().email;
    _empRegisteredId.text = UserData().empRegisteredId;
    _designation.text = UserData().designation;
    _deviceId.text = UserData().UUID;
    _Phno.text = UserData().phone;

    setState(() {});
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _empRegisteredId.dispose();
    _designation.dispose();
    _deviceId.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    // Update UserData and call updateUser API
    final success = await updateUser(
      context,
      id: _Uid.text.trim(),
      // must be tracked somewhere in state
      name: _name.text.trim(),
      empRegisteredId: _empRegisteredId.text.trim(),
      email: _email.text.trim(),
      contact: _phone.text.trim(),
      designationId: _deviceId.text.trim(),
      deviveId: _deviceId.text.trim(),
    );

    if (success) {
      ShowSnackBarMessage(context, 'Profile updated successfully!', true);
    } else {
      printFunc("Inside else cond");
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkBg,
        child: Column(
          children: [
            // Top Gradient Header
            Container(
              height: screenSize.height * 0.15,
              width: screenSize.width,
              padding: const EdgeInsets.fromLTRB(5, 20, 10, 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF56B6C2),
                    Color(0xFF358A94),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_outlined,
                        size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content (Expanded)
            Expanded(
              child: Container(
                width: screenSize.width,
                decoration: BoxDecoration(
                  color: lightBg,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                           color: darkBg.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)
                        ),
                       child: Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text("UPDATE DETAILS",style: TextStyle(color: darkBg, fontSize: 21,fontWeight: FontWeight.w800,shadows: [Shadow(color: Colors.black,blurRadius: 0.2 )]),),
                           ),
                           Divider(color: darkBg,),
                           //Name
                           Container(
                             margin: EdgeInsets.all(10),
                             padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                             decoration: BoxDecoration(
                               color: Color(0xFF358A94).withOpacity(0.1),
                               border: Border.all(color: Color(0xFF358A94)),
                               borderRadius: BorderRadius.circular(10)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("User Name", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color:Colors.black54)),
                                 TextField(
                                   controller: _name,
                                   enabled: true,
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.black87,
                                     fontWeight: FontWeight.w600,
                                   ),
                                   decoration: InputDecoration(
                                     isDense: true, // reduces height
                                     contentPadding: EdgeInsets.symmetric(vertical: 2,),
                                     hintText: UserData().name,
                                     hintStyle: TextStyle(
                                       fontSize: 16,
                                       color: Colors.black87,
                                       fontWeight: FontWeight.w600,
                                     ),
                                     border: InputBorder.none
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           //Phone number
                           Container(
                             margin: EdgeInsets.all(10),
                             padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                             decoration: BoxDecoration(
                                 color: Color(0xFF358A94).withOpacity(0.1),
                                 border: Border.all(color: Color(0xFF358A94)),
                                 borderRadius: BorderRadius.circular(10)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("Phone Number", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color:Colors.black54)),
                                 TextField(
                                   controller: _phone,
                                   enabled: true,
                                   keyboardType:
                                   TextInputType.phone,
                                   maxLength: 10,
                                   buildCounter: (BuildContext context,
                                       {int? currentLength, int? maxLength, bool? isFocused}) {
                                     return null; // hides the counter
                                   },
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.black87,
                                     fontWeight: FontWeight.w600,
                                   ),
                                   decoration: InputDecoration(
                                       isDense: true, // reduces height
                                       contentPadding: EdgeInsets.symmetric(vertical: 2,),
                                       hintText: UserData().phone,
                                       hintStyle: TextStyle(
                                         fontSize: 16,
                                         color: Colors.black87,
                                         fontWeight: FontWeight.w600,
                                       ),
                                       border: InputBorder.none
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           //Email-Id
                           Container(
                             margin: EdgeInsets.all(10),
                             padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                             decoration: BoxDecoration(
                                 color: Color(0xFF358A94).withOpacity(0.1),
                                 border: Border.all(color: Color(0xFF358A94)),
                                 borderRadius: BorderRadius.circular(10)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("Mail-Id", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color:Colors.black54)),
                                 TextField(
                                   controller: _email,
                                   enabled: true,
                                   keyboardType: TextInputType
                                       .emailAddress,
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.black87,
                                     fontWeight: FontWeight.w600,
                                   ),
                                   decoration: InputDecoration(
                                       isDense: true, // reduces height
                                       contentPadding: EdgeInsets.symmetric(vertical: 2,),
                                       hintText: UserData().email,
                                       hintStyle: TextStyle(
                                         fontSize: 16,
                                         color: Colors.black87,
                                         fontWeight: FontWeight.w600,
                                       ),
                                       border: InputBorder.none
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           //EmpReg-Id
                           Container(
                             margin: EdgeInsets.all(10),
                             padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                             decoration: BoxDecoration(
                                 color: Color(0xFFBFCED9),
                                 border: Border.all(color: Color(0xFF9AA7B3)),
                                 borderRadius: BorderRadius.circular(10)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     Text("EmpReg-Id", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color:Colors.black54)),
                                     SizedBox(width: 3),
                                     Icon(
                                       Icons.lock_outline,
                                       size: 11,
                                       color:Colors.black54,
                                     ),
                                   ],
                                 ),
                                 TextField(
                                   controller: _empRegisteredId,
                                   enabled: false,
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.black.withOpacity(0.8),
                                     fontWeight: FontWeight.w600,
                                   ),
                                   decoration: InputDecoration(
                                       isDense: true, // reduces height
                                       contentPadding: EdgeInsets.symmetric(vertical: 2,),
                                       hintText: UserData().empRegisteredId,
                                       hintStyle: TextStyle(
                                         fontSize: 16,
                                         color: Colors.black87,
                                         fontWeight: FontWeight.w600,
                                       ),
                                       border: InputBorder.none
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           //Designation
                           Container(
                             margin: EdgeInsets.all(10),
                             padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                             decoration: BoxDecoration(
                                 color: Color(0xFFBFCED9),
                                 border: Border.all(color: Color(0xFF9AA7B3)),
                                 borderRadius: BorderRadius.circular(10)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     Text("Designation", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color:Colors.black54)),
                                     SizedBox(width: 3),
                                     Icon(
                                       Icons.lock_outline,
                                       size: 11,
                                       color:Colors.black54,
                                     ),
                                   ],
                                 ),
                                 TextField(
                                   controller: _designation,
                                   enabled: false,
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.black.withOpacity(0.8),
                                     fontWeight: FontWeight.w600,
                                   ),
                                   decoration: InputDecoration(
                                       isDense: true, // reduces height
                                       contentPadding: EdgeInsets.symmetric(vertical: 2,),
                                       hintText: UserData().designation,
                                       hintStyle: TextStyle(
                                         fontSize: 16,
                                         color: Colors.black87,
                                         fontWeight: FontWeight.w600,
                                       ),
                                       border: InputBorder.none
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           //Device-Id
                           Container(
                             margin: EdgeInsets.all(10),
                             padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                             decoration: BoxDecoration(
                                 color: Color(0xFFBFCED9),
                                 border: Border.all(color: Color(0xFF9AA7B3)),
                                 borderRadius: BorderRadius.circular(10)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     Text("Device-Id", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color:Colors.black54)),
                                     SizedBox(width: 3),
                                     Icon(
                                       Icons.lock_outline,
                                       size: 11,
                                       color:Colors.black54,
                                     ),
                                   ],
                                 ),
                                 TextField(
                                   controller: _deviceId,
                                   enabled: false,
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.black.withOpacity(0.8),
                                     fontWeight: FontWeight.w600,
                                   ),
                                   decoration: InputDecoration(
                                       isDense: true, // reduces height
                                       contentPadding: EdgeInsets.symmetric(vertical: 2,),
                                       hintText: UserData().UUID,
                                       hintStyle: TextStyle(
                                         fontSize: 16,
                                         color: Colors.black87,
                                         fontWeight: FontWeight.w600,
                                       ),
                                       border: InputBorder.none
                                   ),
                                 ),
                               ],
                             ),
                           ),

                           Divider(color: darkBg,),
                           Padding(
                             padding: const EdgeInsets.only(top: 5),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                   onPressed: _submitProfile,
                                   child: Text(
                                     "Save\nChanges",
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         color: Colors.white, fontSize: 15),
                                   ),
                                 ),
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
                                     showDialog(
                                         barrierDismissible: false,
                                         context: context,
                                         builder: (context) {
                                           return Dialog(
                                             shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                 BorderRadius.circular(15),
                                                 side: BorderSide(
                                                     width: 0.5, color: darkBg)),
                                             child: Container(
                                               width: screenSize.width * 0.8,
                                               height: screenSize.height / 1.5,
                                               decoration: BoxDecoration(
                                                 borderRadius:
                                                 BorderRadius.circular(15),
                                               ),
                                               child: SingleChildScrollView(
                                                 child: Column(
                                                   mainAxisAlignment:
                                                   MainAxisAlignment.start,
                                                   crossAxisAlignment:
                                                   CrossAxisAlignment.center,
                                                   children: [
                                                     //Title
                                                     Padding(
                                                       padding: const EdgeInsets
                                                           .symmetric(vertical: 10),
                                                       child: Column(
                                                         children: [
                                                           Padding(
                                                             padding:
                                                             const EdgeInsets
                                                                 .only(top: 20),
                                                             child: Text(
                                                               "Update Password",
                                                               style: TextStyle(
                                                                   fontFamily:
                                                                   baseFont,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w800,
                                                                   fontSize: 28,
                                                                   color: darkBg),
                                                             ),
                                                           ),
                                                           Divider(
                                                             color: darkBg,
                                                             thickness: 1.5,
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                     //main content
                                                     Padding(
                                                       padding:
                                                       const EdgeInsets.fromLTRB(
                                                           20, 10, 20, 10),
                                                       child: Form(
                                                         key: _formKey,
                                                         autovalidateMode:
                                                         AutovalidateMode
                                                             .onUserInteraction,
                                                         child: Column(
                                                           mainAxisSize:
                                                           MainAxisSize.min,
                                                           crossAxisAlignment:
                                                           CrossAxisAlignment
                                                               .start,
                                                           children: [
                                                             // Phone Number
                                                             Text(
                                                               "Phone number",
                                                               style: TextStyle(
                                                                   fontSize: 16,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w400,
                                                                   color: darkBg,
                                                                   fontFamily:
                                                                   baseFont,
                                                                   shadows: [
                                                                     Shadow(
                                                                       color: Colors
                                                                           .black,
                                                                       blurRadius:
                                                                       0.2,
                                                                       // offset: Offset(0.5, 0.5)
                                                                     )
                                                                   ]),
                                                             ),
                                                             SizedBox(
                                                               height: 5,
                                                             ),
                                                             TextFormField(
                                                               controller: _Phno,
                                                               keyboardType:
                                                               TextInputType
                                                                   .phone,
                                                               style: TextStyle(
                                                                   fontSize: 18,
                                                                   color: darkBg,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w500,
                                                                   fontFamily:
                                                                   baseFont,
                                                                   letterSpacing:
                                                                   0.2),
                                                               decoration:
                                                               InputDecoration(
                                                                 hintText:
                                                                 "Re-enter Password",
                                                                 hintStyle: TextStyle(
                                                                     fontSize: 16,
                                                                     color: Color(
                                                                         0xFF9AC4C9),
                                                                     fontFamily:
                                                                     baseFont,
                                                                     fontWeight:
                                                                     FontWeight
                                                                         .w400),
                                                                 contentPadding:
                                                                 EdgeInsets
                                                                     .symmetric(
                                                                     vertical:
                                                                     10,
                                                                     horizontal:
                                                                     20),
                                                                 enabledBorder: OutlineInputBorder(
                                                                     borderSide:
                                                                     BorderSide(
                                                                         color:
                                                                         darkBg,
                                                                         width:
                                                                         0.5),
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8))),
                                                                 disabledBorder: OutlineInputBorder(
                                                                     borderSide: BorderSide(
                                                                         color: Colors
                                                                             .black,
                                                                         width: 1),
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8))),
                                                                 focusColor:
                                                                 Colors.black,
                                                                 focusedBorder: OutlineInputBorder(
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8)),
                                                                     borderSide:
                                                                     BorderSide(
                                                                         width:
                                                                         1,
                                                                         color:
                                                                         darkBg)),
                                                                 focusedErrorBorder: OutlineInputBorder(
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8)),
                                                                     borderSide: BorderSide(
                                                                         width: 1,
                                                                         color: Colors
                                                                             .black)),
                                                                 filled: true,
                                                                 fillColor: lightBg,
                                                               ),
                                                               enabled: false,
                                                               validator: (value) {
                                                                 if (value == null ||
                                                                     value
                                                                         .trim()
                                                                         .isEmpty) {
                                                                   return "Phone number is required";
                                                                 }
                                                                 return null;
                                                               },
                                                             ),
                                                             SizedBox(
                                                               height: 10,
                                                             ),

                                                             // Password
                                                             Text(
                                                               "Password",
                                                               style: TextStyle(
                                                                   fontSize: 16,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w400,
                                                                   color: darkBg,
                                                                   fontFamily:
                                                                   baseFont,
                                                                   shadows: [
                                                                     Shadow(
                                                                       color: Colors
                                                                           .black,
                                                                       blurRadius:
                                                                       0.2,
                                                                       // offset: Offset(0.5, 0.5)
                                                                     )
                                                                   ]),
                                                             ),
                                                             SizedBox(
                                                               height: 5,
                                                             ),
                                                             TextFormField(
                                                               controller: _Password,
                                                               style: TextStyle(
                                                                   fontSize: 18,
                                                                   color: darkBg,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w500,
                                                                   fontFamily:
                                                                   baseFont,
                                                                   letterSpacing:
                                                                   0.2),
                                                               decoration:
                                                               InputDecoration(
                                                                 hintText:
                                                                 "Enter the Password",
                                                                 hintStyle: TextStyle(
                                                                     fontSize: 16,
                                                                     color: Color(
                                                                         0xFF9AC4C9),
                                                                     fontFamily:
                                                                     baseFont,
                                                                     fontWeight:
                                                                     FontWeight
                                                                         .w400),
                                                                 contentPadding:
                                                                 EdgeInsets
                                                                     .symmetric(
                                                                     vertical:
                                                                     10,
                                                                     horizontal:
                                                                     20),
                                                                 enabledBorder: OutlineInputBorder(
                                                                     borderSide:
                                                                     BorderSide(
                                                                         color:
                                                                         darkBg,
                                                                         width:
                                                                         0.5),
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8))),
                                                                 disabledBorder: OutlineInputBorder(
                                                                     borderSide: BorderSide(
                                                                         color: Colors
                                                                             .black,
                                                                         width: 1),
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8))),
                                                                 focusColor:
                                                                 Colors.black,
                                                                 focusedBorder: OutlineInputBorder(
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8)),
                                                                     borderSide:
                                                                     BorderSide(
                                                                         width:
                                                                         1,
                                                                         color:
                                                                         darkBg)),
                                                                 focusedErrorBorder: OutlineInputBorder(
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8)),
                                                                     borderSide: BorderSide(
                                                                         width: 1,
                                                                         color: Colors
                                                                             .black)),
                                                                 errorBorder: OutlineInputBorder(
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8)),
                                                                     borderSide: BorderSide(
                                                                         width: 1,
                                                                         color: Color(
                                                                             0xFFFF8A80))),
                                                               ),
                                                               validator: (value) {
                                                                 if (value == null ||
                                                                     value
                                                                         .trim()
                                                                         .isEmpty) {
                                                                   return "Password is required";
                                                                 }
                                                                 //password length
                                                                 /*if (value.length < 6) {
                                            return "Password must be at least 6 characters";
                                          } */

                                                                 return null;
                                                               },
                                                             ),
                                                             SizedBox(
                                                               height: 10,
                                                             ),

                                                             // Re-Password
                                                             Text(
                                                               "Re-Entry Password",
                                                               style: TextStyle(
                                                                   fontSize: 16,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w400,
                                                                   color: darkBg,
                                                                   fontFamily:
                                                                   baseFont,
                                                                   shadows: [
                                                                     Shadow(
                                                                       color: Colors
                                                                           .black,
                                                                       blurRadius:
                                                                       0.2,
                                                                       // offset: Offset(0.5, 0.5)
                                                                     )
                                                                   ]),
                                                             ),
                                                             SizedBox(
                                                               height: 5,
                                                             ),
                                                             TextFormField(
                                                               controller:
                                                               _Repassword,
                                                               style: TextStyle(
                                                                   fontSize: 18,
                                                                   color: darkBg,
                                                                   fontWeight:
                                                                   FontWeight
                                                                       .w500,
                                                                   fontFamily:
                                                                   baseFont,
                                                                   letterSpacing:
                                                                   0.2),
                                                               decoration:
                                                               InputDecoration(
                                                                 hintText:
                                                                 "Re-Enter the Password",
                                                                 hintStyle: TextStyle(
                                                                     fontSize: 16,
                                                                     color: Color(
                                                                         0xFF9AC4C9),
                                                                     fontFamily:
                                                                     baseFont,
                                                                     fontWeight:
                                                                     FontWeight
                                                                         .w400),
                                                                 contentPadding:
                                                                 EdgeInsets
                                                                     .symmetric(
                                                                     vertical:
                                                                     10,
                                                                     horizontal:
                                                                     20),
                                                                 enabledBorder: OutlineInputBorder(
                                                                     borderSide:
                                                                     BorderSide(
                                                                         color:
                                                                         darkBg,
                                                                         width:
                                                                         0.5),
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8))),
                                                                 disabledBorder: OutlineInputBorder(
                                                                     borderSide: BorderSide(
                                                                         color: Colors
                                                                             .black,
                                                                         width: 1),
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8))),
                                                                 focusColor:
                                                                 Colors.black,
                                                                 focusedBorder: OutlineInputBorder(
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8)),
                                                                     borderSide:
                                                                     BorderSide(
                                                                         width:
                                                                         1,
                                                                         color:
                                                                         darkBg)),
                                                                 focusedErrorBorder: OutlineInputBorder(
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8)),
                                                                     borderSide: BorderSide(
                                                                         width: 1,
                                                                         color: Colors
                                                                             .black)),
                                                                 errorBorder: OutlineInputBorder(
                                                                     borderRadius: BorderRadius
                                                                         .all(Radius
                                                                         .circular(
                                                                         8)),
                                                                     borderSide: BorderSide(
                                                                         width: 1,
                                                                         color: Color(
                                                                             0xFFFF8A80))),
                                                               ),
                                                               validator: (value) {
                                                                 if (value == null ||
                                                                     value
                                                                         .trim()
                                                                         .isEmpty) {
                                                                   return "Please re-enter password";
                                                                 }
                                                                 if (value !=
                                                                     _Password
                                                                         .text) {
                                                                   return "Passwords do not match";
                                                                 }
                                                                 return null;
                                                               },
                                                             ),
                                                           ],
                                                         ),
                                                       ),
                                                     ),
                                                     //Btns
                                                     SizedBox(
                                                       height: 10,
                                                     ),
                                                     ElevatedButton(
                                                         style: ButtonStyle(
                                                           backgroundColor:
                                                           MaterialStateProperty
                                                               .all(darkBg),
                                                           minimumSize:
                                                           MaterialStateProperty
                                                               .all(Size(100,
                                                               40)), // width: 80, height: 40
                                                         ),
                                                         onPressed: () async {
                                                           if (_formKey.currentState!
                                                               .validate()) {
                                                             //call Update_password API
                                                             if (await updatePassword(
                                                                 context,
                                                                 phno: _Phno.text
                                                                     .trim()
                                                                     .toString(),
                                                                 pwd: _Password.text
                                                                     .trim()
                                                                     .toString())) {
                                                               Navigator.pop(
                                                                   context);
                                                               _Password.clear();
                                                               _Repassword.clear();
                                                             }
                                                           }
                                                         },
                                                         child: Text(
                                                           "Update",
                                                           style: TextStyle(
                                                               color: Colors.white,
                                                               fontFamily: baseFont,
                                                               fontSize: 18,
                                                               fontWeight:
                                                               FontWeight.w500,
                                                               shadows: [
                                                                 Shadow(
                                                                   color:
                                                                   Colors.white,
                                                                   blurRadius: 0.2,
                                                                 )
                                                               ]),
                                                         )),
                                                   ],
                                                 ),
                                               ),
                                             ),
                                           );
                                         });
                                   },
                                   child: Text(
                                     "Update\nPassword",
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         color: Colors.white, fontSize: 15),
                                   ),
                                 ),
                               ],
                             ),
                           )
                         ],
                       ),
                      ),
                      //Fields
                      /*Expanded(
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: MaterialStateProperty.all(darkBg),
                            // scrollbar thumb color
                            trackColor: MaterialStateProperty.all(Colors.black),
                            // scrollbar track color
                            trackBorderColor:
                            MaterialStateProperty.all(Colors.transparent),
                            thickness: MaterialStateProperty.all(6),
                            // width of scrollbar
                            radius: const Radius.circular(8), // rounded edges
                          ),
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: darkBg.withOpacity(0.2),
                                      border: Border.all(
                                        color: darkBg.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    margin:
                                    const EdgeInsets.fromLTRB(5, 25, 15, 0),
                                    width: screenSize.width * 0.85,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 12),
                                    child: Column(
                                      children: [
                                        //Name
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Name",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                width: screenSize.width * 0.85 -
                                                    36,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: lightBg,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                                child: TextField(
                                                  controller: _name,
                                                  enabled: true,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: UserData().name,
                                                    hintStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black38,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //Phone number
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Phone Number",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                width: screenSize.width * 0.85 -
                                                    36,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: lightBg,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                                child: TextField(
                                                  controller: _phone,
                                                  enabled: true,
                                                  keyboardType:
                                                  TextInputType.phone,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: UserData().phone,
                                                    hintStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black38,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //Email
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Email-Id",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                width: screenSize.width * 0.85 -
                                                    36,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: lightBg,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                                child: TextField(
                                                  controller: _email,
                                                  enabled: true,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: UserData().email,
                                                    hintStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black38,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //EmpRegId
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "EmpReg-Id",
                                                style: TextStyle(
                                                  color: darkBg,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                width: screenSize.width * 0.85 -
                                                    36,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: lightBg,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                                child: TextField(
                                                  controller: _empRegisteredId,
                                                  enabled: true,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: UserData()
                                                        .empRegisteredId,
                                                    hintStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black38,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //designation
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Designation",
                                                    style: TextStyle(
                                                      color: darkBg
                                                          .withOpacity(0.8),
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.lock_outline,
                                                    size: 16,
                                                    color:
                                                    darkBg.withOpacity(0.6),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                width: screenSize.width * 0.85 -
                                                    36,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: lightBg,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                                child: TextField(
                                                  controller: _designation,
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                    UserData().designation,
                                                    hintStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black38,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //deviceId
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Device-Id",
                                                    style: TextStyle(
                                                      color: darkBg
                                                          .withOpacity(0.8),
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.lock_outline,
                                                    size: 16,
                                                    color:
                                                    darkBg.withOpacity(0.6),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                width: screenSize.width * 0.85 -
                                                    36,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: lightBg,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                                child: TextField(
                                                  controller: _deviceId,
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: UserData().UUID,
                                                    hintStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black38,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        //btns
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 30),
                                          width: screenSize.width * 0.5,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF56B6C2),
                                                Color(0xFF358A94)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFF358A94)
                                                    .withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _submitProfile,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                              Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              "Update Profile",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20, right: 25),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
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
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(15),
                                                              side: BorderSide(
                                                                  width: 0.5, color: darkBg)),
                                                          child: Container(
                                                            width: screenSize.width * 0.8,
                                                            height: screenSize.height / 1.5,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(15),
                                                            ),
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.center,
                                                                children: [
                                                                  //Title
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(vertical: 10),
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                          const EdgeInsets
                                                                              .only(top: 20),
                                                                          child: Text(
                                                                            "Update Password",
                                                                            style: TextStyle(
                                                                                fontFamily:
                                                                                baseFont,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w800,
                                                                                fontSize: 28,
                                                                                color: darkBg),
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          color: darkBg,
                                                                          thickness: 1.5,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  //main content
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.fromLTRB(
                                                                        20, 10, 20, 10),
                                                                    child: Form(
                                                                      key: _formKey,
                                                                      autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                      child: Column(
                                                                        mainAxisSize:
                                                                        MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                        children: [
                                                                          // Phone Number
                                                                          Text(
                                                                            "Phone number",
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400,
                                                                                color: darkBg,
                                                                                fontFamily:
                                                                                baseFont,
                                                                                shadows: [
                                                                                  Shadow(
                                                                                    color: Colors
                                                                                        .black,
                                                                                    blurRadius:
                                                                                    0.2,
                                                                                    // offset: Offset(0.5, 0.5)
                                                                                  )
                                                                                ]),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          TextFormField(
                                                                            controller: _Phno,
                                                                            keyboardType:
                                                                            TextInputType
                                                                                .phone,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: darkBg,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w500,
                                                                                fontFamily:
                                                                                baseFont,
                                                                                letterSpacing:
                                                                                0.2),
                                                                            decoration:
                                                                            InputDecoration(
                                                                              hintText:
                                                                              "Re-enter Password",
                                                                              hintStyle: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color(
                                                                                      0xFF9AC4C9),
                                                                                  fontFamily:
                                                                                  baseFont,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w400),
                                                                              contentPadding:
                                                                              EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical:
                                                                                  10,
                                                                                  horizontal:
                                                                                  20),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                  borderSide:
                                                                                  BorderSide(
                                                                                      color:
                                                                                      darkBg,
                                                                                      width:
                                                                                      0.5),
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8))),
                                                                              disabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      width: 1),
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8))),
                                                                              focusColor:
                                                                              Colors.black,
                                                                              focusedBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8)),
                                                                                  borderSide:
                                                                                  BorderSide(
                                                                                      width:
                                                                                      1,
                                                                                      color:
                                                                                      darkBg)),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8)),
                                                                                  borderSide: BorderSide(
                                                                                      width: 1,
                                                                                      color: Colors
                                                                                          .black)),
                                                                              filled: true,
                                                                              fillColor: lightBg,
                                                                            ),
                                                                            enabled: false,
                                                                            validator: (value) {
                                                                              if (value == null ||
                                                                                  value
                                                                                      .trim()
                                                                                      .isEmpty) {
                                                                                return "Phone number is required";
                                                                              }
                                                                              return null;
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),

                                                                          // Password
                                                                          Text(
                                                                            "Password",
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400,
                                                                                color: darkBg,
                                                                                fontFamily:
                                                                                baseFont,
                                                                                shadows: [
                                                                                  Shadow(
                                                                                    color: Colors
                                                                                        .black,
                                                                                    blurRadius:
                                                                                    0.2,
                                                                                    // offset: Offset(0.5, 0.5)
                                                                                  )
                                                                                ]),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          TextFormField(
                                                                            controller: _Password,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: darkBg,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w500,
                                                                                fontFamily:
                                                                                baseFont,
                                                                                letterSpacing:
                                                                                0.2),
                                                                            decoration:
                                                                            InputDecoration(
                                                                              hintText:
                                                                              "Enter the Password",
                                                                              hintStyle: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color(
                                                                                      0xFF9AC4C9),
                                                                                  fontFamily:
                                                                                  baseFont,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w400),
                                                                              contentPadding:
                                                                              EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical:
                                                                                  10,
                                                                                  horizontal:
                                                                                  20),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                  borderSide:
                                                                                  BorderSide(
                                                                                      color:
                                                                                      darkBg,
                                                                                      width:
                                                                                      0.5),
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8))),
                                                                              disabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      width: 1),
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8))),
                                                                              focusColor:
                                                                              Colors.black,
                                                                              focusedBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8)),
                                                                                  borderSide:
                                                                                  BorderSide(
                                                                                      width:
                                                                                      1,
                                                                                      color:
                                                                                      darkBg)),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8)),
                                                                                  borderSide: BorderSide(
                                                                                      width: 1,
                                                                                      color: Colors
                                                                                          .black)),
                                                                              errorBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8)),
                                                                                  borderSide: BorderSide(
                                                                                      width: 1,
                                                                                      color: Color(
                                                                                          0xFFFF8A80))),
                                                                            ),
                                                                            validator: (value) {
                                                                              if (value == null ||
                                                                                  value
                                                                                      .trim()
                                                                                      .isEmpty) {
                                                                                return "Password is required";
                                                                              }
                                                                              return null;
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),

                                                                          // Re-Password
                                                                          Text(
                                                                            "Re-Entry Password",
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400,
                                                                                color: darkBg,
                                                                                fontFamily:
                                                                                baseFont,
                                                                                shadows: [
                                                                                  Shadow(
                                                                                    color: Colors
                                                                                        .black,
                                                                                    blurRadius:
                                                                                    0.2,
                                                                                    // offset: Offset(0.5, 0.5)
                                                                                  )
                                                                                ]),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 5,
                                                                          ),
                                                                          TextFormField(
                                                                            controller:
                                                                            _Repassword,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: darkBg,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w500,
                                                                                fontFamily:
                                                                                baseFont,
                                                                                letterSpacing:
                                                                                0.2),
                                                                            decoration:
                                                                            InputDecoration(
                                                                              hintText:
                                                                              "Re-Enter the Password",
                                                                              hintStyle: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color(
                                                                                      0xFF9AC4C9),
                                                                                  fontFamily:
                                                                                  baseFont,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w400),
                                                                              contentPadding:
                                                                              EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical:
                                                                                  10,
                                                                                  horizontal:
                                                                                  20),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                  borderSide:
                                                                                  BorderSide(
                                                                                      color:
                                                                                      darkBg,
                                                                                      width:
                                                                                      0.5),
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8))),
                                                                              disabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      width: 1),
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8))),
                                                                              focusColor:
                                                                              Colors.black,
                                                                              focusedBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8)),
                                                                                  borderSide:
                                                                                  BorderSide(
                                                                                      width:
                                                                                      1,
                                                                                      color:
                                                                                      darkBg)),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8)),
                                                                                  borderSide: BorderSide(
                                                                                      width: 1,
                                                                                      color: Colors
                                                                                          .black)),
                                                                              errorBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .all(Radius
                                                                                      .circular(
                                                                                      8)),
                                                                                  borderSide: BorderSide(
                                                                                      width: 1,
                                                                                      color: Color(
                                                                                          0xFFFF8A80))),
                                                                            ),
                                                                            validator: (value) {
                                                                              if (value == null ||
                                                                                  value
                                                                                      .trim()
                                                                                      .isEmpty) {
                                                                                return "Please re-enter password";
                                                                              }
                                                                              if (value !=
                                                                                  _Password
                                                                                      .text) {
                                                                                return "Passwords do not match";
                                                                              }
                                                                              return null;
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  //Btns
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ElevatedButton(
                                                                      style: ButtonStyle(
                                                                        backgroundColor:
                                                                        MaterialStateProperty
                                                                            .all(darkBg),
                                                                        minimumSize:
                                                                        MaterialStateProperty
                                                                            .all(Size(100,
                                                                            40)), // width: 80, height: 40
                                                                      ),
                                                                      onPressed: () async {
                                                                        if (_formKey.currentState!
                                                                            .validate()) {
                                                                          //call Update_password API
                                                                          if (await updatePassword(
                                                                              context,
                                                                              phno: _Phno.text
                                                                                  .trim()
                                                                                  .toString(),
                                                                              pwd: _Password.text
                                                                                  .trim()
                                                                                  .toString())) {
                                                                            Navigator.pop(
                                                                                context);
                                                                            _Password.clear();
                                                                            _Repassword.clear();
                                                                          }
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                        "Update",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontFamily: baseFont,
                                                                            fontSize: 18,
                                                                            fontWeight:
                                                                            FontWeight.w500,
                                                                            shadows: [
                                                                              Shadow(
                                                                                color:
                                                                                Colors.white,
                                                                                blurRadius: 0.2,
                                                                              )
                                                                            ]),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Text(
                                                  "Update\nPassword",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Update Profile Button
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isEditable;
  final TextInputType? keyboardType;
  final String hint;

  const EditTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isEditable = true,
    this.keyboardType,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isEditable ? darkBg.withOpacity(0.2) : darkBg.withOpacity(0.1),
        border: Border.all(
          color: darkBg.withOpacity(0.3),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.fromLTRB(5, 25, 15, 0),
      width: screenSize.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isEditable ? darkBg : darkBg.withOpacity(0.8),
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                if (!isEditable) ...[
                  SizedBox(width: 8),
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: darkBg.withOpacity(0.6),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              width: screenSize.width * 0.85 - 36,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: lightBg,
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: controller,
                enabled: isEditable,
                keyboardType: keyboardType,
                style: TextStyle(
                    fontSize: 18,
                    color: isEditable ? Colors.black : Colors.black54,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
