import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';

/// The LunaAppModel class is responsible for managing the current page and
/// the current sequence of pages in the Luna application.
/// It provides methods to get and set the current page and sequence of pages.
/// This class is used to maintain the state of the application and
/// facilitate navigation between different pages.
class LunaAppModel {
  SequenceOfPages currentSOP;
  Page _currentPage;

  LunaAppModel({
    required this.currentSOP,
    required Page initialPage,
  }) : _currentPage = initialPage;

  /// gets the current page to the specified [page].
  Page getCurrentPage() => _currentPage;

  /// Sets the current page to the specified [page].
  void setCurrentPage(Page page) {
    _currentPage = page;
  }

  /// Gets the current sequence of pages.
  SequenceOfPages getCurrentSOP() => currentSOP;

  ///sets the current sequence of pages to the specified [sop].
  void setCurrentSOP(SequenceOfPages sop) {
    currentSOP = sop;
  }
}
