import 'package:hive/hive.dart';
import 'package:your_choice/models/message_card.dart';

class MessageCardCacheService {
  final Box<MessageCard> _box = Hive.box<MessageCard>('messageCards');

  ///method to save a messageCard to the local cache
  Future<void> saveMessageCard(MessageCard messageCard) async {
    await _box.put(messageCard.messageCardId, messageCard);
  }

  ///method to retrieve a messageCard from the local cache by its Id
  MessageCard? getMessageCard(String messageCardId) {
    return _box.get(messageCardId);
  }

  ///method to retrieve messageCards by categoryId from the local cache
  List<MessageCard> getMessageCardsByCategory(int categoryId) {
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

}