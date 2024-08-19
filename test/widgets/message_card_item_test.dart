import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_choice/widgets/message_card_item.dart';
import 'package:your_choice/models/message_card.dart';


void main() {

  //test to verify the local image is displayed when the file exists
  testWidgets('displays local PNG image when file exists', (WidgetTester tester) async {

    // Arrange: Create a sample MessageCard with a local PNG image path
    // url blank, we are testing the local path*/
    final messageCard = MessageCard(
      title: 'Test Title',
      imageUrl: '', // Ensure this is empty to avoid network fallback
      categoryId: 10,
      localImagePath: 'assets/images/logo_2.png', // Path to the local PNG
    );

    // Act: Pump the widget into the widget tree, use Material App
    await tester.pumpWidget(
      MaterialApp(
        home: MessageCardItem(
          messageCard: messageCard,
        ),
      ),
    );

    // Assert: Verify that the local image is displayed in the widget
    expect(find.byType(Image), findsOneWidget);
  });

  /* Attempted to mock network image loading with ImageProvider,
   but it didn't work as expected during testing.
   Flutter test environment intercept real network requests and returns
   a 400 Bad Request response.
   Leaving this here as a reference for future testing. */
  /*testWidgets('falls back to the network image when the local file does not exist', (WidgetTester tester) async {
    // Arrange: Create a MessageCard with a valid network URL and no local image path
    final messageCard = MessageCard(
      title: 'Network Image Test',
      imageUrl: 'https://example.com/test_image.png', // Valid network URL
      categoryId: 1,
      localImagePath: '', // No local image path
    );

    // Create a mock ImageProvider
    final mockImageProvider = MockImageProvider();

    // Act: Pump the widget into the widget tree with the mock image provider
    await tester.pumpWidget(
      MaterialApp(
        home: MessageCardItem(
          messageCard: messageCard,
          networkImageProvider: mockImageProvider, // Inject the mock image provider
        ),
      ),
    );

    // Assert: Verify that the mock network image is displayed
    expect(find.byType(Image), findsOneWidget);
  });*/
}

