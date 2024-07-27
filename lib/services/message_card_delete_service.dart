import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// This service provides a method to delete a message card given its profileId
///,messageCardId, categoryId and imageUrl.
///It interacts with Firestore to perform the deletion operation.
class MessageCardDeleteService {
  //store an instance of the firebase firestore to access the db, in a var
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> deleteMessageCard(String profileId, String messageCardId, int categoryId, String imageUrl) async {
    print('message card delete service called for profileId $profileId cardId $messageCardId');
    try{
      //first find the document with the given MessageCardId
      QuerySnapshot querySnapshot = await _firestore
          .collection('profiles')
          .doc(profileId)
          .collection('messageCards')
          .where('messageCardId', isEqualTo: messageCardId)
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

        if(categoryId == 2) {
          //delete the image from firestore storage if its a unique image
          await _deleteImageFromStorage(imageUrl);
        }

        print('Message card $messageCardId deleted successfully');
      }else{
        print('Message card $messageCardId not found');
      }

    }catch (e) {
      print('Failed to delete message card $messageCardId: $e');
      rethrow;
    }
  }

  ///private method
  ///deletes an image from firestore storage
  ///takes the imageUrl as a parameter
  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      //create a reference to the file to delete using the imageUrl
      Reference storageRef = _storage.refFromURL(imageUrl);

      //delete the file
      await storageRef.delete();
    } catch (e) {
      print('Failed to delete the image $imageUrl');
    }
  }
}