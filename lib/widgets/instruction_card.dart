import 'package:flutter/material.dart';

///return a an instruction card
///instruction carried on card is passed to the method as a String
class InstructionCard extends StatelessWidget {
  final String text;

  const InstructionCard(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}