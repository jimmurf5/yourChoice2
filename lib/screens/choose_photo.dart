import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/image_upload_service.dart';

class ChoosePhoto extends StatefulWidget {
  final String profileId;

  const ChoosePhoto({required this.profileId, super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChoosePhotoState();
  }
}

class _ChoosePhotoState extends State<ChoosePhoto> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Choose Photo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Card Title'),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            //ImageInput(
             // onPickedImage: (pickedImage) {
             //   print('Image picked: ${pickedImage.path}');
              //  setState(() {
             //     _takenImage = pickedImage;
             //   });
             // },
           // ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              // Send image to file store and store the storage ref
              onPressed: () {
                print('Create Card button pressed');
                //_uploadImage();
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

