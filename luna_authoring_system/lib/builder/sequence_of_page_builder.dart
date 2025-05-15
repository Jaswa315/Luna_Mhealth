import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/builder/page_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';

/// The [SequenceOfPageBuilder] class is responsible for building a set of
/// [SequenceOfPages] objects from a list of slides and a section.
/// It processes each section and creates a sequence of pages based on the
/// provided slide indices.
/// It uses the [PageBuilder] to create individual pages from the slides.
class SequenceOfPageBuilder implements IBuilder<Set<SequenceOfPages>> {
  final Set<SequenceOfPages> _sequenceOfPages = {};
  final List<Slide> _slides;
  final Section _section;
  final PageBuilder _pageBuilder = PageBuilder();
  Page? _firstPage;

  SequenceOfPageBuilder({
    required List<Slide> slides,
    required Section section,
  })  : _slides = slides,
        _section = section;

  @override
  Set<SequenceOfPages> build() {
    // Iterate through each section and process it
    _section.value.forEach((sectionName, slideIndices) {
      final List<Page> pages = _buildPagesForSection(slideIndices);
      _addSequenceOfPages(pages);
    });

    return _sequenceOfPages;
  }

  /// Builds a list of [Page] objects for the given slide indices in a section.
  List<Page> _buildPagesForSection(List<int> slideIndices) {
    final List<Page> pages = [];

    for (int slideIndex in slideIndices) {
      // Slide index is 1-based index.
      pages.add(_buildPageFromSlide(slideIndex));
    }

    return pages;
  }

  /// Builds a single [Page] object from a slide index.
  Page _buildPageFromSlide(int slideIndex) {
    return _pageBuilder
        .buildPage(_slides[slideIndex - 1].shapes ??
            []) // Build the page from slide shapes
        .build();
  }

  /// Adds a [SequenceOfPages] to the set of sequences.
  void _addSequenceOfPages(List<Page> pages) {
    if (pages.isEmpty) {
      _sequenceOfPages.add(SequenceOfPages(pages: []));

      return;
    }

    final sequence = SequenceOfPages(pages: []);
    for (final page in pages) {
      page.setSequenceOfPages(sequence); // Set back-reference
      sequence.addPage(page);
    }

    _sequenceOfPages.add(sequence);
    _firstPage ??= pages.first;
  }

  Page get firstPage {
    if (_firstPage == null) {
      throw StateError('No pages were added. Cannot return firstPage.');
    }

    return _firstPage!;
  }
}
