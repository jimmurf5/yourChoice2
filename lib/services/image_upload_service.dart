import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../repositories/message_card_repository.dart';

/// Class to handle image uploads and call method to save data to firestore
class ImageUploadService {
  // Declare var to communicate with Firebase
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Repository to handle Firestore operations initialised
  final MessageCardRepository _messageCardRepository = MessageCardRepository();
  // Instantiate UUID to make unique IDs
  final uuid = const Uuid();

  /// Method to upload an image and save associated data to Firestore
  /// This method uploads an image to Firebase Storage,retrieves the URL
  /// of the uploaded image, and then calls a method
  /// to save the image URL and other associated data to Firestore.
  ///
  /// /// Parameters:
  ///  [image] File object representing the image to be uploaded
  ///  [title] Title of the message card
  ///  [profileId] ID of the profile to which the message card belongs
  Future<void> upLoadImageAndSaveData(File image, String title, String profileId) async {
    try {
      // Generate a unique ID for the image
      final String uniqueImageId = uuid.v4();

      // Create a reference to the storage location in Firebase Storage
      final storageRef = _storage
          .ref()
          .child('profile_images')
          .child('${profileId}_$uniqueImageId.jpg');

      // Upload the image to Firebase Storage
      await storageRef.putFile(image);

      // Get the image URL from Firebase Storage
      final imageUrl = await storageRef.getDownloadURL();

      // Save the image URL and other details to Firestore using the repository
      await _messageCardRepository.saveMessageCardData(profileId, title, imageUrl, uniqueImageId);
    } catch (error) {
      rethrow;
    }
  }
}
