import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/widgets/category_item.dart';
import 'package:your_choice/widgets/long_press_button.dart';
import 'package:your_choice/widgets/message_card_item.dart';
import 'package:your_choice/services/message_card_service.dart';
import '../models/category.dart';
import '../widgets/category_row.dart';
import '../widgets/message_card_grid.dart';

class CommunicationHub extends StatefulWidget {
  final String profileId;

  const CommunicationHub({super.key, required this.profileId});

  @override
  State<CommunicationHub> createState() {
    return _CommunicationHubState();
  }
}

class _CommunicationHubState extends State<CommunicationHub> {
  FlutterTts flutterTts = FlutterTts(); //initialize flutter tts
  int selectedCategory = 3; //default the selected category to category 3
  List<MessageCard> selectedCards = []; //declare a list to hold selected messageCards
  late MessageCardService messageCardService; //declare the service which manages card history

  @override
  void initState() {
    super.initState();
    // Initialize the service
    messageCardService = MessageCardService(profileId: widget.profileId);
    print('messageCardService initialized with profileId: ${widget.profileId}');
    initializeTts(); //initialise tts
  }

  void initializeTts() {
    flutterTts.setLanguage("en-UK");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);

    flutterTts.setStartHandler(() {
      print("TTS Started");
    });

    flutterTts.setCompletionHandler(() {
      print("TTS Completed");
    });

    flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
    });
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
        title: const Text('Communication Hub'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        //remove the default arrow provided by flutter in the app bar
        automaticallyImplyLeading: false,
        leading: //button to navigate profile to saved decision trees
            IconButton(
                onPressed: () {
                  //logic to show decision tress
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
                    await flutterTts.speak('Clear!');
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
                      await flutterTts.speak(card.title);
                      await flutterTts.awaitSpeakCompletion(true);
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
                  flutterTts: flutterTts,
                  messageCardService: messageCardService,
                  onCardSelected: _onCardSelected,
                  isProfileMode: true,
                  selectedCards: selectedCards
              ),
          ),
          //horizontally scrolling row for the categories
          //returned on calling CategoryRow
          CategoryRow(
              flutterTts: flutterTts,
              onCategorySelected: _onCategorySelected
          ),
        ],
      ),
    );
  }
}
