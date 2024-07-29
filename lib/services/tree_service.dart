import 'package:cloud_firestore/cloud_firestore.dart';

class TreeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTree(String profileId, String treeTitle, List<Map<String, dynamic>> questions) async {

    try{
      Map<String, dynamic> treeData = {
        'treeTitle': treeTitle,
        'questions': questions
      };

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