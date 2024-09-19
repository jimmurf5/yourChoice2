import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_choice/screens/curate_cards.dart';
import 'package:your_choice/services/image_upload_service.dart';
import 'package:your_choice/widgets/image_input.dart';
import 'dart:io';

import '../widgets/logo_title_row.dart';

//define an enum to represent the source of the image
enum ImageSourceOption { camera, gallery }

/// The ManageCards screen allows users to manage their message cards by
/// providing functionalities to curate existing cards or create new ones.
///
/// This screen includes:
/// - A button to navigate to the CurateCards screen for curating existing cards.
/// - A text field to input the title for a new card.
/// - An image picker to select an image from the camera or gallery.
/// - A button to upload the selected image and save the card data to Firestore.
///
/// The screen uses the ImageUploadService to handle image uploads and
/// saving data to Firestore.
class ManageCards extends StatefulWidget {
  final String profileId;

  const ManageCards({required this.profileId, super.key});

  @override
  State<ManageCards> createState() {
    return _ManageCardsState();
  }
}

class _ManageCardsState extends State<ManageCards> {
  final _titleController = TextEditingController();
  File? _takenImage;
  // Create an instance of the ImageUploadService to handle image uploads
  // and saving data to Firestore
  final ImageUploadService _imageUploadService = ImageUploadService();

  // The dispose method is called automatically when the widget
  // is removed from the widget tree
  @override
  void dispose() {
    _titleController
        .dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  /// Uploads the selected image and saves the card data to Firestore.
  ///
  /// This method performs the following steps:
  /// 1. Validates that both an image and a title are provided.
  /// 2. Ensures that the title is not longer than 13 characters.
  /// 3. Attempts to upload the image and save the card data using the
  ///    ImageUploadService.
  /// 4. Displays a success message upon successful upload and data saving.
  /// 5. Clears the selected image and title from the state after saving.
  /// 6. Navigates back to the previous screen upon successful completion.
  ///
  /// If any validation fails or an error occurs during the upload or saving
  /// process, appropriate error messages are displayed using a SnackBar.
  Future<void> _uploadImage() async {
    // Make sure that image and title are provided
    if (_takenImage == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and Image are required.'),
        ),
      );
      return;
    }

    // Make sure the title is not too long
    if (_titleController.text.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title must be 11 characters or less'),
        ),
      );
      return;
    }

    try {
      await _imageUploadService.upLoadImageAndSaveData(
        _takenImage!,
        _titleController.text,
        widget.profileId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image and message saved successfully!'),
        ),
      );

      // Clear the state after saving
      setState(() {
        _takenImage = null;
        _titleController.clear();
      });
      print('State cleared');

      //pop back to customise profile screen if action successful
      Navigator.of(context).pop();

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save image and message!'),
        ),
      );
    }
  }

  /// Unified method to pick an image from camera or gallery
  /// /// [option] - an enum presenting the source of the
  /// image (camera or gallery).
  Future<void> _pickImage(ImageSourceOption option) async {
    final picker = ImagePicker();
    //returns a image source of type camera or gallery
    // depending on imageSourceOption input to the method
    final pickedImage = await picker.pickImage(
      source: option == ImageSourceOption.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedImage != null) {
      setState(() {
        _takenImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const LogoTitleRow(
          logoWidth: 35,
          logoHeight: 35,
          titleText: 'Manage Cards',
          textSize: 30,
          spacerWidth: 10
      ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                //navigate to curateCards on pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CurateCards(profileId: widget.profileId),
                  ),
                );
              },
              label: const Text('Curate Cards'),
              icon: const Icon(FontAwesomeIcons.usersGear),
            ),
            const SizedBox(height: 70),
            TextField(
              decoration: const InputDecoration(labelText: 'Card Title'),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 50),
            ImageInput(
              onPickedImage: (pickedImage) {
                setState(() {
                  _takenImage = pickedImage;
                });
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              // Send image to file storage and store the storage ref
              onPressed: () {
                _uploadImage();
              },
              icon: const Icon(FontAwesomeIcons.plus),
              label: const Text('Create Card'),
            ),
          ],
        ),
      ),
    );
  }
}