import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/models/message_card.dart';

class QuestionAnswerSection extends StatefulWidget {
  final String questionLabel;
  final TextEditingController questionController;

  const QuestionAnswerSection({
    super.key,
    required this.questionLabel,
    required this.questionController
  });

  @override
  State<QuestionAnswerSection> createState() => _QuestionAnswerSectionState();
}

class _QuestionAnswerSectionState extends State<QuestionAnswerSection> {
  //declare variable to hold message cards, they can be null in case of
  //no answer yet being selected
  MessageCard? selectedAnswer1;
  MessageCard? selectedAnswer2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //a row for the question
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
        //a row for the answer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.inversePrimary
                )
              ),
              height: 80,
              child: ElevatedButton.icon(
                onPressed: () {
                  //take the user to menu to choose messageCard
                },
                label: const Text('Answer 1'),
                icon: const Icon(FontAwesomeIcons.comment),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.inversePrimary
                  )
              ),
              height: 80,
              child: ElevatedButton.icon(
                onPressed: () {
                  //take the user to menu to choose messageCard
                },
                label: const Text('Answer 2'),
                icon: const Icon(FontAwesomeIcons.comment),
              ),
            ),
          ],
        ),
      ],
    );
  }
}