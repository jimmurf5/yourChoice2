import 'package:cloud_firestore/cloud_firestore.dart';

/// This service provides a method to delete a message card given its profile ID
/// and card ID. It interacts with Firestore to perform the deletion operation.
class MessageCardDeleteService {
  //store an instance of the firebase firestore to access the db, in a var
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteMessageCard(String profileId, String cardId) async {
    try{
      await _firestore
          .collection('profiles')
          .doc(profileId)
          .collection('messageCards')
          .doc(cardId)
          .delete();
      print('Message card $cardId deleted successfully');
    }catch (e) {
      print('Failed to delete message card $cardId: $e');
      rethrow;
    }
  }
}