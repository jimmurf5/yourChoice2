import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choice/models/message_card.dart'; // Update to your actual import path

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTemplateMessageCards(List<MessageCard> templates) async {
    CollectionReference templatesCollection = _db.collection('templates');

    for (MessageCard template in templates) {
      await templatesCollection.add(template.toMap());
    }

    print('Templates have been added successfully.');
  }
}

