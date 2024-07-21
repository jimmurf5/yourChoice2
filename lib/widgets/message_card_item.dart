import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:your_choice/models/message_card.dart';

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