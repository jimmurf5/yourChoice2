import 'package:flutter/material.dart';

/// A splash screen widget used during app initialization.
///
/// The `SplashScreen` widget is displayed while the app is initializing or
/// waiting for another screen (such as the authentication screen or admin home screen)
/// to load. A placeholder while waiting for a response form firestore.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      body: const Center(
        child: Text('Loading.... '),
      ),
    );
  }

}