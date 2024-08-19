import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:your_choice/models/category.dart';

/// A class hosting methods controlling all the logic regarding caching
/// data to the hive 'categories' box
class CategoryCacheService {
  final Box<Category> _box;

  // Constructor with optional box parameter
  CategoryCacheService([Box<Category>? box]) : _box = box ?? Hive.box<Category>('categories');

  ///method to retrieve all categories from the cache
  List<Category> getAllCategories() {
    print('Getting the categories from the cat cache');
    return _box.values.toList();
  }

  Future<void> saveCategory(Category category) async {
    await _box.put(category.categoryId, category);
  }

  /// Method to save the category locally and update the category
  /// with local file path
  ///
  /// [category] - The category object to be updated.
  ///
  Future<void> saveImageFileLocally(Category category) async {
    try {

      //get the local application documents directory
      final appDir = await getApplicationDocumentsDirectory();

      //determine the file extension from the url
      String extension = path.extension(category.imageUrl).replaceAll('.', '');
      //create a unique name for the image using the categoryId
      final fileName = '${category.categoryId}.$extension';
      //download the image file from the provided url
      final response = await http.get(Uri.parse(category.imageUrl));

      if (response.statusCode == 200) {
        // Save the downloaded image file to the local directory. only id status 200
        final savedImage = File('${appDir.path}/$fileName');
        await savedImage.writeAsBytes(response.bodyBytes);

        //update the category object with the local image path
        category.localImagePath = savedImage.path;
        //save the updated category to the cache
        await saveCategory(category);
      } else {
        print('failed to download the image from $category.categoryId');
      }
    } catch (error) {
      print(
          'Error saving image locally for category ${category.categoryId}: $error');
    }
  }

  ///method to clear the local cache for categories and associated images
  Future<void> clearCache() async {
    //iterate through all cached message cards
    for (var category in _box.values) {
      //check if the card has a localImagePath
      if (category.localImagePath != null) {
        final imageFile = File(category.localImagePath!);
        if (await imageFile.exists()) {
          //delete the image path if it exists
          await imageFile.delete();
        }
      }
    }
    //now clear the box box of all data
    await _box.clear();
  }
}
