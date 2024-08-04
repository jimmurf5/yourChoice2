import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choice/models/message_card.dart';

/// A service class that handles Firestore operations related to incrementing
/// the selection count of MessageCards for a specific user profile.
class MessageCardClickCountService {
  final String profileId;
  //declare an instance of firestore to interact with the db
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MessageCardClickCountService({required this.profileId});

  /// Method to retrieve and increment the selection count of a
  /// selected MessageCard from Firestore
  ///
  /// This method fetches the specified MessageCard from Firestore
  /// , increments its selection count,
  /// and updates the document in Firestore.
  ///
  /// [card] - The MessageCard object to be selected.
  Future<void> selectCard(MessageCard card) async {

    //create and store a reference
    CollectionReference cardCollection = _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('messageCards');

    // Query for the document matching the cards ID
    QuerySnapshot querySnapshot = await cardCollection
        .where('messageCardId', isEqualTo: card.messageCardId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference cardRef = querySnapshot.docs.first.reference;


      // Run a Firestore transaction to update the selection count
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(cardRef);

        // Cast the snapshot data to a Map
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        // Check if data is null
        if (data == null) {
          print("Error: Data is null for document with ID ${card.messageCardId}");
          return;
        }

        int newCount = (data['selectionCount'] ?? 0) + 1;
        print("Current selection count: ${data['selectionCount'] ?? 0}, New selection count: $newCount");
        transaction.update(cardRef, {'selectionCount': newCount});
        /* Update the local count in the MessageCard object.
           This might not be necessary,
           could remove later if not needed */
        card.selectionCount = newCount;
      }).then((value) {
        print("Transaction successfully committed.");
      }).catchError((error) {
        print("Failed to update selection count: $error");
      });
    } else {
      print("Error: Document with ID ${card.messageCardId} not found.");
    }
  }

}
