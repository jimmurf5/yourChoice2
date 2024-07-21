import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

/// Class to handle image uploads and save data to Firestore
class ImageUploadService {
  // Declare vars to communicate with Firebase
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Instantiate UUID to make unique IDs
  final uuid = const Uuid();

  /// Method to upload an image and save associated data to Firestore
  Future<void> upLoadImageAndSaveData(
      File image, String title, String profileId) async {
    try {
      // Generate a unique ID for the image
      final String uniqueImageId = uuid.v4();
      print('Generated uniqueImageId: $uniqueImageId');

      // Create a reference to the storage location in Firebase Storage
      final storageRef = _storage
          .ref()
          .child('profile_images')
          .child('${profileId}_$uniqueImageId.jpg');
      print('Storage reference created: ${storageRef.fullPath}');

      // Upload the image to Firebase Storage
      await storageRef.putFile(image);
      print('Image uploaded to Firebase Storage');

      // Get the image URL from Firebase Storage
      final imageUrl = await storageRef.getDownloadURL();
      print('Image URL from Firebase Storage: $imageUrl');

      // Save the image URL and other details to Firestore
      // by creating a message card without using the messageCard
      // constructor from the messageCard class
      await _firestore
          .collection('profile')
          .doc(profileId)
          .collection('messageCards')
          .add({
        'title': title,
        'selectionCount': 0,
        'messageCardId': uniqueImageId,
        'categoryId': 1,
        'imageUrl': imageUrl
      });
      print('Data saved to Firestore under profileId: $profileId');
    } catch (error) {
      print('Error occurred: $error');
      rethrow;
    }
  }
}
