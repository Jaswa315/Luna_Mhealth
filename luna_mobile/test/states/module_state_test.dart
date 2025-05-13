import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_mobile/states/module_state.dart';

void main() {
  group('ModuleState Tests', () {
    late Page initialPage;
    late Page newPage;
    late ModuleState moduleState;

    setUp(() {
      // Initialize test data
      initialPage = Page(components: []);
      newPage = Page(components: []);
      moduleState = ModuleState(currentPage: initialPage);
    });

    test('Should return the current page', () {
      // Act
      final currentPage = moduleState.getCurrentPage();

      // Assert
      expect(currentPage, equals(initialPage));
    });

    test('Should update the current page', () {
      // Act
      moduleState.setCurrentPage(newPage);

      // Assert
      expect(moduleState.getCurrentPage(), equals(newPage));
    });

    test('Should correctly handle multiple updates to the current page', () {
      // Act
      moduleState.setCurrentPage(newPage);
      moduleState.setCurrentPage(initialPage);

      // Assert
      expect(moduleState.getCurrentPage(), equals(initialPage));
    });
  });
}
