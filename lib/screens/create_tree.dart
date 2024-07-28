import 'package:flutter/material.dart';
import 'package:your_choice/widgets/question_answer_section.dart';

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

  //dispose of controllers
  @override
  void dispose() {
    treeTitleController.dispose();
    question1Controller.dispose();
    question2Controller.dispose();
    question3Controller.dispose();
    super.dispose();
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
          padding: const EdgeInsets.all(16.0),
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
              QuestionAnswerSection(questionController: question1Controller, questionLabel: 'Questions 1'),
              QuestionAnswerSection(questionController: question2Controller, questionLabel: 'Questions 2'),
              QuestionAnswerSection(questionController: question3Controller, questionLabel: 'Questions 3'),
            ],
          ),
        ),
      ),
    );
  }

}