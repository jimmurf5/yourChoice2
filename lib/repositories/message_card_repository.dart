import 'package:cloud_firestore/cloud_firestore.dart';

/// A repository class that handles Firestore operations related to
/// message cards and categories.
///
/// This class abstracts away the details of Firestore interactions and provides
/// an internal API for the rest of the application to interact with
/// the Firestore database.
/// It includes methods for fetching message cards and categories from
/// the Firestore database.
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

}
