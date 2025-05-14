import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_mobile/states/module_state.dart';

/// A controller class responsible for managing page navigation within a module.
///
/// This class interacts with the `ModuleState` to retrieve the current page
/// and navigate between pages in a `SequenceOfPages`. It ensures that the
/// application's state is updated consistently when navigating to the next
/// or previous page in the sequence.
///
/// Responsibilities:
/// - Retrieve the current page from the `ModuleState`.
/// - Determine the next or previous page in the sequence.
/// - Update the `ModuleState` with the new current page after navigation.
class PageNavigationController {
  final ModuleState moduleState;

  PageNavigationController(this.moduleState);

  /// Gets the current page from the module state.
  Page get currentPage => moduleState.getCurrentPage();

  /// Gets the current sequence of pages for the current page.
  SequenceOfPages get currentSequence {
    return currentPage.getsequenceOfPages();
  }

  /// Navigates to the next page in the sequence, if available.
  void navigateToNextPage() {
    final nextPage = currentSequence.getRightPage(currentPage);
    moduleState.setCurrentPage(nextPage);
  }

  /// Navigates to the previous page in the sequence, if available.
  void navigateToPreviousPage() {
    final previousPage = currentSequence.getLeftPage(currentPage);
    moduleState.setCurrentPage(previousPage);
  }
}
