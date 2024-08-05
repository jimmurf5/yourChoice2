import 'package:cloud_firestore/cloud_firestore.dart';

/// TreeRepository handles all Firestore interactions related to decision trees.
///
/// This repository provides methods to fetch, delete, and restore decision trees
/// associated with a specific profile.
class TreeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTree(String profileId, Map<String, dynamic> treeData) {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('trees')
        .add(treeData);
  }

  /// Fetches a stream of decision trees for a given profile ID.
  ///
  /// [profileId] - The ID of the profile to fetch decision trees for.
  ///
  /// Returns a stream of query snapshots containing the decision trees.
  Stream<QuerySnapshot> fetchTreesAsQueryStream(String profileId) {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('trees')
        .snapshots();
  }

  /// Fetches a list of maps of decision trees for a given profile ID.
  ///
  /// [profileId] - The ID of the profile to fetch decision trees for.
  ///
  /// Returns a list of maps containing the decision trees.
  Future<List<Map<String, dynamic>>> fetchTreesAsList(String profileId) async {
    //reference the trees collection for the profileId
    var treeCollection = _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('trees');

    //get all docs in the trees collection
    var treeSnapshot = await treeCollection.get();

    //map each doc in the snapshot to its data and return as a list
    return treeSnapshot.docs.map((doc) =>
        doc.data()).toList();
  }

  /// Deletes a decision tree for a given profile ID and tree ID.
  ///
  /// [profileId] - The ID of the profile to which the tree belongs.
  /// [treeId] - The firestore ID of the tree to be deleted.
  ///
  /// Returns a future that completes when the tree is deleted.
  Future<void> deleteTree(String profileId, String treeId) async {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('trees')
        .doc(treeId)
        .delete();
  }

  /// Restores a previously deleted decision tree.
  ///
  /// [profileId] - The ID of the profile to which the tree belongs.
  /// [treeId] - The firestore ID of the tree to be restored.
  /// [treeData] - A map containing the tree data to be restored.
  ///
  /// Returns a future that completes when the tree is restored.
  Future<void> restoreTree(String profileId, String treeId, Map<String, dynamic> treeData) {
     return _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('trees')
        .doc(treeId)
        .set(treeData);
  }
}