import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:your_choice/repositories/message_card_repository.dart';
import 'package:your_choice/services/message_card_click_count_service.dart';
import '../models/message_card.dart';
import 'message_card_item.dart';

/// A widget that displays a grid of message cards based on the selected category.
/// And the profileId provided
/// It supports both future-based and stream-based data sources to handle different
/// categories (e.g., history category vs. other categories).
/// When in profile mode, it performs text-to-speech (TTS) for the card titles and
/// updates the selection count for each card through the `messageCardService`.
class MessageCardGrid extends StatelessWidget {
  final int selectedCategory;
  final String profileId;
  final FlutterTts flutterTts;
  final MessageCardClickCountService
      messageCardService; //optional only needed for profile presses
  final Function(MessageCard)
      onCardSelected; //required call back for card selection
  final bool isProfileMode; //flag to determine the mode (profile or user)
  final List<MessageCard> selectedCards; //a parameter to handle the list of selected cards
  final MessageCardRepository _messageCardRepository;

  ///The constructor for messageCardGrid, it initialises messageCardRepository
  ///within the constructor
  MessageCardGrid(
      {super.key,
      required this.selectedCategory,
      required this.profileId,
      required this.flutterTts,
      required this.messageCardService,
      required this.onCardSelected,
      required this.isProfileMode, required this.selectedCards
      }) : _messageCardRepository = MessageCardRepository();

  @override
  Widget build(BuildContext context) {
    //ternary to deal with category being = 1 (history)
    return selectedCategory == 1
        ? FutureBuilder<List<MessageCard>>(
              /*get the top selected cards from firebase for our selected
                profile, call the messageCardRepo to fetch from firebase*/
            future: _messageCardRepository
                .getTopSelectedCards(profileId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              //store the cards in card deck and call buildGridView to display
              final cardDeck = snapshot.data!;
              return _buildGridView(cardDeck);
            },
          )
        : StreamBuilder<QuerySnapshot>(
            /*get the message Card data from firebase only for our selected
            profile matching the chosen category, call the messageCardRepo
            to fetch from firebase*/
            stream: _messageCardRepository
                .fetchMessageCards(profileId: profileId, categoryId: selectedCategory),
            builder: (context, snapshot) {
              // Check for any errors
              if (snapshot.hasError) {
                //print("Error fetching data: ${snapshot.error}");
                return Center(
                    child: Text('Error fetching data: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final cardDeck = snapshot.data!.docs.map((doc) {
                //print("MessageCard Data: ${doc.data()}");
                return MessageCard.fromMap(doc.data() as Map<String, dynamic>);
              }).toList();
              //build the grid view using the deck of cards return by firestore
              return _buildGridView(cardDeck);
            },
          );
  }

// Private method to build the grid view
  Widget _buildGridView(List<MessageCard> cardDeck) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        childAspectRatio: 0.75,
      ),
      itemCount: cardDeck.length,
      itemBuilder: (context, index) {
        final card = cardDeck[index];
        return GestureDetector(
          onTap: () async {
            // Always speak the card title
            await flutterTts.speak(card.title);
            //only enter this block if in profile mode
            //always allow onCardSelected to be called and let the calling
            //method handle the follow on logic
            onCardSelected(card);
            if (isProfileMode) {
              //call messageCardService.selectCard only in profile mode
              // to update selection count for card
              await messageCardService.selectCard(card);
            }
          },
          //call message card item to show the message card
          child: MessageCardItem(messageCard: card),
        );
      },
    );
  }
}
