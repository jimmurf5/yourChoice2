import 'package:cloud_firestore/cloud_firestore.dart';

///a class to communicat decision tree related dats with firebase
class TreeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Method to save a decision tree to firebase under the specified profileId
  Future<void> saveTree(String profileId, String treeTitle, List<Map<String, dynamic>> questions) async {

    //create a map, adding the title to the questions and answers
    try{
      Map<String, dynamic> treeData = {
        'treeTitle': treeTitle,
        'questions': questions
      };

      //save to firebase
      await _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('trees')
        .add(treeData);

    } catch (ex) {
      throw Exception('Failed to save the decision tree: $ex');
    }
  }

}