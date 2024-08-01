import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/widgets/message_card_item.dart';
import '../models/message_card.dart';

class DisplayTree extends StatelessWidget {
  final DocumentSnapshot treeSnapshot;
  final String profileId;

  const DisplayTree({
    super.key,
    required this.treeSnapshot,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context) {
    var treeData = treeSnapshot.data() as Map<String, dynamic>;
    var treeTitle = '${treeData['treeTitle']}'; // Store the tree title

    var tree = treeData['questions'] as List<dynamic>;
    var treeSize = tree.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(treeTitle),
        actions: [
          IconButton(
            onPressed: () async {
              //await ttsService.flutterTts.speak(treeTitle);
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

  Widget buildSingleQuestion(BuildContext context, dynamic singleQuestion) {
    return Center(
      child: buildQuestionCard(context, singleQuestion),
    );
  }

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

  Widget buildQuestionCard(BuildContext context, dynamic singleQuestion) {
    var questionText = singleQuestion['question'];
    var answers = singleQuestion['answers'] as List<dynamic>;
    print('the 2 answers from the map $answers');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Implement TTS functionality
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

                  var messageCard = MessageCard.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                  return MessageCardItem(messageCard: messageCard);
                },
              );
            },
          ),
        ],
      ),
    );
  }

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
