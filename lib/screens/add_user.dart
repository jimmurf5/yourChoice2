import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_choice/main.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() {
    return _AddUserState();
  }
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
    );
  }
}
