import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_choice/providers/profile_colour_manager.dart';
import 'package:your_choice/screens/add_profile.dart';
import 'package:your_choice/screens/customise_profile.dart';
import '../repositories/auth_repository.dart';
import '../repositories/profile_repository.dart';
import '../widgets/logo_title_row.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key});

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

/// AdminHome is a StatefulWidget that represents the admin dashboard screen.
/// This screen allows the admin user to view, add, and manage user profiles.
/// It displays the current user's email in the appBar,
/// a button to add new profiles, and a list of existing profiles.
/// The profiles can be selected for customization or deleted with an option to undo.
class _AdminHomeState extends ConsumerState<AdminHome> {
  String userEmail = '';
  // Initialize the FirestoreRepository
  final ProfileRepository _repository = ProfileRepository();
  // Initialize the AuthRepository
  final AuthRepository _authRepository = AuthRepository();


  @override
  void initState() {
    super.initState();
    // Fetch the current user's email on widget initialization
    fetchUserEmail();
  }

  /// Fetches the current user's email and sets the userEmail state variable.
  void fetchUserEmail() async {
    User? user = _authRepository.getCurrentUser();
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
            const LogoTitleRow(
            logoWidth: 30,
            logoHeight: 30,
            titleText: 'Your Choice',
            textSize: 15,
            spacerWidth: 10),
            const SizedBox(height: 4,),
            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 15.0, color: Colors.white
              ),
            ),
            const SizedBox(height: 5,)
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
                //navigate to add profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProfile()
                  ),
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
                /* Use the repository method, pass the userId to the method
                * after retrieving with Firebase auth */
                stream: _repository.fetchProfiles(
                    userId: _authRepository.getCurrentUser()?.uid ?? '',
                ),
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
                                  /* Reads the profileColourManagerProvider to
                                  // select a profile color for the given
                                  profile ID*/
                                  await ref.read(profileColourManagerProvider)
                                      .selectProfileColour(profile.id);
                                  /*navigate to CustomiseProfile while
                                  passing the profileId of the selected profile*/
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
                              //store profile details for recall if desired
                              final deletedProfile = profile.data() as Map<String, dynamic>;
                              final profileId = profile.id;

                              /* Delete profile using the repository and passing
                              * the profileId */
                              await _repository.deleteProfile(
                                  profileId: profileId
                              )
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 10),
                                    content: const Text('Profile deleted successfully'),
                                    action: SnackBarAction(
                                      label: 'UNDO',
                                      onPressed: () {
                                        /* Restore the deleted profile using
                                        the stored deletedProfile data
                                        repository */
                                        _repository
                                            .restoreProfile(
                                            profileId: profileId,
                                            profileData: deletedProfile
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to delete profile')),
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
