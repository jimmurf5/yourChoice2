import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/repositories/tree_repository.dart';
import 'package:your_choice/screens/display_tree.dart';
import 'package:your_choice/widgets/logo_title_row.dart';
import 'create_tree.dart';

/// The ManageTrees screen allows users to view, create, and manage decision trees
/// associated with a specific profile.
///
/// This screen includes:
/// - A button for creating new decision trees (available only in user mode).
/// - A list of current decision trees, each with options to view or delete the tree.
/// - The ability to restore deleted trees via an undo option.
///
/// The `ManageTrees` widget receives:
/// - [profileId]: The ID of the profile for which the decision trees are being managed.
/// - [isUserMode]: A boolean indicating whether the current mode is user mode (true)
///   or profile mode (false). Certain functionalities like creating and deleting trees
///   are available only in user mode.
///
/// The widget utilizes `TreeRepository` to handle all interactions with Firestore,
/// ensuring a clean separation between UI logic and data access logic.
class ManageTrees extends StatefulWidget {
  final String profileId;
  final bool isUserMode;

  const ManageTrees({super.key, required this.profileId, required this.isUserMode});

  @override
  State<ManageTrees> createState() {
    return _ManageTreesState();
  }
}

class _ManageTreesState extends State<ManageTrees> {
  final TreeRepository _treeRepository = TreeRepository(); // Initialize the tree repository

  /// Handles the deletion of a tree and shows a SnackBar with an undo option.
  ///
  /// Parameters:
  /// - [profileId] The ID of the profile to which the tree belongs.
  /// - [treeId] The ID of the tree to be deleted.
  /// - [deletedTree] A map containing the tree data for possible restoration.
  Future<void> _handleTreeDeletion(String profileId, String treeId, Map<String, dynamic> deletedTree) async {
    try {
      await _treeRepository.deleteTree(profileId, treeId);

      Future.microtask(() {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 10),
            content: const Text('Tree deleted successfully'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // Restore the deleted tree using the tree repo to communicate with Firestore
                // passing treeId, profileId and deleted data for restoration
                _treeRepository.restoreTree(profileId, treeId, deletedTree);
              },
            ),
          ),
        );
      });
    } catch (error) {
      Future.microtask(() {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete tree')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Dynamically display title in AppBar depending if in user mode or not
        title: LogoTitleRow(
            logoWidth: 40,
            logoHeight: 40,
            titleText: widget.isUserMode ? 'Manage Trees' : 'Decision Trees',
            textSize: 30,
            spacerWidth: 10
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Only allow users to create trees, not profiles
            if (widget.isUserMode)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTree(profileId: widget.profileId),
                    ),
                  );
                },
                icon: const Icon(FontAwesomeIcons.tree),
                label: const Text("Create Tree"),
              ),
            const SizedBox(height: 20),
            const Text(
              'Current Decision Trees',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Call the tree repository to get trees from Firebase
                stream: _treeRepository.fetchTrees(widget.profileId),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No trees found');
                  }
                  final trees = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: trees.length,
                    itemBuilder: (context, index) {
                      // Store each individual snapshot in a var
                      DocumentSnapshot tree = trees[index];
                      // Store the treeId
                      String treeId = tree.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          tileColor: Theme.of(context).highlightColor, // Background color for the tile
                          title: Text('${tree['treeTitle']}'),
                          subtitle: Column(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  // Navigate to displayTree and send the treeSnapshot selected
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DisplayTree(
                                        treeSnapshot: tree,
                                        profileId: widget.profileId,
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer, // Text color
                                  backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Button background color
                                ),
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                          // Only allow the deletion option in user mode controlled with bool check and ternary
                          trailing: widget.isUserMode
                              ? IconButton(
                            onPressed: () async {
                              // Store tree details for recall if desired
                              final deletedTree = tree.data() as Map<String, dynamic>;

                              await _handleTreeDeletion(widget.profileId, treeId, deletedTree);
                            },
                            icon: const Icon(Icons.delete),
                          )
                              : null, // Delete will not display in profile mode
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
