import 'package:hive/hive.dart';
import 'package:your_choice/models/message_card.dart';

import '../../repositories/message_card_repository.dart';
import '../message_card_click_count_service.dart';

class MessageCardCacheService {
  final Box<MessageCard> _box = Hive.box<MessageCard>('messageCards');
  final MessageCardClickCountService _clickCountService;



  MessageCardCacheService(this._clickCountService);

  ///method to save a messageCard to the local cache
  Future<void> saveMessageCard(MessageCard messageCard) async {
    print('saving messageCard to the cache');
    await _box.put(messageCard.messageCardId, messageCard);
  }

  ///method to retrieve a messageCard from the local cache by its Id
  MessageCard? getMessageCard(String messageCardId) {
    return _box.get(messageCardId);
  }

  ///method to retrieve messageCards by categoryId from the local cache
  List<MessageCard> getMessageCardsByCategory(int categoryId) {
    print('getting from cache by category');
    return _box.values
        .where(
            (card) => card.categoryId == categoryId
    ).toList();
  }

  ///method to retrieve all messageCards from the local cache
  List<MessageCard> getAllMessageCards() {
    return _box.values.toList();
  }

  ///method to clear the local cache
  Future<void> clearCache() async {
    await _box.clear();
  }

  ///method to update the selection count of a MessageCard
  Future<void> updateSelectionCount(String messageCardId, String profileId) async {
    var card = getMessageCard(messageCardId);
    if(card != null) {
      card.selectionCount += 1;
      //update count in cache
      await saveMessageCard(card);
      //update count on firestore
      await _clickCountService.selectCard(card);
    }
  }

  ///get top selected MessageCards from the local cache
  List<MessageCard> getTopSelectedCardsFromCache() {
    var cards = _box.values.toList();
    cards.sort((a, b) => b.selectionCount.compareTo(a.selectionCount));
    return cards.take(12).toList();
  }

}