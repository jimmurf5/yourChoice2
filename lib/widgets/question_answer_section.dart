import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/widgets/choose_message_card.dart';

/// A widget that represents a question with two possible answers.
/// Each answer can be selected by the user and displays a message card.
/// The widget returns a column containing a text field for the question
/// and two buttons (or selected cards) for the answers.
class QuestionAnswerSection extends StatefulWidget {
  final String questionLabel;
  final TextEditingController questionController;
  final String profileId;
  //callback functions to pass the selected MessageCard back to the parent widget
  final void Function(MessageCard, int) onAnswerSelected;

  const QuestionAnswerSection({
    super.key,
    required this.questionController,
    required this.questionLabel,
    required this.profileId,
    required this.onAnswerSelected,
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
        const SizedBox(height: 8),
        // A row for the answers
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 127,
                //call widget to allow MessageCard to be selected
                child: ChooseMessageCard(
                  textInButton: 'Answer 1',
                  profileId: widget.profileId,
                  onMessageCardSelected: (MessageCard) {
                    widget.onAnswerSelected(MessageCard, 1);
                  }
                ),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: SizedBox(
                height: 127,
                //call widget to allow MessageCard to be selected
                child: ChooseMessageCard(
                  textInButton: 'Answer 2',
                  profileId: widget.profileId,
                    onMessageCardSelected: (MessageCard) {
                      widget.onAnswerSelected(MessageCard, 2);
                    }
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Divider(
          thickness: 2,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
