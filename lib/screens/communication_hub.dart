import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/widgets/message_card_item.dart';
import 'package:your_choice/services/message_card_service.dart';
import '../services/tts_service.dart';
import '../widgets/category_row.dart';
import '../widgets/long_press_button.dart';
import '../widgets/message_card_grid.dart';
import 'manage_trees.dart';

/// CommunicationHub is a StatefulWidget that serves as the main
/// communication interface for  a profile.
/// This widget provides a UI for selecting and displaying message cards,
/// reading them out loud using text-to-speech (TTS),
/// and managing selected cards by allowing up to 3 of them to be displayed in a panel.
/// It includes functionalities for navigating to the ManageTrees screen,
/// displaying selected message cards, and choosing categories of message cards.
class CommunicationHub extends StatefulWidget {
  final String profileId;


  const CommunicationHub({super.key, required this.profileId});

  @override
  State<CommunicationHub> createState() {
    return _CommunicationHubState();
  }
}

class _CommunicationHubState extends State<CommunicationHub> {
  final TTSService ttsService = TTSService(); // Instantiate TTSService
  int selectedCategory = 3; //default the selected category to category 3
  List<MessageCard> selectedCards = []; //declare a list to hold selected messageCards
  late MessageCardService messageCardService; //declare the service which manages card history

  @override
  void initState() {
    super.initState();
    // Initialize the service
    messageCardService = MessageCardService(profileId: widget.profileId);
    print('messageCardService initialized with profileId: ${widget.profileId}');
  }

  //method to set the state, to update the UI when card selected
  //only if the condition in the if block is met
  void _onCardSelected(MessageCard card) {
    setState(() {
      if(selectedCards.length<3) {
        selectedCards.add(card);
      }
    });
  }

  //method to, set the state to update the UI when category selected
  void _onCategorySelected(int categoryId) {
    setState(() {
      selectedCategory = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset('assets/images/logo_2.png'), // Replace with your logo asset
            ),
            const SizedBox(width: 10),
            const Text(
              'Your Choice',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        //remove the default arrow provided by flutter in the app bar
        automaticallyImplyLeading: false,
        leading: //button to navigate profile to saved decision trees
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      /*Navigate to manage trees and pass false for the bool as
                    * we are currently in profile mode*/
                      MaterialPageRoute(
                        builder: (context) =>
                            ManageTrees(
                              profileId: widget.profileId,
                              isUserMode: false,
                            ),
                      )
                  );
                },
                icon: const Icon(FontAwesomeIcons.tree),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
        actions: <Widget>[
          //only allow profile to leave the comm hub screen on a long press
          //call on long press widget
          //current long press set at 8 seconds
          LongPressButton(
            onLongPressCompleted: Navigator.of(context)
                .pop, //pop back to admin home on successful long press
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          //this is a panel to display clicked message cards
          Container(
            height: 150,
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
          // row with play button and trash can to read the selected cards
          // and clear them respectively
          Container(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      selectedCards.clear();
                    });
                    await ttsService.flutterTts.speak('Clear!');
                  },
                  icon: const Icon(FontAwesomeIcons.trashCan),
                  iconSize:25,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                IconButton(
                  //on pressed tts to read out the maximum of three items
                  // held in the selected cards list
                  //shown in the display panel
                  onPressed: () async {
                    for (var card in selectedCards) {
                      await ttsService.flutterTts.speak(card.title);
                      await ttsService.flutterTts.awaitSpeakCompletion(true);
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.play),
                  iconSize:45,
                  alignment: Alignment.center,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ],
            ),
          ),
          //vertically scrolling column with message cards
          Expanded(
              //call the messageCardGrid to show message cards
              //and return gridview.builder
              child: MessageCardGrid(
                  selectedCategory: selectedCategory,
                  profileId: widget.profileId,
                  flutterTts: ttsService.flutterTts,
                  messageCardService: messageCardService,
                  onCardSelected: _onCardSelected,
                  isProfileMode: true,
                  selectedCards: selectedCards
              ),
          ),
          //horizontally scrolling row for the categories
          //returned on calling CategoryRow
          CategoryRow(
              flutterTts: ttsService.flutterTts,
              onCategorySelected: _onCategorySelected
          ),
        ],
      ),
    );
  }
}
