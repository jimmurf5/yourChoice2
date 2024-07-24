import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_choice/providers/profile_colour_manager.dart';
import 'package:your_choice/screens/add_profile.dart';
import 'package:your_choice/screens/customise_profile.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key});

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
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
        backgroundColor: Theme.of(context).colorScheme.primary,
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
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProfile()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Profile"),
            ),
            const SizedBox(height: 20),
            const Text(
              'Current Profiles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('profiles')
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
                    return const Text('No profiles found');
                  }

                  final profiles = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot profile = profiles[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          tileColor: Theme.of(context)
                              .highlightColor, // Background color for the tile
                          title: Text(
                              '${profile['forename']} ${profile['surname']}'),
                          subtitle: Column(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  await ref.read(profileColourManagerProvider).selectProfileColour(profile.id);
                                  //navigate to CustomiseProfile while passing the profileId of the selected profile
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomiseProfile(
                                        profileId: profile.id,
                                        profileName:
                                            '${profile['forename']} ${profile['surname']}',
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white, // Text color
                                  backgroundColor:
                                      Theme.of(context).colorScheme.inversePrimary, // Button background color
                                ),
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              //store profile details for recall if desired
                              final deletedProfile = profile.data() as Map<String, dynamic>;
                              final profileId = profile.id;

                              //delete profile
                              await FirebaseFirestore.instance
                                  .collection('profiles')
                                  .doc(profile.id)
                                  .delete()
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                      duration:
                                          const Duration(seconds: 10),
                                      content:
                                          const Text('Profile deleted successfully'),
                                    action: SnackBarAction(
                                        label: 'UNDO',
                                        onPressed: ()  {
                                          // Restore the deleted profile
                                          FirebaseFirestore.instance
                                              .collection('profiles')
                                              .doc(profileId)
                                              .set(deletedProfile);
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
