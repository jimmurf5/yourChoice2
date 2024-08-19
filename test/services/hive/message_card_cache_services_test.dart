import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/services/hive/message_card_cache_service.dart';

import 'message_card_cache_services_test.mocks.dart';

@GenerateMocks([Box<MessageCard>, File])
void main() {
  late MessageCardCacheService cacheService;
  late MockBox<MessageCard> mockBox;
  
  setUp(() {
    // Initialize Hive and open the box for testing
    Hive.init('test');
    mockBox = MockBox<MessageCard>();
    cacheService = MessageCardCacheService();
    
    //override hive and return the mock box
    when(Hive.box<MessageCard>('messageCards')).thenReturn(mockBox);

    cacheService = MessageCardCacheService();

    // Mock behavior for methods used in tests
    when(mockBox.put(any, any)).thenAnswer((_) async {});
  });
  
  test('saveMessageCard saves  a message card to the box', () async {
    // arrange
    final messageCard = MessageCard(title: 'fakeTitle', imageUrl: 'fakeUrl', categoryId: 1);
    const profileId = 'profileId';
    
    //act
    await cacheService.saveMessageCard(messageCard, profileId);
    
    //assert
    verify(
        mockBox.put('${profileId}_${messageCard.messageCardId}', messageCard)).called(1);
  });
  
}
