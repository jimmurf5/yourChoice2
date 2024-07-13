

class MessageCard {
  final String title;
  final String imageUrl;
  final int categoryId;

  const MessageCard({
    required this.title,
    required this.imageUrl,
    required this.categoryId
  });

  // Method to convert MessageCard object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
    };
  }

  //  method to create MessageCard object from a Map
  static MessageCard fromMap(Map<String, dynamic> map) {
    return MessageCard(
      title: map['title'],
      imageUrl: map['imageUrl'],
      categoryId: map['categoryId'],
    );
  }

}