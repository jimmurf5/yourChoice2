
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() {
    return _AddUserState();
  }
}

class _AddUserState extends State<AddUser> {
  final _form = GlobalKey<FormState>();

  var _enteredForename = '';
  var _enteredSurname = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    // Save data to Firestore
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'forename': _enteredForename,
        'surname': _enteredSurname,
        'createdAt': Timestamp.now(), // Adding a timestamp
      });

      // Show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully!')),
      );

      // clear the form fields after successful submission
      _form.currentState!.reset();

      // Pop back to the previous screen
      Navigator.of(context).pop();

    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
                        decoration: const InputDecoration(labelText: 'Forename'),
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
                        label: const Text("Add User"),
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

