import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:your_choice/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'auth_repository_test.mocks.dart';

// Generate the mock for FirebaseAuth and UserCredential
@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    //inject the mockFirebaseAuth repository instead of using
    // FirebaseAuth.instance*/
    authRepository = AuthRepository(firebaseAuth: mockFirebaseAuth);
  });

  group('AuthRepository', () {

    //this test tests the method which signs in a user
    test('signInWithEmailAndPassword returns UserCredential on success', () async {
      //arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      //act
      final result = await authRepository.signInWithEmailAndPassword(
          email: 'jimTest@online.com',
          password: 'Jpassword123?',
      );

      //assert
      expect(result, isA<UserCredential>());
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'jimTest@online.com',
          password: 'Jpassword123?',
      )).called(1);
    });

    //this test tests the method that creates a user
    test('createUserWithEmailAndPassword returns UserCredentials on success', () async {
      //arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      //act
      final result = await authRepository.createUserWithEmailAndPassword(
          email: 'jimTest@online.com',
          password: 'Jpassword123?',
      );

      //assert
      expect(result, isA<UserCredential>());
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'jimTest@online.com',
          password: 'Jpassword123?',
      )).called(1);
    });

    //this test tests method that returns the current signed in user
    test('getCurrentUser returns current user', () {
      //arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      //act
      final result = authRepository.getCurrentUser();

      //assert
      expect(result, isA<User>());
      verify(mockFirebaseAuth.currentUser).called(1);
    });

    //this test tests the method that signs out a user
    test('signOut calls sign out method on FireBaseAuth', () async {
      //arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => Future.value());

      //act
      await authRepository.signOut();

      //assert
      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('authStateChange returns auth state stream', () async {
      //arrange
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(mockUser));

      //act
      final stream = authRepository.authStateChange();

      //assert
      await expectLater(stream, emitsInOrder([mockUser]));
      verify(mockFirebaseAuth.authStateChanges()).called(1);
    });

  });

}

