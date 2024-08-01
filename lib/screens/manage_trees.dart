import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/screens/display_tree.dart';
import 'create_tree.dart';

class ManageTrees extends StatefulWidget {
  final String profileId;
  final bool isUserMode;

  const ManageTrees(
      {super.key, required this.profileId, required this.isUserMode});

  @override
  State<ManageTrees> createState() {
    return _ManageTrees();
  }
}

//a method to return the decision trees from firebase for a profileId
class _ManageTrees extends State<ManageTrees> {
  //create an instance of firestore for use in class
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //method to fetch decision trees from firestore, returns a querySnapshot
  Stream<QuerySnapshot> _fetchTrees() {
    return _firestore
        .collection('profiles')
        .doc(widget.profileId)
        .collection('trees')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        //dynamically display title in appBar depending if in user mode or not
        title: Text(widget.isUserMode ? 'Manage Trees' : 'Decision Trees'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            //only allow users to create trees, not profiles
            if (widget.isUserMode)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateTree(profileId: widget.profileId),
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
                  stream: _fetchTrees(),
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
                          //store each individual snapshot in a var
                          DocumentSnapshot tree = trees[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              tileColor: Theme.of(context)
                                  .highlightColor, // Background color for the tile
                              title: Text('${tree['treeTitle']}'),
                              subtitle: Column(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      /*Navigate to displayTree and send the
                                        treeSnapshot selected */
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
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer, // Text color
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary, // Button background color
                                    ),
                                    child: const Text('Select'),
                                  ),
                                ],
                              ),
                              /*only allow the deletion option in user mode
                                * controlled with bool check and ternary*/
                              trailing: widget.isUserMode
                                  ? IconButton(
                                      onPressed: () async {
                                        //store tree details for recall if desired
                                        final deletedTree =
                                            tree.data() as Map<String, dynamic>;

                                        //delete tree
                                        await _firestore
                                            .collection('profiles')
                                            .doc(widget.profileId)
                                            .collection('trees')
                                            .doc(tree.id)
                                            .delete()
                                            .then((_) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  const Duration(seconds: 10),
                                              content: const Text(
                                                  'Tree deleted successfully'),
                                              action: SnackBarAction(
                                                  label: 'UNDO',
                                                  onPressed: () {
                                                    // Restore the deleted tree
                                                    _firestore
                                                        .collection('profiles')
                                                        .doc(widget.profileId)
                                                        .collection('trees')
                                                        .doc(tree.id)
                                                        .set(deletedTree);
                                                  }),
                                            ),
                                          );
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Failed to delete profile')),
                                          );
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    )
                                  : null,  //delete will not display in profile mode
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
