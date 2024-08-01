import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/services/message_card_delete_service.dart';

import '../models/message_card.dart';
import '../services/message_card_service.dart';
import '../widgets/category_row.dart';
import '../widgets/instruction_card.dart';
import '../widgets/message_card_grid.dart';
import '../widgets/message_card_item.dart';

class CurateCards extends StatefulWidget {
  final String profileId;

  const CurateCards({super.key, required this.profileId});

  @override
  State<CurateCards> createState() {
    return _CurateCardsState();
  }
}

class _CurateCardsState extends State<CurateCards> {
  FlutterTts flutterTts = FlutterTts(); //initialize flutter tts
  int selectedCategory = 3; //default the selected category to category 3
  List<MessageCard> selectedCards =
      []; //declare a list to hold selected messageCards
  late MessageCardService
      messageCardService; //declare the service which manages card history
  //initialise the deletion service
  final MessageCardDeleteService deleteService = MessageCardDeleteService();

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
  }

  ///method to set the state, to update the UI when card selected
  ///only if the condition in the if block is met
  ///in curate cards only allow one card to be added to the panel
  /// ie if selectedCards is empty
  void _onCardSelected(MessageCard card) {
    setState(() {
      if (selectedCards.isEmpty) {
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

  //method to show confirmation dialogue before deletion
  Future<void> _confirmDeleteDialogue(BuildContext context) async {
    //show the dialogue and store user response as a bool
    final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Card'),
            content: const Text('This item will be permanently\ndeleted'
                ' from memory and\nwill no longer be available for\n'
                'selection or retrievable.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); //return false
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); //return true
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          );
        });
    //only enter this block if user has confirmed deletion
    if (shouldDelete == true) {
      //get the one message card from the list and store its Id, category & url
      MessageCard cardForDelete = selectedCards.first;
      String messageCardId = cardForDelete.messageCardId;
      int categoryId = cardForDelete.categoryId;
      String imageUrl = cardForDelete.imageUrl;
      print('curate cards- card id for deletion: $messageCardId');
      //call the deletion service
      deleteService.deleteMessageCard(
          widget.profileId,
          messageCardId,
          categoryId,
          imageUrl
      );
      //clear the selected card and set the state
      setState(() {
        selectedCards.clear();
      });
      //feedback for the user
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card deleted successfully'),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curate Cards'),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                children: [
                  if (selectedCards.isNotEmpty)
                    const InstructionCard('TRASH\nCAN\nDELETES\nCARD'),
                  const SizedBox(
                    width: 10,
                  ),
                  if (selectedCards.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: MessageCardItem(messageCard: selectedCards.first),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (selectedCards.isNotEmpty)
                    const InstructionCard('X\nCLEARS\nTHE\nPANEL'),
                ],
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
                  icon: const Icon(FontAwesomeIcons.x),
                  iconSize: 25,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                IconButton(
                  //on pressed tts to read out the message card
                  // held in the selected cards list
                  //shown in the display panel
                  onPressed: () async {
                    if (selectedCards.isNotEmpty) {
                      //show confirmation dialogue before deleting
                      await _confirmDeleteDialogue(context);
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.trash),
                  iconSize: 45,
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
                isProfileMode: false,
                selectedCards: selectedCards),
          ),
          //horizontally scrolling row for the categories
          //returned on calling CategoryRow
          CategoryRow(
              flutterTts: flutterTts, onCategorySelected: _onCategorySelected),
        ],
      ),
    );
  }
}
