import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_mobile/states/module_state.dart';

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
  /// Returns `true` if navigation was successful, otherwise `false`.
  void navigateToNextPage() {
    final nextPage = currentSequence.getRightPage(currentPage);
    moduleState.setCurrentPage(nextPage);
  }

  /// Navigates to the previous page in the sequence, if available.
  /// Returns `true` if navigation was successful, otherwise `false`.
  void navigateToPreviousPage() {
    final previousPage = currentSequence.getLeftPage(currentPage);
    moduleState.setCurrentPage(previousPage);
  }
}
