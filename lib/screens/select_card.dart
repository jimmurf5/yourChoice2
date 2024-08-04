import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/message_card.dart';
import '../services/message_card_click_count_service.dart';
import '../services/tts_service.dart';
import '../widgets/category_row.dart';
import '../widgets/instruction_card.dart';
import '../widgets/message_card_grid.dart';
import '../widgets/message_card_item.dart';

/// The SelectCard screen allows users to select a message card
/// from a grid of cards, which are filtered by categories.
///
/// This screen is specifically used by the CreateTree screen to choose
/// message card answers for the decision tree.
///
/// This screen includes:
/// - A panel to display the currently selected message card.
/// - Buttons to clear the selected card or select it for further action.
/// - A grid view to browse and select message cards based on the selected category.
/// - A row of categories to filter the message cards.
class SelectCard extends StatefulWidget {
  final String profileId;

  const SelectCard({super.key, required this.profileId});

  @override
  State<SelectCard> createState() {
    return _SelectCardState();
  }
}

class _SelectCardState extends State<SelectCard> {
  final TTSService ttsService = TTSService(); // Instantiate TTSService
  int selectedCategory = 3; //default the selected category to category 3
  List<MessageCard> selectedCards =
  []; //declare a list to hold selected messageCards
  late MessageCardClickCountService
  messageCardService; //declare the service which manages card history

  @override
  void initState() {
    super.initState();
    // Initialize the service
    messageCardService = MessageCardClickCountService(profileId: widget.profileId);
    print('messageCardService initialized with profileId: ${widget.profileId}');
  }

  ///method to set the state, to update the UI when card selected
  ///only if the condition in the if block is met
  ///in select cards only allow one card to be added to the panel
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Card'),
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
                    const InstructionCard('PLUS\nSELECTS\nTHE\nCARD'),
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
                    await ttsService.flutterTts.speak('Clear!');
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
                      //pop back to create tree if card selected
                      //return the card to create tree
                      Navigator.of(context).pop(selectedCards.first);
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.plus),
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
                flutterTts: ttsService.flutterTts,
                messageCardService: messageCardService,
                onCardSelected: _onCardSelected,
                isProfileMode: false,
                selectedCards: selectedCards),
          ),
          //horizontally scrolling row for the categories
          //returned on calling CategoryRow
          CategoryRow(
              flutterTts: ttsService.flutterTts, onCategorySelected: _onCategorySelected),
        ],
      ),
    );
  }
}