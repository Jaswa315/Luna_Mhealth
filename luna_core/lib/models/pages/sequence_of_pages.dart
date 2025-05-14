import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/utils/types.dart';

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

  /// Gets the current index of a [Page] in the sequence of pages (SOP).
  ///
  /// This method searches for the specified [page] in the sequence and returns
  /// its index. If the sequence is empty, or if the [page] is not found, an
  /// exception is thrown.
  ///
  /// Parameters:
  /// - [page]: The [Page] object whose index needs to be retrieved.
  ///
  /// Returns:
  /// - An [int] representing the index of the specified [Page] in the sequence.
  ///
  /// Throws:
  /// - [RangeError]: If the sequence of pages is empty.
  /// - [ArgumentError]: If the specified [Page] is not found in the sequence.
  int getIndexOfPage(Page page) {
    if (_pages.isEmpty) {
      throw RangeError('No pages in the sequence');
    }

    int index = _pages.indexOf(page);
    if (index == -1) {
      throw ArgumentError('Page not found in the sequence');
    }

    return index;
  }

  /// Retrieves the page to the left of the specified [Page] in the sequence of pages (SOP).
  ///
  /// This method finds the page immediately preceding the given [page] in the sequence.
  /// If the sequence is empty or the specified [page] is the first page, an exception is thrown.
  ///
  /// Parameters:
  /// - [page]: The [Page] object for which the left page needs to be retrieved.
  ///
  /// Returns:
  /// - A [Page] object representing the page to the left of the specified [Page].
  ///
  /// Throws:
  /// - [RangeError]: If the sequence of pages is empty.
  /// - [StateError]: If the specified [Page] is the first page and no left page is available.
  /// - [ArgumentError]: If the specified [Page] is not found in the sequence.
  Page getLeftPage(Page page) {
    if (_pages.isEmpty) {
      throw RangeError('No pages in the sequence');
    }

    int index = getIndexOfPage(page);
    if (index == 0) {
      throw StateError('No left page available');
    }

    return _pages[index - 1];
  }

  /// Retrieves the page to the right of the specified [Page] in the sequence of pages (SOP).
  ///
  /// This method finds the page immediately succeeding the given [page] in the sequence.
  /// If the sequence is empty or the specified [page] is the last page, an exception is thrown.
  ///
  /// Parameters:
  /// - [page]: The [Page] object for which the right page needs to be retrieved.
  ///
  /// Returns:
  /// - A [Page] object representing the page to the right of the specified [Page].
  ///
  /// Throws:
  /// - [RangeError]: If the sequence of pages is empty.
  /// - [StateError]: If the specified [Page] is the last page and no right page is available.
  /// - [ArgumentError]: If the specified [Page] is not found in the sequence.
  Page getRightPage(Page page) {
    if (_pages.isEmpty) {
      throw RangeError('No pages in the sequence');
    }

    int index = getIndexOfPage(page);
    if (index >= _pages.length - 1) {
      throw StateError('No right page available');
    }

    return _pages[index + 1];
  }

  factory SequenceOfPages.fromJson(Json json) {
    final pagesJson = json['pages'] as List<dynamic>;
    final sequence = SequenceOfPages(pages: []);

    for (final p in pagesJson) {
      final page = Page.fromJson(p, sequence);
      sequence.addPage(page);
    }

    return sequence;
  }

  Json toJson() {
    return {
      'pages': pages.map((p) => p.toJson()).toList(),
    };
  }
}
