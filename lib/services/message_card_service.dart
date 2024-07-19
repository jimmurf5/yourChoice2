import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choice/models/message_card.dart';


class MessageCardService{
  final String profileId;
  //declare an instance of firestore to interact with the db
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MessageCardService({required this.profileId});

  Future<void> selectCard(MessageCard card) async{
    //create a reference to the specific messageCard selected,
    // in the sub collection of the profile selected using the profileId
    DocumentReference cardRef = _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('MessageCards')
        .doc(card.messageCardId);

    //run a firestore transaction to update the selection count
    await _firestore.runTransaction((transaction)async{
      DocumentSnapshot snapshot = await transaction.get(cardRef);

      //if the doc does not exist, create it with initial data
      if(!snapshot.exists){
        transaction.set(cardRef, card.toMap());
      }else{
        //if the card doc does exist increment the count
        //but first cast from object returned to map with string keys and dynamic values
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        int newCount = (data['selectionCount'] ?? 0) + 1;
        transaction.update(cardRef, {'selectionCount': newCount});
        // Update the local count in the MessageCard object. may not be necessary,
        // could remove later
        card.selectionCount = newCount;
      }
    });

    await updateHistoryCategory();
  }

  //return the top 12 selected messageCards
  Future<List<MessageCard>> updateHistoryCategory() async {
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
    .map((doc)=> MessageCard.fromMap(doc.data() as Map<String, dynamic>))
    .toList();

    return topCards;
  }
}