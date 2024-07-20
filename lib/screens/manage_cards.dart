import 'package:flutter/material.dart';

class ManageCards extends StatefulWidget {
  const ManageCards({super.key});

  @override
  State<ManageCards> createState() {
    return _ManageCardsState();
  }
}

class _ManageCardsState extends State<ManageCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cards'),
      ),
      body: const Center(
        child: Text('Manage your cards here'),
      ),
    );
  }
}
