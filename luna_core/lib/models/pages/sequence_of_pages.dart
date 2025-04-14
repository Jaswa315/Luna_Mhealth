import 'package:luna_core/models/pages/page.dart';

class SequenceOfPages {
  final String _id;
  final List<Page> _pages;

  SequenceOfPages({
    required String id,
    required List<Page> pages,
  })  : _id = id,
        _pages = pages;

  /// A unique identifier for the sequence of pages.
  String get id => _id;

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
