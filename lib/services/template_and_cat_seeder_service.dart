import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/models/category.dart';

/// A service class that handles the seeding of message card templates
/// and categories to Firestore.
class TemplateAndCatSeederService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adds a list of MessageCard templates to the Firestore 'templates' collection.
  /// ///
  /// This method takes a list of MessageCard objects, converts each one
  /// to a map using the `toMap` method, and then adds each map to the 'templates'
  /// collection in Firestore.
  ///
  /// [templates] - A list of MessageCard objects to be added to Firestore.
  Future<void> addTemplateMessageCards(List<MessageCard> templates) async {
    CollectionReference templatesCollection = _firestore.collection('templates');

    for (MessageCard template in templates) {
      await templatesCollection.add(template.toMap());
    }

    print('Templates have been added successfully.');
  }

  /// Adds a list of categories to the Firestore 'categories' collection.
  ///
  /// This method takes a list of Category objects, converts each one to a map
  /// using the `toMap` method, and then adds each map to the 'categories'
  /// collection in Firestore.
  ///
  /// [categories] - A list of Category objects to be added to Firestore.
  Future<void>addCategories(List<Category> categories) async {
    CollectionReference categoriesCollection = _firestore.collection('categories');

    for(Category category in categories){
      await categoriesCollection.add(category.toMap());
    }

    print('Categories have been added successfully');
  }

  /// Seeds both message card templates and categories to Firestore.
  ///
  /// This method calls the `addTemplateMessageCards` and `addCategories` methods
  /// to add lists of MessageCard and Category objects to their respective
  /// collections in Firestore.
  ///
  /// [templates] - A list of MessageCard objects to be added to Firestore.
  /// [categories] - A list of Category objects to be added to Firestore.
  Future<void> seedData(List<MessageCard> templates, List<Category> categories) async {
    await addTemplateMessageCards(templates);
    await addCategories(categories);

    print('All data has been seeded successfully.');
  }

}

