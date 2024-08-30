import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:your_choice/models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  /// A widget that represents a single category item.
  ///
  /// The `CategoryItem` widget displays a category with an image and a title.
  /// The image is loaded from a network URL and shown using the `SvgPicture` widget.
  /// The widget also accepts a localImagePath if the image is saved to the device
  /// If the image is loading, a `CircularProgressIndicator` is displayed.
  /// The title is displayed below the image, centered and styled with a bold font.
  ///
  /// This widget is intended to be used as a child in a scrollable list
  /// to allow users to select and view different categories.
  const CategoryItem({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    //store the presence of a local path in the category object as a bool
    bool useLocalPath =
        category.localImagePath != null && category.localImagePath!.isNotEmpty;
    return Card(
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useLocalPath && File(category.localImagePath!).existsSync())
              SvgPicture.file(
                File(category.localImagePath!),
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const CircularProgressIndicator(),
                ),
              )
            else
              SvgPicture.network(
                category.imageUrl,
                height: 80.0,
                width: 80.0,
                fit: BoxFit.cover,
                placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const CircularProgressIndicator(),
                ),
              ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
