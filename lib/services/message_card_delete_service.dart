import 'package:cloud_firestore/cloud_firestore.dart';

/// This service provides a method to delete a message card given its profile ID
/// and card ID. It interacts with Firestore to perform the deletion operation.
class MessageCardDeleteService {
  //store an instance of the firebase firestore to access the db, in a var
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteMessageCard(String profileId, String cardId) async {
    print('message card delete service called for profileId $profileId cardId $cardId');
    try{
      //first find the document with the given MessageCardId
      QuerySnapshot querySnapshot = await _firestore
          .collection('profiles')
          .doc(profileId)
          .collection('messageCards')
          .where('messageCardId', isEqualTo: cardId)
          .limit(1)
          .get();

      if(querySnapshot.docs.isNotEmpty) {
        String docId  = querySnapshot.docs.first.id;

        //now delete the doc
        await _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .doc(docId)
        .delete();

        print('Message card $cardId deleted successfully');
      }else{
        print('Message card $cardId not found');
      }

    }catch (e) {
      print('Failed to delete message card $cardId: $e');
      rethrow;
    }
  }
}