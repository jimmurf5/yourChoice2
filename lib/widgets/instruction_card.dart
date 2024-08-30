import 'package:flutter/material.dart';

/// A widget that displays a given text as an instructional message on a styled card.
///
/// The text content is passed as a [String] to the widget and is displayed with bold styling
/// and a font size of 20. The card background and text colour are based on the current theme.
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