import 'package:your_choice/repositories/tree_repository.dart';

///a class to communicate decision tree related datas with firebase
class TreeService {
  final TreeRepository _treeRepository = TreeRepository();


  /// [profileId] - The ID of the profile to which the tree belongs.
  /// [treeTitle] - The title of the decision tree.
  /// [questions] - A list of maps representing the questions and answers in the tree.
  ///
  /// This method creates a map with the tree title and questions, then delegates
  /// the actual Firestore interaction to the TreeRepository.
  Future<void> constructTree(String profileId, String treeTitle, List<Map<String, dynamic>> questions) async {

    //create a map, adding the title to the questions and answers
    try{
      Map<String, dynamic> treeData = {
        'treeTitle': treeTitle,
        'questions': questions
      };

      // Save the tree data using the repository
      await _treeRepository.saveTree(profileId, treeData);

    } catch (ex) {
      throw Exception('Failed to save the decision tree: $ex');
    }
  }

}