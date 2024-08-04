import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/repositories/message_card_repository.dart';
import '../models/message_card.dart';
import '../services/message_card_click_count_service.dart';
import '../services/tts_service.dart';
import '../widgets/category_row.dart';
import '../widgets/instruction_card.dart';
import '../widgets/logo_title_row.dart';
import '../widgets/message_card_grid.dart';
import '../widgets/message_card_item.dart';

/// The CurateCards screen allows users to manage their message cards by
/// selecting, viewing, and deleting existing cards.
///
/// This screen includes:
/// - A panel to display the currently selected message card.
/// - Buttons to clear the selected card or delete it from the system.
/// - A grid view to browse and select message cards based on the selected category.
/// - A row of categories to filter the message cards.
///
/// The `CurateCards` screen follows these key user interactions:
/// - Selecting a message card displays it in the panel.
/// - Clicking the trash icon prompts a confirmation dialog to delete the card.
/// - Clicking the X icon clears the selected card from the panel.
class CurateCards extends StatefulWidget {
  final String profileId;

  const CurateCards({super.key, required this.profileId});

  @override
  State<CurateCards> createState() {
    return _CurateCardsState();
  }
}

class _CurateCardsState extends State<CurateCards> {
  final TTSService ttsService = TTSService(); // Instantiate TTSService
  int selectedCategory = 3; //default the selected category to category 3
  List<MessageCard> selectedCards =
      []; //declare a list to hold selected messageCards
  late MessageCardClickCountService
      messageCardService; //declare the service which manages card history
  //initialise the messageCardRepo
  final MessageCardRepository messageCardRepository = MessageCardRepository();

  @override
  void initState() {
    super.initState();
    // Initialize the service
    messageCardService = MessageCardClickCountService(profileId: widget.profileId);
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

  ///method to set the state to update the UI when category selected
  void _onCategorySelected(int categoryId) {
    setState(() {
      selectedCategory = categoryId;
    });
  }

  ///method to show confirmation dialogue before deletion
  Future<void> _confirmDeleteDialogue(BuildContext context) async {
    //show the dialogue and store user response as a bool
    final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Card'),
            content: const Text('This item will be permanently\ndeleted'
                ' from memory and\nwill no longer be available for\n'
                'selection or be retrievable.'),
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

      try {
        // Find the document ID, call method in messageCardRepo
        QuerySnapshot querySnapshot = await messageCardRepository
            .findMessageCardById(widget.profileId, messageCardId);
        if (querySnapshot.docs.isNotEmpty) {
          String docId = querySnapshot.docs.first.id;

          // Delete the document, call method in messageCardRepo
          await messageCardRepository
              .deleteMessageCard(widget.profileId, docId, categoryId, imageUrl);

          // Clear the selected card and set the state
          setState(() {
            selectedCards.clear();
          });

          // Feedback for the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card deleted successfully')),
          );
        } else {
          print('Message card $messageCardId not found');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message card not found')),
          );
        }
      } catch (error) {
        print('Failed to delete message card $messageCardId: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete message card')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LogoTitleRow(
            logoWidth: 35,
            logoHeight: 35,
            titleText: 'Curate Cards',
            textSize: 30,
            spacerWidth: 10
        ),
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
          /* row with a trash and an X that can to delete the selected card
           and clear the selected card from the row respectively */
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
            /*call the messageCardGrid to show message cards
            and return gridview.builder*/
            child: MessageCardGrid(
                selectedCategory: selectedCategory,
                profileId: widget.profileId,
                flutterTts: ttsService.flutterTts,
                messageCardService: messageCardService,
                onCardSelected: _onCardSelected,
                isProfileMode: false,
                selectedCards: selectedCards),
          ),
          /*horizontally scrolling row for the categories
          returned on calling CategoryRow*/
          CategoryRow(
              flutterTts: ttsService.flutterTts, onCategorySelected: _onCategorySelected),
        ],
      ),
    );
  }
}
