import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:your_choice/screens/add_profile.dart';
import 'package:your_choice/repositories/auth_repository.dart';
import 'package:your_choice/repositories/profile_repository.dart';
import 'add_profile_test.mocks.dart';

/* NOTE: The following test is currently not working due to issues with Firebase initialization
// in the test environment. The test fails with a FirebaseException indicating
// that no Firebase App has been created. Configuration or initialisation prob?.
//
// Extensive troubleshooting, including attempts to mock Firebase dependencies,
// the errors persist. Test cannot be executed successfully at this time.
//
// For now, will move forward and consider this test as non-functional. Further
// investigation and setup adjustments may be required to resolve these issues.
// Time limitations at present*/

@GenerateMocks([AuthRepository, ProfileRepository, User, DocumentReference])
void main() {
  late MockAuthRepository mockAuthRepository;
  late MockProfileRepository mockProfileRepository;
  late MockUser mockUser;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockProfileRepository = MockProfileRepository();
    mockUser = MockUser();
    mockDocumentReference = MockDocumentReference();

    // Mock behaviors
    when(mockUser.uid).thenReturn('mockUserId');
    when(mockAuthRepository.getCurrentUser()).thenReturn(mockUser);
    when(mockProfileRepository.createProfile(
      profileData: anyNamed('profileData'),
    )).thenAnswer((_) async => mockDocumentReference);
  });

  testWidgets('renders AddProfile widget and handles form submission', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AddProfile(
          profileRepository: mockProfileRepository,
          authRepository: mockAuthRepository,
        ),
      ),
    );

    // Verify widget rendering
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Simulate user input and form submission
    await tester.enterText(find.byType(TextFormField).at(0), 'Donald');
    await tester.enterText(find.byType(TextFormField).at(1), 'Trump');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify createProfile was called
    verify(mockProfileRepository.createProfile(
      profileData: {
        'forename': 'Donald',
        'surname': 'Trump',
        'createdBy': 'mockUserId',
      },
    )).called(1);

    // Verify success message
    expect(find.text('Profile added successfully!'), findsOneWidget);
  });
}
