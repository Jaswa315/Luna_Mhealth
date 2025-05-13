import 'package:luna_core/models/pages/page.dart';

/// The LunaAppModel class is responsible for managing the current page and
/// the current sequence of pages in the Luna application.
/// It provides methods to get and set the current page and sequence of pages.
/// This class is used to maintain the state of the application and
/// facilitate navigation between different pages.
class ModuleState {
  Page _currentPage;

  ModuleState({
    required Page currentPage,
  }) : _currentPage = currentPage;

  /// gets the current page.
  Page getCurrentPage() => _currentPage;

  /// Sets the current page to the specified [page].
  void setCurrentPage(Page page) {
    _currentPage = page;
  }
}
