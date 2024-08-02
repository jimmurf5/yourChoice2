import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:your_choice/models/message_card.dart';

/// A widget that represents a single message card item.
///
/// The `MessageCardItem` widget displays a message card with an image and a title.
/// The image can be either an SVG or a standard image format (e.g., JPG, PNG).
/// The widget handles both types of images using a ternary operator to check the file extension.
/// If the image is loading, a `CircularProgressIndicator` is displayed.
/// The title is displayed below the image, centered and styled with a bold font.
///
class MessageCardItem extends StatelessWidget {
  final MessageCard messageCard;

  const MessageCardItem({
    required this.messageCard,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card (
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //a ternary operate to handle possibility of imageUrl
            //being svg or jpg
            (messageCard.imageUrl.endsWith('svg'))
            ? SvgPicture.network(
              messageCard.imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(20.0),
                child: const CircularProgressIndicator(),
              ),
            )
            : Image.network(
              messageCard.imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    child: const CircularProgressIndicator(),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              messageCard.title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            )
          ],
        ),
      ),
    );
  }
}