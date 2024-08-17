import 'package:firebase_auth/firebase_auth.dart';

/// A repository class that handles Firebase Authentication operations.
/// This class abstracts the details of Firebase Authentication interactions
/// and provides an interface for the rest of the application to interact
/// with the authentication service.
class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Signs in a user with an email and password.
  ///
  /// [email] - The email of the user.
  /// [password] - The password of the user.
  /// Returns a [UserCredential] object on successful sign-in.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth
        .signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  /// Creates a new user with an email and password.
  ///
  /// [email] - The email of the new user.
  /// [password] - The password of the new user.
  /// Returns a [UserCredential] object on successful account creation.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth
        .createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  /// Returns the currently signed-in user,
  /// or null if there is no signed-in user.
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Signs out the currently signed-in user.
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  /// Stream to listen to authentication state changes
  Stream<User?> authStateChange() {
    return _firebaseAuth.authStateChanges();
  }
}
