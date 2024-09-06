import 'package:hive/hive.dart';

part 'category.g.dart';

///  A model class representing a category in the system.
///  This class is used to store information about a category.
///  Also provided methods to convert a category object to a map and to
///  create a category object from a map
@HiveType(typeId: 1)
class Category {

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final int categoryId;

  @HiveField(3)
  String? localImagePath;

  Category({
    required this.title,
    required this.imageUrl,
    required this.categoryId,
    this.localImagePath
  });

  //method to convert category object to a map
  Map<String, dynamic> toMap() {
    return {
      'title' : title,
      'imageUrl' : imageUrl,
      'categoryId' : categoryId,
      if (localImagePath != null) 'localImagePath': localImagePath,
    };
  }

  //  method to create Category object from a Map
  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      title: map['title'],
      imageUrl: map['imageUrl'],
      categoryId: map['categoryId'],
      localImagePath: map['localImagePath'],
    );
  }
}