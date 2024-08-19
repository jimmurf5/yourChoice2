import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:your_choice/widgets/logo_title_row.dart';
import '../repositories/auth_repository.dart';
import '../repositories/profile_repository.dart';

class AddProfile extends StatefulWidget {
  // Optional constructor parameters
  final ProfileRepository? profileRepository;
  final AuthRepository? authRepository;

  const AddProfile({
    super.key,
    this.profileRepository,
    this.authRepository});

  @override
  State<AddProfile> createState() {
    return _AddProfileState();
  }
}

/// A StatefulWidget that provides a form for adding a new profile.
/// This widget handles user input, validates the form,
/// and submits the data to Firestore.
class _AddProfileState extends State<AddProfile> {
  /* Create a GlobalKey to uniquely identify the Form widget
  and allow validation and state management*/
  final _form = GlobalKey<FormState>();
  // Initialize the ProfileRepository
  final ProfileRepository _profileRepository = ProfileRepository();
  // Initialize the AuthRepository
  final AuthRepository _authRepository = AuthRepository();

  //vars to store the user data
  var _enteredForename = '';
  var _enteredSurname = '';

  /// Validates and submits the form data by calling the
  /// firestore repository to create a new profile.
  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    // Save data to Firestore
    try {
      // Get the current user's UID
      final currentUser = _authRepository.getCurrentUser();
      if (currentUser == null) {
        return;
      }
      final myUid = currentUser.uid;

      // Create a map for the new profile data
      final profileData = {
        'forename': _enteredForename,
        'surname': _enteredSurname,
        'colour':Theme.of(context).colorScheme.primary.value, // store color initially as the users seed colour
        'createdBy': myUid, // Adding the createdBy field
      };

      // Add the profile to Firestore using the repository and get the document reference
      DocumentReference profileRef = await _profileRepository
          .createProfile(profileData: profileData);

      //get the profile id from the document reference
      String profileId = profileRef.id;

      /* Call your to duplicate seeded data for the new profile
      * from the profile Repository*/
      await _profileRepository.duplicateSeededDataForNewProfile(profileId);

      // Show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Profile added successfully!')),
      );

      // clear the form fields after successful submission
      _form.currentState!.reset();

      // Pop back to the previous screen
      Navigator.of(context).pop();
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const LogoTitleRow(
            logoWidth: 50,
            logoHeight: 50,
            titleText: 'Your Choice',
            textSize: 24,
            spacerWidth: 10
        ),
      ),
      //backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Forename'),
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a valid name.';
                          }
                          return null; // if pass the validation
                        },
                        onSaved: (value) {
                          _enteredForename = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Surname'),
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a valid surname.';
                          }
                          return null; // if pass the validation
                        },
                        onSaved: (value) {
                          _enteredSurname = value!;
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Profile"),
                        style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context)
                                .colorScheme.onTertiaryContainer, // Text color
                            backgroundColor: Theme.of(context)
                                .colorScheme.inversePrimary, // Button background color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
