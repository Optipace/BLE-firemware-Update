import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminEditUser extends StatefulWidget{
  @override
  State<AdminEditUser> createState() => AdminEditUserState();
}

class AdminEditUserState extends State<AdminEditUser>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(
       title: Text("Edit User"),
     ),
   );
  }

}