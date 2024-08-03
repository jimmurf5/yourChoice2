import 'package:firebase_storage/firebase_storage.dart';

/// This service provides a method to delete an image from firestore storage
class ImageDeleteService {
  //store an instance of the firebase storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  ///deletes an image from firestore storage
  ///
  /// Parameter
  ///[imageUrl] - the imageUrl of the image to be deleted
  Future<void> deleteImageFromStorage(String imageUrl) async {
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