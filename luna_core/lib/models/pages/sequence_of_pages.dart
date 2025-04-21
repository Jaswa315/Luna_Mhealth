import 'package:luna_core/models/pages/page.dart';

/// Represents a sequence of pages in the application.
class SequenceOfPages {
  final List<Page> _pages;

  /// Constructs a new [SequenceOfPages] with a list of pages.
  SequenceOfPages({
    required List<Page> pages,
  }) : _pages = pages;

  /// A list of pages in the sequence.
  List<Page> get pages => List.unmodifiable(_pages);

  /// Gets the page at the specified index.
  Page getPage(int index) {
    if (index < 0 || index >= _pages.length) {
      throw RangeError('Index out of range');
    }

    return _pages[index];
  }

  /// Adds a page to the sequence.
  void addPage(Page page) {
    _pages.add(page);
  }

  /// Removes a page from the sequence.
  void removePage(Page page) {
    _pages.remove(page);
  }

  /// Checks if the given page is the leftmost (first) page in the sequence.
  bool isLeftMostPage(Page page) {
    return _pages.isNotEmpty && _pages.first == page;
  }

  /// Checks if the given page is the rightmost (last) page in the sequence.
  bool isRightMostPage(Page page) {
    return _pages.isNotEmpty && _pages.last == page;
  }

  /// Checks if the given page is between the first and last pages in the sequence.
  bool isBetweenFirstAndLastPage(Page page) {
    // If the page is neither the leftmost nor the rightmost and exists in the sequence
    return !isLeftMostPage(page) &&
        !isRightMostPage(page) &&
        _pages.contains(page);
  }

  /// Checks if the given page is the only page in the sequence.
  bool isOnlyPage(Page page) {
    return _pages.length == 1 && _pages.contains(page);
  }
}
