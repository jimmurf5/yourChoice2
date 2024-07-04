import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_choice/screens/add_user.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddUser()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Users"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('createdBy', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No users found');
                  }

                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot user = users[index];
                      return ListTile(
                        title: Text(user['forename'] + ' ' + user['surname']),
                        trailing: IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.id)
                                .delete();
                          },
                          icon: const Icon(Icons.delete),
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
