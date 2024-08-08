import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:your_choice/repositories/message_card_repository.dart';
import 'package:your_choice/services/message_card_click_count_service.dart';
import '../models/message_card.dart';
import '../services/hive/message_card_cache_service.dart';
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
  final MessageCardClickCountService messageCardService; // Optional only needed for profile presses
  final Function(MessageCard) onCardSelected; // Required callback for card selection
  final bool isProfileMode; // Flag to determine the mode (profile or user)
  final List<MessageCard> selectedCards; // Parameter to handle the list of selected cards
  final MessageCardCacheService _messageCardCacheService;
  final MessageCardRepository _messageCardRepository;

  /// Constructor for MessageCardGrid, initializes MessageCardRepository
  /// and MessageCardCacheService within the constructor
  MessageCardGrid({
    super.key,
    required this.selectedCategory,
    required this.profileId,
    required this.flutterTts,
    required this.messageCardService,
    required this.onCardSelected,
    required this.isProfileMode,
    required this.selectedCards,
  })  : _messageCardRepository = MessageCardRepository(),
        _messageCardCacheService = MessageCardCacheService(MessageCardClickCountService(profileId: profileId));

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == 1) {
      return FutureBuilder<List<MessageCard>>(
        future: _messageCardRepository.getTopSelectedCards(profileId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final cardDeck = snapshot.data!;
          return _buildGridView(cardDeck);
        },
      );
    } else {
      var cachedCards = _messageCardCacheService.getMessageCardsByCategory(selectedCategory);
      if (cachedCards.isNotEmpty) {
        return _buildGridView(cachedCards);
      } else {
        return StreamBuilder<QuerySnapshot>(
          stream: _messageCardRepository.fetchMessageCards(profileId: profileId, categoryId: selectedCategory),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error fetching data: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final cardDeck = snapshot.data!.docs.map((doc) {
              return MessageCard.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();
            _cacheMessageCards(cardDeck);
            return _buildGridView(cardDeck);
          },
        );
      }
    }
  }

  //private method to cache fetched messageCards
  Future<void> _cacheMessageCards(List<MessageCard> cardDeck) async {
    for (var card in cardDeck) {
      await _messageCardCacheService.saveMessageCard(card);
    }
  }

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
            await flutterTts.speak(card.title);
            onCardSelected(card);
            if (isProfileMode) {
              // Update selection count in cache and Firestore
              await _messageCardCacheService.updateSelectionCount(
                  card.messageCardId,
                  profileId
              );
              await messageCardService.selectCard(card);
            }
          },
          child: MessageCardItem(messageCard: card),
        );
      },
    );
  }
}
