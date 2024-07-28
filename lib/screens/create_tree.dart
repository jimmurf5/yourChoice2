import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/widgets/question_answer_section.dart';

import '../models/message_card.dart';

/// This screen allows the user to create a decision tree with a title
/// and a maximum of three questions.
/// Each question can have two possible answers,
/// which can be chosen from the database.
/// The user can save the decision tree by pressing the 'Create Tree' button.
class CreateTree extends StatefulWidget {
  final String profileId;

  const CreateTree({
    super.key, required this.profileId
  });

  @override
  State<CreateTree> createState() {
    return _CreateTreeState();
  }
}

class _CreateTreeState extends State<CreateTree> {
  //declare some controllers for editable text fields
  final TextEditingController treeTitleController = TextEditingController();
  final TextEditingController question1Controller = TextEditingController();
  final TextEditingController question2Controller = TextEditingController();
  final TextEditingController question3Controller = TextEditingController();

  MessageCard? answer1;
  MessageCard? answer2;
  MessageCard? answer3;
  MessageCard? answer4;
  MessageCard? answer5;
  MessageCard? answer6;

  //dispose of controllers
  @override
  void dispose() {
    treeTitleController.dispose();
    question1Controller.dispose();
    question2Controller.dispose();
    question3Controller.dispose();
    super.dispose();
  }

  //function to handle the selected answer
  void _handleAnswerSelected(MessageCard messageCard, int answerNumb) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Create Tree'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: treeTitleController,
                decoration: InputDecoration(
                  labelText: 'Decision Tree Title',
                  fillColor: Theme.of(context).colorScheme.inversePrimary,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              //call the question answer widget to present text questions
              //and messageCard answers
              QuestionAnswerSection(
                  questionController: question1Controller,
                  questionLabel: 'Questions 1',
                  profileId: widget.profileId,
                  //get the messageCard selected from the call back function
                  //pass the card to handleAnswerSelected
                  onAnswerSelected: _handleAnswerSelected,
              ),
              QuestionAnswerSection(
                questionController: question2Controller,
                questionLabel: 'Questions 2',
                profileId: widget.profileId,
                onAnswerSelected: _handleAnswerSelected,
              ),
              QuestionAnswerSection(
                questionController: question3Controller,
                questionLabel: 'Questions 3',
                profileId: widget.profileId,
                onAnswerSelected: _handleAnswerSelected,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  //save the tree to db
                },
                icon:const Icon(FontAwesomeIcons.tree),
                label: const Text('Create Tree'),
              )
            ],
          ),
        ),
      ),
    );
  }

}