import 'package:flutter/material.dart';

class CustomiseUx extends StatelessWidget {
  const CustomiseUx({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customise UX'),
      ),
      body: const Center(
        child: Text('Buttons here'),
      ),
    );
  }

}