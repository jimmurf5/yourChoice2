import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:your_choice/models/message_card.dart';

/// A widget that represents a single message card item.
///
/// The `MessageCardItem` widget displays a message card with an image and a title.
/// It supports both local images and images from a network.
/// It handles SVG files or standard image format (e.g. JPG).
/// The widget first attempts to load the image from a local file path if provided.
/// If not provided, it falls back to loading the image from a URL.
/// If the image is loading, a `CircularProgressIndicator` is displayed.
/// The title is displayed below the image, centered and styled with a bold font.
///
class MessageCardItem extends StatelessWidget {
  final MessageCard messageCard;


  const MessageCardItem({
    required this.messageCard,
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    bool useLocalPath =
        messageCard.localImagePath != null && messageCard.localImagePath!.isNotEmpty;

    if (useLocalPath && !File(messageCard.localImagePath!).existsSync()) {
      // If the local image file doesn't exist, fall back to using the URL
      useLocalPath = false;
    }

    return Card(
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useLocalPath)
            // Local image path exists and is valid
              _buildImageFromFile(messageCard.localImagePath!)
            else
            // Fallback to image URL
              _buildImageFromNetwork(messageCard.imageUrl),
            const SizedBox(height: 8),
            Text(
              messageCard.title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This widget builds the image widget from a local file,
  // handling both SVG and standard formats
  Widget _buildImageFromFile(String localImagePath) {
    if (localImagePath.endsWith('svg')) {
      return SvgPicture.file(
        File(localImagePath),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        placeholderBuilder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(20.0),
          child: const CircularProgressIndicator(),
        ),
      );
    } else {
      return Image.file(
        File(localImagePath),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: const Icon(Icons.error),
          );
        },
      );
    }
  }

  // This widget builds the image widget from a network URL,
  // handling both SVG and standard formats
  Widget _buildImageFromNetwork(String imageUrl) {
    if (imageUrl.endsWith('svg')) {
      return SvgPicture.network(
        imageUrl,
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        placeholderBuilder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(20.0),
          child: const CircularProgressIndicator(),
        ),
      );
    } else {
      return Image.network(
        imageUrl,
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: const CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }
}
