import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/services/hive/message_card_cache_service.dart';
import 'package:your_choice/services/tts_service.dart';
import 'package:your_choice/widgets/message_card_item.dart';
import '../models/message_card.dart';
import '../repositories/message_card_repository.dart';

/// A widget that displays a tree of questions and their answers using data
/// from Firestore.
/// Each question can have 2 answers, displayed as MessageCards in a grid layout.
class DisplayTree extends StatefulWidget {
  final DocumentSnapshot treeSnapshot;
  final String profileId;

  const DisplayTree({
    super.key,
    required this.treeSnapshot,
    required this.profileId,
  });

  @override
  State<DisplayTree> createState() => _DisplayTreeState();
}

class _DisplayTreeState extends State<DisplayTree> {
  final TTSService ttsService = TTSService();
  // Instantiate TTSService
  final MessageCardRepository _messageCardRepository = MessageCardRepository();
  final MessageCardCacheService _cacheService = MessageCardCacheService();
  Map<String, dynamic> clickedState =
      {}; //store the clicked state for each messageCard

  @override
  Widget build(BuildContext context) {
    var treeData = widget.treeSnapshot.data() as Map<String, dynamic>;
    var treeTitle = '${treeData['treeTitle']}'; // Store the tree title
    var tree =
        treeData['questions'] as List<dynamic>; //store the q's and answers

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
          const SizedBox(
              height: 16), // Add spacing between the button and the answers
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 2
                        : 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: answers.length,
              itemBuilder: (context, index) {
                var answer = answers[index];
                var messageCardId = answer['messageCardId'];

                //first lets check if the messageCard is in the cache
                var cachedCard = _cacheService.getMessageCard(
                    messageCardId, widget.profileId);
                //if in the cache, use the cache
                if (cachedCard != null) {
                  return _buildMessageCardItem(cachedCard);
                } else {
                  /* Use FutureBuilder to handle the asynchronous operation of
              *  fetching the messageCard by their messageCardId
              *  Call the messageCardRepo to use method of that class*/
                  return FutureBuilder<QuerySnapshot>(
                    future: _messageCardRepository.findMessageCardById(
                        widget.profileId, messageCardId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('Message card not found');
                      }

                      // Fetch the document ID from the query snapshot
                      var docId = snapshot.data!.docs.first.id;

                      /* Use another FutureBuilder (inside the first future builder)
                     to fetch the document using the doc ID (obtained from the
                     first future builder) */
                      return FutureBuilder<DocumentSnapshot>(
                        future: _messageCardRepository.fetchOneMessageCard(
                            widget.profileId, docId),
                        builder: (context, docSnapshot) {
                          if (docSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (docSnapshot.hasError) {
                            return Text('Error: ${docSnapshot.error}');
                          }
                          if (!docSnapshot.hasData ||
                              !docSnapshot.data!.exists) {
                            return const Text('Message card not found');
                          }

                          // Convert to a message card
                          var messageCard = MessageCard.fromMap(
                              docSnapshot.data!.data() as Map<String, dynamic>);
                          //cache the fetched card
                          _cacheService.saveImageFileLocally(messageCard, widget.profileId, messageCard.imageUrl);
                          return _buildMessageCardItem(messageCard);
                        },
                      );
                    },
                  );
                }
              }),
        ],
      ),
    );
  }

  ///widget to build a messageCard item
  ///returns a messageCardItem wrapped in a container,
  ///wrapped in a gesture detector
  ///speaks the title with tts and affect colour change on tap
  ///parameter [messageCard] - the messageCard to be displayed
  Widget _buildMessageCardItem(MessageCard messageCard) {
    // Check the clicked state of the current message card; default to false if not found
    var isClicked = clickedState[messageCard.messageCardId] ?? false;
    /* Return gesture detector wrapped around a container
                      // to handle colour change and to speak title */
    return GestureDetector(
        onTap: () async {
          // Toggle the clicked state for the current message card and update the state
          setState(() {
            clickedState[messageCard.messageCardId] = !isClicked;
          });
          await ttsService.flutterTts.speak(messageCard.title);
        },
        child: Container(
          color: isClicked ? Colors.green : Colors.white,
          child: MessageCardItem(messageCard: messageCard),
        ));
  }
}
