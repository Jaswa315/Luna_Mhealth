import 'package:flutter/material.dart';
import 'package:luna_mobile/controllers/page_navigation_controller.dart';

/// A widget that provides left, right, and top-left back navigation controls
/// for use within a module page.
class NavigationButtons extends StatelessWidget {
  /// Controller that handles navigation between pages.
  final PageNavigationController controller;

  /// Callback triggered after a page navigation occurs.
  final VoidCallback onPageChanged;

  const NavigationButtons({
    required this.controller,
    required this.onPageChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Back button (top-left corner) to return to the previous screen.
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Returns to StartLearningPage
            },
          ),
        ),

        /// Left page navigation button (center-left)
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              controller.navigateToPreviousPage();
              onPageChanged();
            },
          ),
        ),

        /// Right page navigation button (center-right)
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              controller.navigateToNextPage();
              onPageChanged();
            },
          ),
        ),
      ],
    );
  }
}
