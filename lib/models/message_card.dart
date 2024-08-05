import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'message_card.g.dart';

const uuid = Uuid();


@HiveType(typeId: 0)
class MessageCard {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String imageUrl;
  @HiveField(2)
  final int categoryId;
  @HiveField(3)
  final String messageCardId;
  @HiveField(4)
  int selectionCount;


  //constructor generates a new id or uses the one provided
  MessageCard({
    String? messageCardId,
    required this.title,
    required this.imageUrl,
    required this.categoryId,
    this.selectionCount = 0   // initialise the selection count to zero
  }): messageCardId = messageCardId ?? uuid.v4();

  // Method to convert MessageCard object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'messageCardId' : messageCardId,
      'selectionCount' : selectionCount,
    };
  }

  //  method to create MessageCard object from a Map
  static MessageCard fromMap(Map<String, dynamic> map) {
    return MessageCard(
      title: map['title'],
      imageUrl: map['imageUrl'],
      categoryId: map['categoryId'],
      messageCardId: map['messageCardId'],
      selectionCount: map['selectionCount'] ?? 0,
    );
  }

}