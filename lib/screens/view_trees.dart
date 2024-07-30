import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewTrees extends StatefulWidget {
  final String profileId;

  const ViewTrees({super.key, required this.profileId});

  @override
  State<ViewTrees> createState() {
    return _ViewTrees();
  }
}

//a method to return the decision trees from firebase for a profileId
class _ViewTrees extends State<ViewTrees> {
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
        title: const Text('View Trees'),
      ),
      body: Center(
        child: Column(
          children: [
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
                            DocumentSnapshot tree = trees[index];
                            return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                tileColor: Theme.of(context)
                                    .highlightColor, // Background color for the tile
                                title: Text(
                                    '${tree['treeTitle']}'),
                                subtitle: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        /*navigate to the tree selected*/
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme.onTertiaryContainer, // Text color
                                        backgroundColor: Theme.of(context)
                                            .colorScheme.inversePrimary, // Button background color
                                      ),
                                      child: const Text('Select'),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    //store tree details for recall if desired
                                    final deletedTree = tree.data() as Map<String, dynamic>;

                                    //delete tree
                                    await _firestore
                                        .collection('profiles')
                                        .doc(widget.profileId)
                                        .collection('trees')
                                        .doc(tree.id)
                                        .delete()
                                        .then((_) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration:
                                          const Duration(seconds: 10),
                                          content:
                                          const Text('Tree deleted successfully'),
                                          action: SnackBarAction(
                                              label: 'UNDO',
                                              onPressed: ()  {
                                                // Restore the deleted tree
                                                _firestore
                                                    .collection('profiles')
                                                    .doc(widget.profileId)
                                                    .collection('trees')
                                                    .doc(tree.id)
                                                    .set(deletedTree);
                                              }
                                          ),
                                        ),
                                      );
                                    }).catchError((error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                            Text('Failed to delete profile')
                                        ),
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
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
