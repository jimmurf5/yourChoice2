
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:your_choice/repositories/message_card_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_choice/services/hive/message_card_cache_service.dart';
import 'package:your_choice/services/image_delete_service.dart';
import 'message_card_repository_test.mocks.dart'; // the generated mock file

@GenerateMocks([
  FirebaseFirestore,
  MessageCardCacheService,
  ImageDeleteService,
  QuerySnapshot<Map<String, dynamic>>,       //correctly type the mock
  DocumentSnapshot,
  CollectionReference<Map<String, dynamic>>, //correctly type the mock
  DocumentReference<Map<String, dynamic>>,   //correctly type the mock
  Query<Map<String, dynamic>>,               //correctly type the mock
  QueryDocumentSnapshot
])
void main() {
  late MessageCardRepository messageCardRepository;
  late MockFirebaseFirestore mockFirestore;
  late MockMessageCardCacheService mockCacheService;
  late MockImageDeleteService mockImageDeleteService;
  late MockCollectionReference <Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference <Map<String, dynamic>> mockDocumentReference;
  late MockQuerySnapshot <Map<String, dynamic>> mockQuerySnapshot;
  late MockQuery <Map<String, dynamic>> mockQuery;
  late MockQueryDocumentSnapshot <Map<String, dynamic>> mockQueryDocumentSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCacheService = MockMessageCardCacheService();
    mockImageDeleteService = MockImageDeleteService();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQuery = MockQuery();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();

    // Inject mocks into the repository
    messageCardRepository = MessageCardRepository(
      firestore: mockFirestore,
      cacheService: mockCacheService,
      imageDeleteService: mockImageDeleteService,
    );
  });

  group('MessageCardRepository', () {

    //test tests the method which returns messageCard of one category
    test('fetchMessageCards returns a stream of messageCard on success of same category', () {
        //mock the firestore calls and the data returned by stream
      when(mockFirestore.collection('profiles')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('messageCards')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.where('categoryId', isEqualTo: anyNamed('isEqualTo'))).thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));

      //act: call the repo method
      final result = messageCardRepository.fetchMessageCards(
          profileId: 'testId',
          categoryId: 666
      );

      //assert: verify the method returns the correct stream
      expect(result, isA<Stream<QuerySnapshot>>());
      expectLater(result, emits(mockQuerySnapshot));

      //verify that the firestore methods were called correctly
      verify(mockFirestore.collection('profiles')).called(1);
      verify(mockCollectionReference.doc('testId'));
      verify(mockDocumentReference.collection('messageCards')).called(1);
      verify(mockCollectionReference.where('categoryId', isEqualTo: 666)).called(1);
      verify(mockQuery.snapshots()).called(1);
    });

    //test tests method that returns all MessageCards
    test('fetchAllMessageCards returns a list of MessageCards for a profileId', () async {
        //arrange: mock the firestore collection and docs
      when(mockFirestore.collection('profiles')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('messageCards')).thenReturn(mockCollectionReference);

      //simulate the firestore returning a query snapshot with mocked docs
      when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);

      //mock the document data returned from firestore
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({
        'title': 'Test Card',
        'messageCardId': '100',
        'selectionCount': 13,
        'categoryId': 5,
        'imageUrl': 'http://fakepic.com/image.jpg',
      });

      //act: call the repo method
      final result = await messageCardRepository.fetchAllMessageCards('beetleJuice');

      //assert: verify the method returns the correct list of maps
      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, equals(1));
      expect(result.first['title'], equals('Test Card'));

      // Verify that Firestore methods were called correctly
      verify(mockFirestore.collection('profiles')).called(1);
      verify(mockCollectionReference.doc('beetleJuice')).called(1);
      verify(mockDocumentReference.collection('messageCards')).called(1);
      verify(mockCollectionReference.get()).called(1);

    });
    
    
  });
}