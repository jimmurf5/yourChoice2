import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/widgets/question_answer_section.dart';

import '../models/message_card.dart';
import '../services/tree_service.dart';

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
  //declare the tree service to interact with firebase
  final TreeService _treeService = TreeService();

  //declare some controllers for editable text fields
  final TextEditingController treeTitleController = TextEditingController();
  final TextEditingController question1Controller = TextEditingController();
  final TextEditingController question2Controller = TextEditingController();
  final TextEditingController question3Controller = TextEditingController();

  /*declare some messageCards to hold potential answers to questions
  if they are selected, so can be null*/
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

  /*function to handle the selected answer, assigns the 'messageCard' chosen
  to a variable of type 'MessageCard' using a switch statement and the input
  'answerId' as a key, then sets the state*/
  void _handleAnswerSelected(MessageCard messageCard, int answerId){
    setState(() {
      switch(answerId){
        case 1:
          answer1 = messageCard;
          break;
        case 2:
          answer2 = messageCard;
          break;
        case 3:
          answer3 = messageCard;
          break;
        case 4:
          answer4 = messageCard;
          break;
        case 5:
          answer5 = messageCard;
          break;
        case 6:
          answer6 = messageCard;
          break;
      }
    });
    // Add debug prints
    // Debugging: Print the state of all answers
    print('Answer 1: ${answer1?.messageCardId}');
    print('Answer 2: ${answer2?.messageCardId}');
    print('Answer 3: ${answer3?.messageCardId}');
    print('Answer 4: ${answer4?.messageCardId}');
    print('Answer 5: ${answer5?.messageCardId}');
    print('Answer 6: ${answer6?.messageCardId}');
  }

  /*validate the tree all- all trees must have at least a title and one
  * question. Each question must have 2 messageCards as possible answers*/
  bool _validateTree() {
    print('title: ${treeTitleController.text}');
    print('q1: ${question1Controller.text}');
    print('q2: ${question2Controller.text}');
    print('q3: ${question3Controller.text}');

    if(answer1 == null){
      print('answer1 is null');
    }
    if(answer2 == null){
      print('answer2 is null');
    }
    if(answer3 == null){
      print('answer3 is null');
    }
    if(answer4 == null){
      print('answer4 is null');
    }
    if(answer5 == null){
      print('answer5 is null');
    }
    if(answer6 == null){
      print('answer6 is null');
    }

    //make sure the decision tree has a title
    if(treeTitleController.text.trim().isEmpty) {
      return false;
    }

    bool valid = false;

    /*ensure at least one question is provide and that all provide questions
    *have 2 MessageCard potential answers, returns true if passes validation*/
    if(question1Controller.text.trim().isNotEmpty
        && answer1 != null && answer2 !=null) {
      valid = true;
    }

    /*ensure at least one question is provide and that all provide questions
    *have 2 MessageCard potential answers, returns true if passes validation*/
    if(question2Controller.text.trim().isNotEmpty
        && answer3 != null && answer4 !=null) {
      valid = true;
    }

    /*ensure at least one question is provide and that all provide questions
    *have 2 MessageCard potential answers, returns true if passes validation*/
    if(question3Controller.text.trim().isNotEmpty
        && answer5 != null && answer6 !=null) {
      valid = true;
    }

    return valid;
  }

  //method to save tree to FireBase
  void _saveTree() async {
    //first call _validateTree to make sure required data provided
    if(_validateTree()){
      try{
        //prepare the tree data

        List<Map<String, dynamic>> questions = [
          {
            'question': question1Controller.text,
            'answers': [
              {
                'messageCardId': answer1?.messageCardId ?? '',
              },
              {
                'messageCardId': answer2?.messageCardId ?? '',
              },
            ]
          },
          {
            'question': question2Controller.text,
            'answers': [
              {
                'messageCardId': answer3?.messageCardId ?? '',
              },
              {
                'messageCardId': answer4?.messageCardId ?? '',
              },
            ]
          },
          {
            'question': question3Controller.text,
            'answers': [
              {
                'messageCardId': answer5?.messageCardId ?? '',
              },
              {
                'messageCardId': answer6?.messageCardId ?? '',
              },
            ]
          }
        ];

        //save the tree data using the service
        await _treeService.saveTree(widget.profileId, treeTitleController.text, questions);

        //show success message
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Decision Tree saved successfully!'),
            )
        );

        //clear fields after saving
        treeTitleController.clear();
        question1Controller.clear();
        question2Controller.clear();
        question3Controller.clear();
        setState(() {
          answer1 == null;
          answer2 == null;
          answer3 == null;
          answer4 == null;
          answer5 == null;
          answer6 == null;
        });
      } catch (ex) {
        //show error message in snack bar if operation failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save the Decision Tree: $ex'),
          ),
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please ensure that a title and at least one question with two answers are provided!'),),
      );
    }

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
                onChanged: (_) => setState(() {}),  //rebuild to validate
              ),
              const SizedBox(height: 20),
              //call the question answer widget to present text questions
              //and messageCard answers
              QuestionAnswerSection(
                  questionController: question1Controller,
                  questionLabel: 'Questions 1',
                  profileId: widget.profileId,
                  /*get the messageCard selected from the callback function
                  pass the MessageCard to handleAnswerSelected along with
                  the answerNumb to allow the card to be assigned to a var
                  for storage*/
                  onAnswerSelected: (messageCard, answerNumb) {
                    print('in the questions answer section: messageCard- $messageCard answer numb- $answerNumb');
                    _handleAnswerSelected(messageCard, answerNumb);
                  },
                answer1Id: 1,
                answer2Id: 2,
              ),
              QuestionAnswerSection(
                questionController: question2Controller,
                questionLabel: 'Questions 2',
                profileId: widget.profileId,
                /*get the messageCard selected from the callback function
                  pass the MessageCard to handleAnswerSelected along with
                  the answerNumb to allow the card to be assigned to a var
                  for storage*/
                onAnswerSelected: (messageCard, answerNumb) {
                  _handleAnswerSelected(messageCard, answerNumb);
                },
                answer1Id: 3,
                answer2Id: 4,
              ),
              QuestionAnswerSection(
                questionController: question3Controller,
                questionLabel: 'Questions 3',
                profileId: widget.profileId,
                onAnswerSelected: (messageCard, answerNumb) {
                  _handleAnswerSelected(messageCard, answerNumb);
                },
                answer1Id: 5,
                answer2Id: 6,
              ),
              ElevatedButton.icon(
                onPressed: _saveTree, //disable the button if input not valid
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