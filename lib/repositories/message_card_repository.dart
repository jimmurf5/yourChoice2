import 'package:cloud_firestore/cloud_firestore.dart';

/// A repository class that handles Firestore operations related to
/// message cards and categories.
///
/// This class abstracts away the details of Firestore interactions and provides
/// an internal API for the rest of the application to interact with
/// the Firestore database.
/// It includes methods for fetching message cards and categories from
/// the Firestore database. Also saving messageCards
class MessageCardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      await _firestore
          .collection('profiles')
          .doc(profileId)
          .collection('messageCards')
          .add({
        'title': title,
        'selectionCount': 0,
        'messageCardId': uniqueImageId,
        'categoryId': 2,
        'imageUrl': imageUrl
      });
    } catch (error) {
      rethrow;
    }
  }
}
