import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

/// AuthScreen is a StatefulWidget that provides a form for user authentication.
/// This screen allows users to either sign in or create a new account.
/// It uses an AuthRepository to handle Firebase Authentication operations.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  /* Create a GlobalKey to uniquely identify the Form widget
  and allow validation and state management*/
  final _form = GlobalKey<FormState>();
  // Initialize the AuthRepository
  final AuthRepository _authRepository = AuthRepository();

  //variables to hold the users information for submission
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  /// Validates and submits the form data by calling the
  /// AuthRepository to either sign in or create a new user account.
  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    /*call auth repo depending on weather bool _isLogin is true or false
    * dictated by ternary expression in controlled by onPressed of
    * elevated button at bottom of the class*/
    try {
      if (_isLogin) {
          await _authRepository
            .signInWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword
        );
      } else {
          await _authRepository
            .createUserWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword
        );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20),
                width: 100,
                height: 100,
                child: Image.asset('assets/images/logo_2.png'), // Replace with your logo asset
              ),
              // Add your app name here
              const Text(
                'Your Choice',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null; // if pass the validation
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              // Regular expression to validate the password
                              final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$');
                              if (value == null || !regex.hasMatch(value)) {
                                return 'Min 8 characters, must contain one uppercase letter,\none lower, a number, and a special character.';
                              }
                              return null; // if pass the validation
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create an account'
                                : 'I already have an account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
