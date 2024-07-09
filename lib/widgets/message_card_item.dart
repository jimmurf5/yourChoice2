import 'package:flutter/material.dart';
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
            Image.network(
              messageCard.imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              messageCard.title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}