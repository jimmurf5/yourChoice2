import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choice/models/message_card.dart';

class MessageCardService {
  final String profileId;
  //declare an instance of firestore to interact with the db
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MessageCardService({required this.profileId});

  Future<void> selectCard(MessageCard card) async {
    CollectionReference cardCollection = _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards');

    print("Card ID: ${card.messageCardId}");
    print("Profile ID: $profileId");

    // Query for the document
    QuerySnapshot querySnapshot = await cardCollection
        .where('messageCardId', isEqualTo: card.messageCardId)
        .limit(1)
        .get();

    print("Query Snapshot Length: ${querySnapshot.docs.length}");

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference cardRef = querySnapshot.docs.first.reference;

      // Print the document reference path
      print("Document Reference Path: ${cardRef.path}");

      // Run a Firestore transaction to update the selection count
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(cardRef);

        // Print the entire snapshot to see what data is being retrieved
        print("Snapshot data: ${snapshot.data()}");

        // Document exists, increment the selection count
        print("Document exists within transaction. Incrementing selection count.");
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data == null) {
          print("Error: Data is null for document with ID ${card.messageCardId}");
          return;
        }

        int newCount = (data['selectionCount'] ?? 0) + 1;
        print("Current selection count: ${data['selectionCount'] ?? 0}, New selection count: $newCount");
        transaction.update(cardRef, {'selectionCount': newCount});
        // Update the local count in the MessageCard object. This might not be necessary,
        // could remove later if not needed
        card.selectionCount = newCount;
      }).then((value) {
        print("Transaction successfully committed.");
      }).catchError((error) {
        print("Failed to update selection count: $error");
      });
    } else {
      print("Error: Document with ID ${card.messageCardId} not found.");
    }

    await updateHistoryCategory();
  }

  //return the top 12 selected messageCards
  Future<List<MessageCard>> updateHistoryCategory() async {
    print("Updating history category with top 12 selected message cards.");
    //query the db for the top 12 selected message cards
    QuerySnapshot querySnapshot = await _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards')
        .orderBy('selectionCount', descending: true)
        .limit(12)
        .get();

    //map each doc in the query snapshot to a message card
    List<MessageCard> topCards = querySnapshot.docs
        .map((doc) => MessageCard.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    print("Top 12 selected message cards updated.");
    return topCards;
  }
}
