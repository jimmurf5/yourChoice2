import 'package:cloud_firestore/cloud_firestore.dart';

/// A repository class that handles all Firestore operations for the application.
///
/// This class abstracts away the details of Firestore interactions and provides
/// a clean internal API for the rest of the application to interact with
/// the Firestore database.
/// It includes methods for fetching, creating, deleting, and restoring trees,
/// profiles, and message cards in the Firestore database.
class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Profile operations

  /// Creates a new profile in Firestore.
  ///
  /// This method adds a new profile document to the profiles collection.
  ///
  /// [profileData] - A map containing the data for the new profile.
  Future<DocumentReference> createProfile(Map<String, dynamic> profileData) {
    return _firestore.collection('profiles').add(profileData);
  }
}