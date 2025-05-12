import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_mobile/model/luna_app_model.dart';

void main() {
  group('LunaAppModel Tests', () {
    late SequenceOfPages sequenceOfPages;
    late Page page1;
    late Page page2;
    late Page page3;

    setUp(() {
      // Initialize test data
      page1 = Page(components: []);
      page2 = Page(components: []);
      page3 = Page(components: []);
      sequenceOfPages = SequenceOfPages(pages: [page1, page2, page3]);
    });

    test('Should initialize with the correct current page and SOP', () {
      // Arrange
      final model = LunaAppModel(
        currentSOP: sequenceOfPages,
        initialPage: page1,
      );

      // Assert
      expect(model.getCurrentPage(), page1);
      expect(model.getCurrentSOP(), sequenceOfPages);
    });

    test('Should update the current page', () {
      // Arrange
      final model = LunaAppModel(
        currentSOP: sequenceOfPages,
        initialPage: page1,
      );

      // Act
      model.setCurrentPage(page2);

      // Assert
      expect(model.getCurrentPage(), page2);
    });

    test('Should update the current SOP', () {
      // Arrange
      final newSequenceOfPages = SequenceOfPages(pages: [page2, page3]);
      final model = LunaAppModel(
        currentSOP: sequenceOfPages,
        initialPage: page1,
      );

      // Act
      model.currentSOP = newSequenceOfPages;

      // Assert
      expect(model.getCurrentSOP(), newSequenceOfPages);
    });
  });
}
