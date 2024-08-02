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

  /// Fetches profiles created by a specific user from Firestore.
  ///
  /// This method returns a stream of query snapshots which can be used to listen
  /// for real-time updates to the profiles collection of the specified user.
  ///
  /// [userId] - The ID of the user whose profiles are to be fetched.
  Stream<QuerySnapshot> fetchProfiles(String userId){
    return _firestore
        .collection('profiles')
        .where('createdBy', isEqualTo: userId)
        .snapshots();
  }

  /// Deletes a profile for a given user in Firestore.
  ///
  /// This method removes the specified profile document from the profiles
  /// collection.
  ///
  /// [profileId] - The ID of the profile to be deleted.
  Future<void> deleteProfile(String profileId) {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .delete();
  }

  /// Restores a deleted profile for a given user in Firestore.
  ///
  /// This method adds the specified profile document back
  /// to the profiles collection.
  ///
  /// [profileId] - The ID of the profile to be restored.
  /// [profileData] - A map containing the data for the profile to be restored.
  Future<void> restoreProfile(String profileId, Map<String, dynamic> profileData) {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .set(profileData);
  }
}