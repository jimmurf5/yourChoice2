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
  File? _takenImage;

  void _takePicture() async {
    //create a new image picker object by instantiating the image picker class
    final imagePicker = ImagePicker();
    //call the pick image method
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    //convert return Xfile to file and assign to taken image if not null
    //and set state to update the UI
    setState(() {
      _takenImage = File(pickedImage.path);
    });

    //execute on picked image and pass file containing taken image
    widget.onPickedImage(_takenImage!);
  }

  @override
  Widget build(BuildContext context) {
    //render button conditionally, if taken image not null, preview the image
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      onPressed: _takePicture,
      label: const Text('Take Picture'),
    );

    //wrap in gesture detector to allow image to be tapped and retaken
    if (_takenImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _takenImage!,
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
