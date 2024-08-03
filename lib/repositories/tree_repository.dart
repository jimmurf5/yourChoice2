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
  Stream<QuerySnapshot> fetchTrees(String profileId) {
    return _firestore
        .collection('profiles')
        .doc(profileId)
        .collection('trees')
        .snapshots();
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