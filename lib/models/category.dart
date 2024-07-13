class Category {
  final String title;
  final String imageUrl;
  final int categoryId;

  const Category({
    required this.title,
    required this.imageUrl,
    required this.categoryId
  });

  //method to convert category object to a map
  Map<String, dynamic> toMap() {
    return {
      'title' : title,
      'imageUrl' : imageUrl,
      'categoryId' : categoryId,
    };
  }

  //  method to create Category object from a Map
  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      title: map['title'],
      imageUrl: map['imageUrl'],
      categoryId: map['categoryId'],
    );
  }
}