import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/utils/types.dart';

/// Represents a sequence of pages in the application.
class SequenceOfPages {
  final List<Page> _sequenceOfPages;

  /// Constructs a new [SequenceOfPages] with a list of pages.
  SequenceOfPages({
    required List<Page> sequenceOfPages,
  }) : _sequenceOfPages = sequenceOfPages;

  /// Gets the page at the specified index.
  Page getPage(int index) {
    if (index < 0 || index >= _sequenceOfPages.length) {
      throw RangeError('Index out of range');
    }

    return _sequenceOfPages[index];
  }

  /// Adds a page to the sequence.
  void addPage(Page page) {
    _sequenceOfPages.add(page);
  }

  /// Removes a page from the sequence.
  void removePage(Page page) {
    _sequenceOfPages.remove(page);
  }

  /// Checks if the given page is the leftmost (first) page in the sequence.
  bool isLeftMostPage(Page page) {
    return _sequenceOfPages.isNotEmpty && _sequenceOfPages.first == page;
  }

  /// Checks if the given page is the rightmost (last) page in the sequence.
  bool isRightMostPage(Page page) {
    return _sequenceOfPages.isNotEmpty && _sequenceOfPages.last == page;
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
    if (_sequenceOfPages.isEmpty) {
      throw RangeError('No pages in the sequence');
    }

    int index = _sequenceOfPages.indexOf(page);
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
    if (_sequenceOfPages.isEmpty) {
      throw RangeError('No pages in the sequence');
    }

    int index = getIndexOfPage(page);
    if (index == 0) {
      throw StateError('No left page available');
    }

    return _sequenceOfPages[index - 1];
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
    if (_sequenceOfPages.isEmpty) {
      throw RangeError('No pages in the sequence');
    }

    int index = getIndexOfPage(page);
    if (index >= _sequenceOfPages.length - 1) {
      throw StateError('No right page available');
    }

    return _sequenceOfPages[index + 1];
  }

  Json toJson(
    Map<Object, String> objectIdMap,
    Map<String, Json> serializedDefinitions,
  ) {
    final pageIds = <String>[];

    for (final page in _sequenceOfPages) {
      final id =
          objectIdMap.putIfAbsent(page, () => 'page_${objectIdMap.length}');
      serializedDefinitions[id] =
          page.toJson(objectIdMap, serializedDefinitions);
      pageIds.add(id);
    }

    return {
      'sequenceOfPages': pageIds,
    };
  }

  static SequenceOfPages fromJson(
    Json json,
    String sequenceId,
    Map<String, Object> idToObject,
    Map<String, Json> serializedDefinitions,
  ) {
    final pageIds = json['sequenceOfPages'] as List<dynamic>;
    final sequence = SequenceOfPages(sequenceOfPages: []);
    idToObject[sequenceId] = sequence;

    for (final pageId in pageIds) {
      final pageJson = serializedDefinitions[pageId];
      final page = Page.fromJson(pageJson!, sequence);
      idToObject[pageId] = page;
      sequence.addPage(page);
    }

    return sequence;
  }
}
