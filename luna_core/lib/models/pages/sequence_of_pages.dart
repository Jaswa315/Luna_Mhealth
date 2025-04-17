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
}
