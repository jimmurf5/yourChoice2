import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_choice/models/message_card.dart';
import '../message_card_click_count_service.dart';

class MessageCardCacheService {
  final Box<MessageCard> _box = Hive.box<MessageCard>('messageCards');
  final MessageCardClickCountService? _clickCountService;

  MessageCardCacheService([this._clickCountService]);

  //parameterless constructor for clearing the cache of all profiles
  MessageCardCacheService.forClearCacheAll() : _clickCountService = null;

  ///method to save a messageCard to the local cache
  Future<void> saveMessageCard(MessageCard messageCard, String profileId) async {
    print('saving messageCard to the cache');
    //set the profile id for the messageCard so that it is unique in the cache
    messageCard.profileId = profileId;
    await _box.put('${profileId}_${messageCard.messageCardId}', messageCard);
  }

  ///method to retrieve a messageCard from the local cache by its Id and profileId
  MessageCard? getMessageCard(String messageCardId, String profileId) {
    return _box.get('${profileId}_$messageCardId');
  }

  ///method to retrieve messageCards by categoryId
  /// and profileId from the local cache
  List<MessageCard> getMessageCardsByCategory(int categoryId, String profileId) {
    print('getting from cache by category');
    return _box.values
        .where(
            (card) => card.categoryId == categoryId && card.profileId == profileId
    ).toList();
  }

  ///method to retrieve all messageCards from the local cache for a profileId
  List<MessageCard> getAllMessageCards(String profileId) {
    return _box.values.where(
            (card) => card.profileId == profileId
    ).toList();
  }

  ///method to clear the local cache for the specified profile
  Future<void> clearCacheOfProfile(String profileId) async {
    var keysToDelete = _box
        .keys
        .where((key) => key.startsWith(profileId))
        .toList();
    await _box.deleteAll(keysToDelete);
  }

  ///method to clear the local cache for all profiles
  ///and delete associated image files
  Future<void> clearCacheAll() async {
    //iterate through all cached message cards
    for (var card in _box.values) {
      //check if the card has a localImagePath
      if(card.localImagePath != null) {
        final imageFile = File(card.localImagePath!);
        if (await imageFile.exists()) {
          //delete the image path if it exists
          await imageFile.delete();
        }
      }
    }
    //now clear the box box of all data
    await _box.clear();
  }

  ///method to delete a messageCard from the cache and its associated image from
  ///device memory
  Future<void> deleteMessageCard(String messageCardId, String profileId) async {
    //make the key using the messageCard and profileId
    String cacheKey = '${profileId}_$messageCardId';
    //get the messageCard from the cache
    MessageCard? card = _box.get(cacheKey);

    if(card != null) {
      //remove the associated image file if it exists
      if( card.localImagePath != null && card.localImagePath!.isNotEmpty) {
        final imageFile = File(card.localImagePath!);
        if(imageFile.existsSync()) {
          await imageFile.delete();
          print("deleted image file: ${card.localImagePath}");
        }
      }
      //remove the messageCard from the hive box
      await _box.delete(cacheKey);
      print("deleted message card from cache: $cacheKey");
    }else {
      print("message card not found in cache with key: $cacheKey");
    }
  }


  ///method to update the selection count of a MessageCard
  Future<void> updateSelectionCount(String messageCardId, String profileId) async {
    var card = getMessageCard(messageCardId, profileId);
    if(card != null) {
      card.selectionCount += 1;
      //update count in cache
      await saveMessageCard(card, profileId);
      //update count on firestore
      await _clickCountService?.selectCard(card);
    }
  }

  ///get top selected MessageCards from the local cache
  List<MessageCard> getTopSelectedCardsFromCache(String profileId) {
    var cards = _box
        .values
        .where((card) => card.profileId == profileId)
        .toList();
    cards.sort((a, b) => b.selectionCount.compareTo(a.selectionCount));
    return cards.take(12).toList();
  }

  ///method to save the profile locally and update the messageCard
  ///with local file path
  /// [messageCard] - The MessageCard object to be updated.
  /// [profileId] - The ID of the profile to associate with the image.
  /// [imageUrl] - The URL of the image to be downloaded and saved locally.
  Future<void> saveImageFileLocally(MessageCard messageCard, String profileId, String imageUrl) async {
    //get the local application documents directory
    final appDir = await getApplicationDocumentsDirectory();
    
    //determine the file extension from the url
    String extension = path.extension(imageUrl).replaceAll('.', '');
    //create a unique name for the image using the profile and messageCardId
    final fileName = '${profileId}_${messageCard.messageCardId}.$extension';
    //download the image file from the provided url
    final response = await http.get(Uri.parse(imageUrl));

    if(response.statusCode == 200) {
      // Save the downloaded image file to the local directory. only id status 200
      final savedImage = File('${appDir.path}/$fileName');
      await savedImage.writeAsBytes(response.bodyBytes);

      //update the messageCard object with the local image path
      messageCard.localImagePath = savedImage.path;
      //save the updated messageCard to the cache
      await saveMessageCard(messageCard, profileId);
    }else {
      print('failed to download the image from $imageUrl');
    }

  }
}