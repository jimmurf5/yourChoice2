import 'package:flutter/material.dart';
import 'package:your_choice/models/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              category.imageUrl,
              height: 80.0,
              width: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
                category.title,
                textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}