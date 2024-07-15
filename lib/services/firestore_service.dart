import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/models/category.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTemplateMessageCards(List<MessageCard> templates) async {
    CollectionReference templatesCollection = _db.collection('templates');

    for (MessageCard template in templates) {
      await templatesCollection.add(template.toMap());
    }

    print('Templates have been added successfully.');
  }

  Future<void>addCategories(List<Category> categories) async {
    CollectionReference categoriesCollection = _db.collection('categories');

    for(Category category in categories){
      await categoriesCollection.add(category.toMap());
    }

    print('Categories have been added successfully');
  }

  Future<void> seedData(List<MessageCard> templates, List<Category> categories) async {
    await addTemplateMessageCards(templates);
    await addCategories(categories);

    print('All data has been seeded successfully.');
  }

  /// method to duplicate seeded data from firestore which contains messageCards for AAC
  /// duplicate data is associated with newly created profile allowing future customisation
  Future<void> duplicateSeededDataForNewProfile(String profileId) async {
    CollectionReference templatesCollection = _db.collection('templates');
    CollectionReference profilesMessageCardsCollection = _db.collection('profiles').doc(profileId).collection('messageCards');

    //fetch all templates
    QuerySnapshot templatesSnapshot = await templatesCollection.get();

    // Duplicate each template and add to the profile's messageCards subcollection
    for (QueryDocumentSnapshot<Object?> templateDoc in templatesSnapshot.docs) {
      Map<String, dynamic> templateData = templateDoc.data() as Map<String, dynamic>;

      await profilesMessageCardsCollection.add(templateData);
    }
    print('Seeded data has been duplicated for the new profile.');
  }
}

