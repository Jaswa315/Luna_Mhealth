import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/builder/sequence_of_page_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/pages/page.dart';

void main() {
  group('SequenceOfPageBuilder Tests', () {
    test('Should build a set of SequenceOfPages with valid slides and sections',
        () {
      // Arrange
      List<Slide> slides = [
        Slide()..shapes = [],
        Slide()..shapes = [],
        Slide()..shapes = [],
      ];

      Section section = Section({
        "Introduction": [1, 2],
        "Conclusion": [3],
      });

      SequenceOfPageBuilder builder = SequenceOfPageBuilder(
        slides: slides,
        section: section,
      );

      // Act
      Set<SequenceOfPages> sequenceOfPagesSet = builder.build();

      // Assert
      expect(sequenceOfPagesSet.length, equals(2)); // Two sections
      expect(sequenceOfPagesSet.first.pages.length,
          equals(2)); // First section has 2 pages
      expect(sequenceOfPagesSet.last.pages.length,
          equals(1)); // Second section has 1 page
      expect(builder.firstPage, isA<Page>());
      expect(builder.firstPage.components, isEmpty);
    });

    test('Should handle an empty list of slides', () {
      // Arrange
      List<Slide> slides = [];

      Section section = Section({
        "Introduction": [],
      });

      SequenceOfPageBuilder builder = SequenceOfPageBuilder(
        slides: slides,
        section: section,
      );

      // Act
      Set<SequenceOfPages> sequenceOfPagesSet = builder.build();

      // Assert
      expect(sequenceOfPagesSet.length, equals(1)); // One section
      expect(
          sequenceOfPagesSet.first.pages, isEmpty); // The section has no pages
      expect(() => builder.firstPage, throwsA(isA<StateError>()));
    });
  });
}
