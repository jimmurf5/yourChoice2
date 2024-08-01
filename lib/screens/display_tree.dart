import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/services/tts_service.dart';
import 'package:your_choice/widgets/message_card_item.dart';
import '../models/message_card.dart';

/// A widget that displays a tree of questions and their answers using data
/// from Firestore.
/// Each question can have 2 answers, displayed as MessageCards in a grid layout.
class DisplayTree extends StatelessWidget {
  final DocumentSnapshot treeSnapshot;
  final String profileId;
  final TTSService ttsService = TTSService(); // Instantiate TTSService

  DisplayTree({
    super.key,
    required this.treeSnapshot,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context) {
    var treeData = treeSnapshot.data() as Map<String, dynamic>;
    var treeTitle = '${treeData['treeTitle']}'; // Store the tree title
    var tree = treeData['questions'] as List<dynamic>; //store the q's and answers

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(treeTitle),
        actions: [
          IconButton(
            onPressed: () async {
              await ttsService.flutterTts.speak(treeTitle);
            },
            icon: const Icon(FontAwesomeIcons.comment),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: buildTreeLayout(context, tree),
      ),
    );
  }

  /// Builds the layout based on the number of questions in the tree.
  Widget buildTreeLayout(BuildContext context, List<dynamic> tree) {
    int treeSize = tree.length;

    if (treeSize == 1) {
      return buildSingleQuestion(context, tree[0]);
    } else if (treeSize == 2) {
      return buildTwoQuestions(context, tree);
    } else {
      return buildThreeQuestions(context, tree);
    }
  }

  /// Builds the layout for a single question.
  Widget buildSingleQuestion(BuildContext context, dynamic singleQuestion) {
    return Center(
      child: buildQuestionCard(context, singleQuestion),
    );
  }

  /// Builds the layout for 2 questions.
  Widget buildTwoQuestions(BuildContext context, List<dynamic> tree) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildQuestionCard(context, tree[0]),
          buildQuestionCard(context, tree[1]),
        ],
      ),
    );
  }

  /// Builds the layout for three questions.
  Widget buildThreeQuestions(BuildContext context, List<dynamic> tree) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildQuestionCard(context, tree[0]),
          buildQuestionCard(context, tree[1]),
          buildQuestionCard(context, tree[2]),
        ],
      ),
    );
  }

  /// Builds a card for a single question.
  /// Displays the question and its answers in a grid layout.
  Widget buildQuestionCard(BuildContext context, dynamic singleQuestion) {
    var questionText = singleQuestion['question'];
    var answers = singleQuestion['answers'] as List<dynamic>;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              ttsService.flutterTts.speak(questionText);
            },
            icon: const Icon(FontAwesomeIcons.comment),
            label: Text(questionText, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 16), // Add spacing between the button and the answers
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: answers.length,
            itemBuilder: (context, index) {
              var answer = answers[index];
              print('single answer: $answer');
              return FutureBuilder<DocumentSnapshot>(
                future: _getTheMessageCard(answer['messageCardId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('Message card not found');
                  }

                  //convert to a message card
                  var messageCard = MessageCard.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                  //return messageCard wrapped in a gesture detector to speak title
                  return GestureDetector(
                    onTap: () async {
                      await ttsService.flutterTts.speak(messageCard.title);
                    },
                      child: MessageCardItem(messageCard: messageCard),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Queries Firestore to get a specific message card by its ID.
  Future<DocumentSnapshot> _getTheMessageCard(String messageCardId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // First find the document with the given MessageCardId
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .where('messageCardId', isEqualTo: messageCardId)
        .limit(1)
        .get();

    String docId = querySnapshot.docs.first.id;

    return firebaseFirestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .doc(docId)
        .get();
  }
}
