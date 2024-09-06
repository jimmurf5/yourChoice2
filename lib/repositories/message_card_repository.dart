import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choice/services/hive/message_card_cache_service.dart';
import 'package:your_choice/services/image_delete_service.dart';

import '../models/message_card.dart';

/// A repository class that handles Firestore operations related to
/// message cards and categories.
///
/// This class abstracts away the details of Firestore interactions and provides
/// an interface for the rest of the application to interact with
/// the Firestore database.
/// It includes methods for fetching message
/// cards (by category, singly or the top selected) and categories from
/// the Firestore database. Also saving and deleting messageCards.
class MessageCardRepository {
  final FirebaseFirestore _firestore;
  final MessageCardCacheService _cacheService;
  final ImageDeleteService imageDeleteService;

  /// Constructor that allows dependency injection with optional parameters.
  /// If parameters are not provided, it will default to the instances.
  MessageCardRepository({
    FirebaseFirestore? firestore,
    MessageCardCacheService? cacheService,
    ImageDeleteService? imageDeleteService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _cacheService = cacheService ?? MessageCardCacheService(),
        imageDeleteService = imageDeleteService ?? ImageDeleteService();


  /// Fetches message cards for a given profile and category.
  ///
  /// [profileId] - The ID of the profile to fetch message cards for.
  /// [categoryId] - The ID of the category to filter message cards.
  /// Returns a stream of query snapshots containing the message cards.
  Stream<QuerySnapshot> fetchMessageCards(
      {required String profileId, required int categoryId}) {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots();
  }

  /// Fetches all message cards for a given profile and  across all categories.
  ///
  /// [profileId] - The ID of the profile to fetch message cards for.
  /// Returns a list of maps containing the messageCards.
  Future<List<Map<String, dynamic>>> fetchAllMessageCards(String profileId) async {
    //create a reference to the messageCard collection for our profileId
    var messageCardCollection = _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards');

    //get all documents for the messageCard collection
    var messageCardSnapshot = await messageCardCollection.get();
    //return as a list after mapping each document to its data
    return messageCardSnapshot.docs.map((doc) => doc.data()).toList();
  }

  ///Fetches all categories form firestore
  ///
  /// Returns a stream of category snapshots containing the categories.
  Stream<QuerySnapshot> fetchCategories() {
    return _firestore.collection('categories').snapshots();
  }

  /// Method to save message card data to Firestore
  /// Save to Firestore by creating a message card without using the
  /// messageCard constructor from the messageCard class,
  /// set count to zero and category to 2 (original)
  ///
  /// Parameters:
  ///  [profileId]- ID of the profile to which the message card belongs
  /// [title]- Title of the message card
  /// [imageUrl]- URL of the uploaded image
  /// [uniqueImageId]- Unique ID of the image associated with the message card
  ///
  Future<void> saveMessageCardData(
      String profileId, String title, String imageUrl, String uniqueImageId) async {
    try {

      //create a new messageCard
      MessageCard newMessageCard = MessageCard(
          title: title,
          selectionCount: 0,
          messageCardId: uniqueImageId,
          categoryId: 2,
          imageUrl: imageUrl,
      );

      await _firestore
          .collection('profiles')
          .doc(profileId)
          .collection('messageCards')
          .add(
        newMessageCard.toMap()
      );

      /* Call the messageCardCache service and cache the new messageCard
           locally, to ensure cache is always in sync with firestore */
      await _cacheService.saveImageFileLocally(newMessageCard, profileId, imageUrl);
    } catch (error) {
      rethrow;
    }
  }

  /// Finds a message card by its ID and the profileId
  /// returns a querySnapShot limited to one card
  Future<QuerySnapshot> findMessageCardById(String profileId, String messageCardId) async {
    try {
      return await _firestore
          .collection('profiles')
          .doc(profileId)
          .collection('messageCards')
          .where('messageCardId', isEqualTo: messageCardId)
          .limit(1)
          .get();
    } catch (e) {
      print('Failed to find message card $messageCardId for profile $profileId: $e');
      rethrow;
    }
  }

  /// Retrieves a single message card document from Firestore.
  ///
  /// It returns a `DocumentSnapshot` containing the data of the message card.
  ///
  /// [profileId] - The ID of the profile to which the message card belongs.
  /// [docId] - The document ID of the message card in Firestore.
  ///
  /// Returns a `Future` that resolves to a `DocumentSnapshot` containing the
  /// message card data.
  Future<DocumentSnapshot> fetchOneMessageCard(String profileId, String docId) {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .doc(docId)
        .get();
  }

  /// Method to delete a message card by its document ID
  /// and handles image deletion if needed
  ///
  /// Parameters:
  /// [profileId]- ID of the profile to which the message card belongs
  /// [docId]- the document ID of the messageCard in firestore
  /// [categoryId]- the category the messageCard is associated with
  /// [imageUrl]- the messageCard's image URL
  Future<void> deleteMessageCard(String profileId, String messageCardId, String docId, int categoryId, String imageUrl) async {
    try {
      await _firestore
          .collection('profiles')
          .doc(profileId)
          .collection('messageCards')
          .doc(docId)
          .delete();

      //delete the messageCard from the cache also
      await _cacheService.deleteMessageCard(messageCardId, profileId);

      if(imageUrl.contains('firebasestorage')) {
        /*delete the image from firestore storage if its a unique image
        it may have been re categorised so search for the above phrase in
        the imageUrl, call imageDeleteService and pass the imageUrl
         */
        await imageDeleteService.deleteImageFromStorage(imageUrl);
      }

    } catch (e) {
      print('Failed to delete message card with docId $docId for profile $profileId: $e');
      rethrow;
    }
  }

  /// Retrieves the top 12 selected MessageCards
  ///
  /// This method queries Firestore for the top 12 MessageCards with the
  /// highest selection count and returns them as a list of MessageCard objects.
  ///
  /// Returns a list of the top 12 selected MessageCard objects.
  /// [profileId]- ID of the profile currently in use
  Future<List<MessageCard>> getTopSelectedCards(String profileId) async {
    //query the db for the top 12 selected message cards
    QuerySnapshot querySnapshot = await _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .orderBy('selectionCount', descending: true)
        .limit(12)
        .get();

    //map each doc in the query snapshot to a message card
    List<MessageCard> topCards = querySnapshot.docs
        .map((doc) => MessageCard.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return topCards;
  }

  Future<void> changeCategory(String messageCardId, String profileId, int newCategoryId) async {
    try {
      //find the document id for the message card
      QuerySnapshot querySnapshot = await findMessageCardById(profileId, messageCardId);
      
      if(querySnapshot.docs.isNotEmpty) {
        //get the doc Id
        String docId = querySnapshot.docs.first.id;

        //delete the card from the old category cache
        await _cacheService.deleteMessageCard(messageCardId, profileId);
        
        //update the categoryId field of the messageCard in firestore
        await _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .doc(docId)
        .update({'categoryId': newCategoryId});

        //refresh the cache for the category to ensure its up to date
        await refreshCategoryCallCache(newCategoryId, profileId);

        print('Category changed successfully for card $messageCardId');

      } else {
        print('Message Card with Id $messageCardId not found in the profile $profileId');
      }
    } catch (error) {
      print('Failed to change category for message card $messageCardId');
    }
  }

  Future<void> refreshCategoryCallCache(int categoryId, String profileId) async {
    // Fetch all message cards from Firestore for this category
    QuerySnapshot snapshot = await _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    // Pass the snapshot to the cache service for processing
    await _cacheService.updateCategoryCacheFromSnapshot(snapshot, profileId);
  }

}
