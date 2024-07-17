import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/widgets/message_card_item.dart';

class CommunicationHub extends StatefulWidget {
  const CommunicationHub({super.key});

  @override
  State<CommunicationHub> createState() {
    return _CommunicationHubState();
  }
}

class _CommunicationHubState extends State<CommunicationHub> {
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
          )
          //vertically scrolling column with message cards
        ],
      ),
    );
  }
}
