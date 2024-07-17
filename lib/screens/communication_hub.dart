import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/widgets/message_card_item.dart';

class CommunicationHub extends StatefulWidget {
  final String profileId;

  const CommunicationHub({super.key, required this.profileId});

  @override
  State<CommunicationHub> createState() {
    return _CommunicationHubState();
  }
}

class _CommunicationHubState extends State<CommunicationHub> {
  //default the selected category to category 3
  int selectedCategory = 3;
  //a list to hold the cards that are selected by a profile user's clicks
  List<MessageCard> selectedCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication Hub'),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          //this is a panel to display clicked message cards
          Container(
            height: 120,
            color: Theme.of(context).colorScheme.onSecondary,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //iterate through the list of selected messageCards and display in this row
                children: selectedCards.map((singleCard) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: MessageCardItem(messageCard: singleCard),
                  );
                }).toList(),
              ),
            ),
          ),
          // row with play button and trash can to read the selected cards and clear them respectively
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  //code to read the message cards in the above container
                },
                icon: const Icon(FontAwesomeIcons.play),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedCards.clear();
                  });
                },
                icon: const Icon(FontAwesomeIcons.trashCan),
              ),
            ],
          ),
          //vertically scrolling column with message cards
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                //get the message Card data from firebase only for our selected profile matching the chosen category
                stream: FirebaseFirestore.instance
                .collection('profiles')
                .doc(widget.profileId)
                    .collection('message_cards')
                    .where('categoryId', isEqualTo: selectedCategory)
                    .snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return const Center(child: CircularProgressIndicator());
                  }
                  final cardDeck = snapshot.data!.docs.map(
                      (doc){
                        return MessageCard.fromMap(doc.data() as Map<String, dynamic>);
                      }
                  ).toList();
                  return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: cardDeck.length,
                      itemBuilder: (context, index) {
                        final card = cardDeck[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCards.length < 3){
                                selectedCards.add(card);
                              }
                            });
                          },
                          child: MessageCardItem(messageCard: card),
                        );
                      }
                  );
                },
              )
          ),
          //horizontally scrolling row for the categories
        ],
      ),
    );
  }
}
