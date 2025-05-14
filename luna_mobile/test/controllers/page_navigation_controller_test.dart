import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_mobile/states/module_state.dart';
import 'package:luna_mobile/controllers/page_navigation_controller.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mock.mocks.dart';

void main() {
  group('PageNavigationController Tests', () {
    late PageNavigationController pageNavigationController;
    late SequenceOfPages realSequenceOfPages;
    late MockPage validPage1;
    late MockPage validPage2;
    late MockPage validPage3;
    late MockModuleState mockModuleState;

    setUp(() {
      // Create real pages
      validPage1 = MockPage();
      validPage2 = MockPage();
      validPage3 = MockPage();

      // Create a real SequenceOfPages instance
      realSequenceOfPages = SequenceOfPages(
        pages: [validPage1, validPage2, validPage3],
      );

      // Mock the ModuleState to return validPage2 as the current page
      mockModuleState = MockModuleState();
      when(mockModuleState.getCurrentPage()).thenReturn(validPage2);

      // Mock the getsequenceOfPages method to return the real sequence
      when(validPage1.getsequenceOfPages()).thenReturn(realSequenceOfPages);
      when(validPage2.getsequenceOfPages()).thenReturn(realSequenceOfPages);
      when(validPage3.getsequenceOfPages()).thenReturn(realSequenceOfPages);

      // Initialize the controller
      pageNavigationController = PageNavigationController(mockModuleState);
    });

    test('Should navigate to the next page', () {
      // Act
      pageNavigationController.navigateToNextPage();

      // Assert
      verify(mockModuleState.setCurrentPage(validPage3)).called(1);
    });

    test('Should navigate to the previous page', () {
      // Act
      pageNavigationController.navigateToPreviousPage();

      // Assert
      verify(mockModuleState.setCurrentPage(validPage1)).called(1);
    });

    test('Should throw an error if no next page exists', () {
      // Arrange
      when(mockModuleState.getCurrentPage()).thenReturn(validPage3);

      // Act & Assert
      expect(
        () => pageNavigationController.navigateToNextPage(),
        throwsStateError,
      );
    });

    test('Should throw an error if no previous page exists', () {
      // Arrange
      when(mockModuleState.getCurrentPage()).thenReturn(validPage1);

      // Act & Assert
      expect(
        () => pageNavigationController.navigateToPreviousPage(),
        throwsStateError,
      );
    });

    test('Should return the current page', () {
      // Act
      Page currentPage = pageNavigationController.currentPage;

      // Assert
      expect(currentPage, validPage2);
      verify(mockModuleState.getCurrentPage()).called(1);
    });

    test('Should return the current sequence of pages', () {
      // Act
      SequenceOfPages currentSequence =
          pageNavigationController.currentSequence;

      // Assert
      expect(currentSequence, realSequenceOfPages);
      verify(validPage2.getsequenceOfPages()).called(1);
    });
  });
}
