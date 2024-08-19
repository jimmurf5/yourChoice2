import 'package:firebase_core/firebase_core.dart';

// Initialize Firebase for testing
Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}
