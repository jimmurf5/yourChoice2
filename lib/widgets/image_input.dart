import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final void Function(File pickedImage) onPickedImage;

  const ImageInput({
    super.key,
    required this.onPickedImage
  });

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  //declare variable of type file to hold the taken image
  File? _pickedImage;

  void _pickImage(ImageSource source) async {
    //create a new image picker object by instantiating the image picker class
    final imagePicker = ImagePicker();
    //call the pick image method
    final pickedImage =
        await imagePicker.pickImage(source: source, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    //convert return Xfile to file and assign to picked image if not null
    //and set state to update the UI
    setState(() {
      _pickedImage = File(pickedImage.path);
    });

    //execute on picked image and pass file containing picked image
    widget.onPickedImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    //render buttons for camera and gallery selection
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.camera),
          onPressed: () => _pickImage(ImageSource.camera), // <-- Use _pickImage with ImageSource.camera
          label: const Text('Take Picture'),
        ),
        const SizedBox(height: 45),
        TextButton.icon(
          icon: const Icon(Icons.photo_library),
          onPressed: () => _pickImage(ImageSource.gallery), // <-- Use _pickImage with ImageSource.gallery
          label: const Text('Choose from Gallery'),
        ),
      ],
    );

    //wrap in gesture detector to allow image to be tapped and retaken
    //display the taken image if picked image not null
    if (_pickedImage != null) {
      content = GestureDetector(
        onTap: () => _pickImage(ImageSource.camera),
        child: Image.file(
          _pickedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
