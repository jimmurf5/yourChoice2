import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/widgets/choose_message_card.dart';

class QuestionAnswerSection extends StatefulWidget {
  final String questionLabel;
  final TextEditingController questionController;

  const QuestionAnswerSection({
    super.key,
    required this.questionController,
    required this.questionLabel,
  });

  @override
  State<QuestionAnswerSection> createState() => _QuestionAnswerSectionState();
}

class _QuestionAnswerSectionState extends State<QuestionAnswerSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // A row for the question
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: const Icon(FontAwesomeIcons.circleQuestion),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.questionController,
                decoration: InputDecoration(
                  labelText: widget.questionLabel,
                  fillColor: Theme.of(context).colorScheme.inversePrimary,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // A row for the answers
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ChooseMessageCard(textInButton: 'Answer 1'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ChooseMessageCard(textInButton: 'Answer 2'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(thickness: .5, color: Theme.of(context).colorScheme.secondary,),
      ],
    );
  }
}
