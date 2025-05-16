import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_mobile/controllers/navigation_buttons.dart';
import 'package:luna_mobile/controllers/page_navigation_controller.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mock.mocks.dart';

void main() {
  group('NavigationButtons Widget Tests', () {
    late MockPageNavigationController mockController;
    late VoidCallback mockOnPageChanged;

    setUp(() {
      // Initialize the mock controller and callback
      mockController = MockPageNavigationController();
      mockOnPageChanged = () {};
    });

    testWidgets('Left navigation button calls navigateToPreviousPage', (
      WidgetTester tester,
    ) async {
      // Mock the onPageChanged callback
      var onPageChangedCalled = false;
      mockOnPageChanged = () {
        onPageChangedCalled = true;
      };

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationButtons(
              controller: mockController,
              onPageChanged: mockOnPageChanged,
            ),
          ),
        ),
      );

      // Simulate a tap on the left navigation button
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      // Verify that navigateToPreviousPage was called
      verify(mockController.navigateToPreviousPage()).called(1);

      // Verify that onPageChanged was called
      expect(onPageChangedCalled, isTrue);
    });

    testWidgets('Right navigation button calls navigateToNextPage', (
      WidgetTester tester,
    ) async {
      // Mock the onPageChanged callback
      var onPageChangedCalled = false;
      mockOnPageChanged = () {
        onPageChangedCalled = true;
      };

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationButtons(
              controller: mockController,
              onPageChanged: mockOnPageChanged,
            ),
          ),
        ),
      );

      // Simulate a tap on the right navigation button
      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pumpAndSettle();

      // Verify that navigateToNextPage was called
      verify(mockController.navigateToNextPage()).called(1);

      // Verify that onPageChanged was called
      expect(onPageChangedCalled, isTrue);
    });
  });
}
