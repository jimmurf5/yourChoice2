import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  const CategoryRow(
      {super.key, required this.flutterTts, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onSecondary,
      child: SizedBox(
        height: 120.0,
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //check to make sure snapshot has data and is not null
              return const Center(child: CircularProgressIndicator());
            }
            final categories = snapshot.data!.docs.map((doc) {
              return Category.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();
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
                          category:
                              category), //use category item widget to display categories
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
