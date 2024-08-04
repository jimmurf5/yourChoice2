import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_card.dart';

/// A repository class that handles Firestore operations related to user profiles.
///
/// This class abstracts away the details of Firestore interactions and provides
/// a internal API for the rest of the application to interact with
/// the Firestore database.
/// It includes methods for fetching, creating, deleting, and restoring
/// profiles in the Firestore database.
class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  /// Creates a new profile in Firestore.
  ///
  /// This method adds a new profile document to the profiles collection.
  ///
  /// [profileData] - A map containing the data for the new profile.
  Future<DocumentReference> createProfile({required Map<String, Object> profileData}) {
    return _firestore.collection('profiles').add(profileData);
  }

  /// Fetches profiles created by a specific user from Firestore.
  ///
  /// This method returns a stream of query snapshots which can be used to listen
  /// for real-time updates to the profiles collection of the specified user.
  ///
  /// [userId] - The ID of the user whose profiles are to be fetched.
  Stream<QuerySnapshot> fetchProfiles({required String userId}){
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
  Future<void> deleteProfile({required String profileId}) {
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
  Future<void> restoreProfile({required String profileId, required Map<String, dynamic> profileData}) {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .set(profileData);
  }

  /// Method to duplicate seeded data from firestore which contains messageCards
  ///
  /// Duplicate data is associated with newly created profile allowing
  /// future customisation
  ///
  /// [profileId] - The ID of the profile to which the new MessageCard
  /// sub-collection will be added
  Future<void> duplicateSeededDataForNewProfile(String profileId) async {
    // Create reference to the 'templates' collection in Firestore
    CollectionReference templatesCollection =
    _firestore
        .collection('templates');

    // Create reference to the 'messageCards' sub-collection
    // within the specified profile's document
    CollectionReference profilesMessageCardsCollection =
    _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards');

    // Fetch all documents from the 'templates' collection
    QuerySnapshot templatesSnapshot = await templatesCollection.get();

    // Iterate over each document in the 'templates' collection
    for (QueryDocumentSnapshot<Object?> templateDoc in templatesSnapshot.docs) {
      Map<String, dynamic> templateData = templateDoc.data() as Map<String, dynamic>;

      //create messageCard object from the map, preserving the messageCardId
      MessageCard messageCard = MessageCard.fromMap(templateData);

      // Add the MessageCard object to the profile's 'messageCards' sub-collection
      await profilesMessageCardsCollection.add(messageCard.toMap());
    }
    print('Seeded data has been duplicated for the new profile.');
  }
}