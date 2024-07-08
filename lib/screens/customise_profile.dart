import 'package:flutter/material.dart';

class CustomiseProfile extends StatelessWidget {
  const CustomiseProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customise Profile'),
      ),
      body: const Center(
        child: Text('Buttons here'),
      ),
    );
  }

}