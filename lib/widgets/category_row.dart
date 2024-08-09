import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:your_choice/repositories/message_card_repository.dart';
import 'package:your_choice/services/hive/category_cache_service.dart';
import '../models/category.dart';
import 'category_item.dart';

/// A widget that displays a horizontally scrolling row of categories.
/// It fetches the categories from Firestore and allows the user to select a category.
/// When a category is selected, it speaks the category title using text-to-speech (TTS)
/// and triggers the `onCategorySelected` callback to notify the parent widget.
///
class CategoryRow extends StatelessWidget {
  final FlutterTts flutterTts;
  final Function(int) onCategorySelected;
  //initialise an instance of the message card repo
  final MessageCardRepository _messageCardRepository = MessageCardRepository();
  final CategoryCacheService _categoryCacheService = CategoryCacheService();

  CategoryRow(
      {super.key, required this.flutterTts, required this.onCategorySelected});

  /// Widget to build a list view of categories
  /// Returns a list view of category items
  ///
  /// Parameter [categories] - takes a list of Category objects
  Widget _buildCategoryListView(List<Category> categories) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: GestureDetector(
              //set the category on tap of any of the scrollable categories
              onTap: () async {
                print("Selected Category ID: ${category.categoryId}");
                onCategorySelected(category.categoryId);
                //read out the category of the messageCard on tap
                await flutterTts.speak(category.title);
              },
              child: CategoryItem(
                  category: category), //use category item widget to display categories
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //store the cached categories
    final cachedCategories = _categoryCacheService.getAllCategories();
    return Container(
      color: Theme.of(context).colorScheme.onSecondary,
      child: SizedBox(
        height: 120.0,
        /*ternary on the cached cards (if empty or not)
        * if empty query firestore*/
        child: cachedCategories.isNotEmpty
            ? _buildCategoryListView(cachedCategories)
            : StreamBuilder<QuerySnapshot>(
          stream: _messageCardRepository.fetchCategories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final categories = snapshot.data!.docs.map((doc) {
              return Category.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();

            for (var category in categories) {
              _categoryCacheService.saveCategory(category);
            }

            return _buildCategoryListView(categories);
          },
        ),
      ),
    );
  }
}