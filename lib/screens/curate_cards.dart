import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/repositories/message_card_repository.dart';
import 'package:your_choice/services/hive/category_cache_service.dart';
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
  final CategoryCacheService _categoryCacheService = CategoryCacheService();

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
              .deleteMessageCard(widget.profileId, messageCardId, docId, categoryId, imageUrl);

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

  Future<void> _showCategorySelectionDialog(BuildContext context) async {
    // Fetch categories (you could fetch from cache or Firestore getting from
    // cache as they must be in the cache if categories has been selected)
    final categories = _categoryCacheService.getAllCategories()
    /*exclude categories 1 and 2, user shouldn't be allowed to choose
      original or history as categories
     */
    .where((category) => category.categoryId != 1 && category.categoryId != 2)
    .toList();

    final selectedCategoryId = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select New Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: categories.map((category) {
                return ListTile(
                  title: Text(category.title),
                  onTap: () {
                    Navigator.pop(context, category.categoryId);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selectedCategoryId != null) {
      // Update the selected card's category
      await _changeCategoryOfSelectedCard(selectedCategoryId);
    }
  }

  Future _changeCategoryOfSelectedCard(int newCategoryId) async {
    try {
      if(selectedCards.isNotEmpty) {
        MessageCard card = selectedCards.first;

        //update firestore
        await messageCardRepository
            .changeCategory(card.messageCardId, widget.profileId, newCategoryId);

        //update the card object locally
        card.categoryId = newCategoryId;

        //clear the selection and refresh the UI
        setState(() {
          selectedCards.clear();
          selectedCategory = newCategoryId; // change to new cat to show card has changed
        });

        //provide the user feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category changed successfully')),
        );
      }
    } catch (error) {
      print('Failed to change category: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to change the category')),
      );
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
                  if (selectedCards.isNotEmpty && selectedCards.first.categoryId == 2)
                    const InstructionCard('X CLEARS.\nARROW\nSWAPS\nCATEGORY')
                  else if (selectedCards.isNotEmpty)
                    const InstructionCard('X\nCLEARS\nTHE\nPANEL')
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
                  /* On the messageCard in the display panel is clear and the
                  * system speaks the word "Clear!" */
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
                  /* On pressed the delete operation begins, user is shown
                  * dialogue message and given delete option */
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
                IconButton(
                  /* On pressed the swap button allows the user to change a
                  * messageCard's category, but the button is conditional.
                  * Only an original messageCard may be re- categorised and
                  * the button is rendered conditionally */
                  onPressed: selectedCards.isNotEmpty && selectedCards.first.imageUrl.contains('firebasestorage')
                      ? () async {
                    await _showCategorySelectionDialog(context);
                  }
                      : null,
                  icon: const Icon(FontAwesomeIcons.shuffle),
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
