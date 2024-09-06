import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'message_card.g.dart';

const uuid = Uuid();

///  A model class representing a message card in the system.
///  This class is used to store information about a message card.
///  Also provided methods to convert a message card object to a map and to
///  create a message card object from a map
@HiveType(typeId: 0)
class MessageCard {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String imageUrl;
  @HiveField(2)
  int categoryId;
  @HiveField(3)
  final String messageCardId;
  @HiveField(4)
  int selectionCount;
  @HiveField(5)
  String? profileId; // Optional profileId
  @HiveField(6)
  String? localImagePath; // optional field for local image file path


  //constructor generates a new id or uses the one provided
  MessageCard({
    String? messageCardId,
    required this.title,
    required this.imageUrl,
    required this.categoryId,
    this.selectionCount = 0,  // initialise the selection count to zero
    this.profileId, //optional profileId
    this.localImagePath,
  }): messageCardId = messageCardId ?? uuid.v4();

  // Method to convert MessageCard object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'messageCardId' : messageCardId,
      'selectionCount' : selectionCount,
      if (profileId != null) 'profileId': profileId, // Include profileId if it's not null
      if (localImagePath != null) 'localImagePath': localImagePath, // Include localImagePath if it's not null
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
      profileId: map['profileId'], // Extract profileId if it exists
      localImagePath: map['localImagePath'], // Extract localImagePath if it exists

    );
  }

}