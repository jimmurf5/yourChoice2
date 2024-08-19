import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:your_choice/models/category.dart';
import 'package:your_choice/services/hive/category_cache_service.dart';

import 'category_cache_service_test.mocks.dart';

@GenerateMocks([Box<Category>])
void main() {
  late CategoryCacheService cacheService;
  late MockBox<Category> mockBox;

  setUp(() {
    // Initialize Hive and create a mock box
    mockBox = MockBox<Category>();

    // Initialize the CategoryCacheService with the mock box
    cacheService = CategoryCacheService(mockBox);
  });

  test('getAllCategories returns a list of categories from the box', () {
    // Arrange
    final category1 = Category(title: 'fake1', imageUrl: 'whatever', categoryId: 123);
    final category2 = Category(title: 'fake2', imageUrl: 'tiredness', categoryId: 321);
    final categories = [category1, category2];

    // Set up the mock box to return the categories
    when(mockBox.values).thenReturn(categories);

    // Act
    final result = cacheService.getAllCategories();

    // Assert
    expect(result, equals(categories));
  });
}