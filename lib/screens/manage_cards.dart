import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_choice/services/image_upload_service.dart';
import 'package:your_choice/widgets/image_input.dart';
import 'dart:io';

//define an enum to represent the source of the image
enum ImageSourceOption { camera, gallery }

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
    _titleController.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  Future<void> _uploadImage() async {
    print('Upload Image method called');

    // Make sure that image and title are provided
    if (_takenImage == null || _titleController.text.isEmpty) {
      print('Image or title is missing');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and Image are required.'),
        ),
      );
      return;
    }

    // Make sure the title is not too long
    if (_titleController.text.length > 10) {
      print('Title is too long');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title must be 10 characters or less'),
        ),
      );
      return;
    }

    try {
      print('Attempting to upload image and save data');
      await _imageUploadService.upLoadImageAndSaveData(
        _takenImage!,
        _titleController.text,
        widget.profileId,
      );

      print('Image and data saved successfully');
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
    } catch (error) {
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save image and message!'),
        ),
      );
    }
  }

  // Unified method to pick an image from camera or gallery
  //takes an enum as a parameter
  Future<void> _pickImage(ImageSourceOption option) async {
    final picker = ImagePicker();
    //returns a image source of type camera or gallery
    // depending on imageSourceOption input to the method
    final pickedImage = await picker.pickImage(
      source: option == ImageSourceOption.camera
          ? ImageSource.camera : ImageSource.gallery,
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
        title: const Text('Manage Cards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Go to make custom card, add code here
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
                print('Image picked: ${pickedImage.path}');
                setState(() {
                  _takenImage = pickedImage;
                });
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              // Send image to file store and store the storage ref
              onPressed: () {
                print('Create Card button pressed');
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
