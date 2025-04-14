import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';

void main() {
  group('SequenceOfPages Tests', () {
    late SequenceOfPages sequenceOfPages;
    late Page page1;
    late Page page2;

    setUp(() {
      page1 = Page(components: []);
      page2 = Page(components: []);
      sequenceOfPages = SequenceOfPages(
        name: 'sequence1',
        pages: [page1, page2],
      );
    });

    test('Should return the correct id', () {
      expect(sequenceOfPages.name, 'sequence1');
    });

    test('Should return the correct list of pages', () {
      expect(sequenceOfPages.pages.length, 2);
      expect(sequenceOfPages.pages[0], page1);
      expect(sequenceOfPages.pages[1], page2);
    });

    test('Should get a page by index', () {
      expect(sequenceOfPages.getPage(0), page1);
      expect(sequenceOfPages.getPage(1), page2);
    });

    test('Should throw RangeError for invalid index', () {
      expect(() => sequenceOfPages.getPage(-1), throwsRangeError);
      expect(() => sequenceOfPages.getPage(2), throwsRangeError);
    });

    test('Should add a page to the sequence', () {
      final page3 = Page(components: []);
      sequenceOfPages.addPage(page3);

      expect(sequenceOfPages.pages.length, 3);
      expect(sequenceOfPages.pages[2], page3);
    });

    test('Should remove a page from the sequence', () {
      sequenceOfPages.removePage(page1);

      expect(sequenceOfPages.pages.length, 1);
      expect(sequenceOfPages.pages[0], page2);
    });

    test('Should not fail when removing a non-existent page', () {
      final page3 = Page(components: []);
      sequenceOfPages.removePage(page3);

      expect(sequenceOfPages.pages.length, 2);
    });
  });
}
