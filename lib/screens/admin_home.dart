import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_choice/screens/add_user.dart';
import 'package:your_choice/screens/customise_ux.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    // Fetch the current user's email on widget initialization
    fetchUserEmail();
  }

  void fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? 'No Email'; // Handling null case
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Admin Home'),
            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.inversePrimary,
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
            const Text(
              'Current Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('createdBy',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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
                      return Padding(padding: const EdgeInsets.symmetric(vertical: 4.0),
                       child: ListTile(
                         tileColor: Theme.of(context).highlightColor, // Background color for the tile
                         title:
                         Text('${user['forename']} ${user['surname']}'
                         ),
                         subtitle: Column(
                           children: [
                             TextButton(
                               onPressed: () {
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => const CustomiseUx() ),
                                 );
                               },
                               style: TextButton.styleFrom(
                                 foregroundColor: Colors.white, // Text color
                                 backgroundColor: Colors.blue, // Button background color
                               ),
                               child: const Text('Select'),
                             ),
                           ],
                         ),
                         trailing: IconButton(
                           onPressed: () {
                             FirebaseFirestore.instance
                                 .collection('users')
                                 .doc(user.id)
                                 .delete()
                                 .then((_) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(
                                     content: Text('User deleted successfully')),
                               );
                             }).catchError((error) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(
                                     content: Text('Failed to delete user')),
                               );
                             });
                           },
                           icon: const Icon(Icons.delete),
                         ),
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
