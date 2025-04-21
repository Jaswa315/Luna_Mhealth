import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';

void main() {
  group('SequenceOfPages Tests', () {
    late SequenceOfPages sequenceOfPages;
    late Page page1;
    late Page page2;
    late Page page3;

    setUp(() {
      // Initialize test data
      page1 = Page(components: []);
      page2 = Page(components: []);
      page3 = Page(components: []);
    });

    test('Should return the correct list of pages', () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      expect(sequenceOfPages.pages.length, 2);
      expect(sequenceOfPages.pages[0], page1);
      expect(sequenceOfPages.pages[1], page2);
    });

    test('Should get a page by index', () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      expect(sequenceOfPages.getPage(0), page1);
      expect(sequenceOfPages.getPage(1), page2);
    });

    test('Should throw RangeError for invalid index', () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      expect(() => sequenceOfPages.getPage(-1), throwsRangeError);
      expect(() => sequenceOfPages.getPage(2), throwsRangeError);
    });

    test('Should add a page to the sequence', () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      sequenceOfPages.addPage(page3);

      expect(sequenceOfPages.pages.length, 3);
      expect(sequenceOfPages.pages[2], page3);
    });

    test('Should remove a page from the sequence', () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      sequenceOfPages.removePage(page1);

      expect(sequenceOfPages.pages.length, 1);
      expect(sequenceOfPages.pages[0], page2);
    });

    test('Should not fail when removing a non-existent page', () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      sequenceOfPages.removePage(page3);

      expect(sequenceOfPages.pages.length, 2);
    });

    test('Should correctly identify the leftmost page', () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      expect(sequenceOfPages.isLeftMostPage(page1), true);
      expect(sequenceOfPages.isLeftMostPage(page2), false);

      // Add a new page and verify
      sequenceOfPages.addPage(page3);
      expect(sequenceOfPages.isLeftMostPage(page1), true);
    });

    test('Should correctly identify the rightmost page', () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      expect(sequenceOfPages.isRightMostPage(page2), true);
      expect(sequenceOfPages.isRightMostPage(page1), false);

      // Add a new page and verify
      sequenceOfPages.addPage(page3);
      expect(sequenceOfPages.isRightMostPage(page3), true);
    });

    test(
        'Should correctly identify if a page is between the first and last pages',
        () {
      sequenceOfPages = SequenceOfPages(pages: [page1, page2, page3]);

      expect(sequenceOfPages.isBetweenFirstAndLastPage(page1), false);
      expect(sequenceOfPages.isBetweenFirstAndLastPage(page3), false);
      expect(sequenceOfPages.isBetweenFirstAndLastPage(page2), true);
      // Sequence with fewer than 3 pages
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      expect(sequenceOfPages.isBetweenFirstAndLastPage(page1), false);
      expect(sequenceOfPages.isBetweenFirstAndLastPage(page2), false);

      // Empty sequence
      sequenceOfPages = SequenceOfPages(pages: []);
      expect(sequenceOfPages.isBetweenFirstAndLastPage(page1), false);
    });

    test('Should correctly identify if a page is the only page in the sequence',
        () {
      // Sequence with a single page
      sequenceOfPages = SequenceOfPages(pages: [page1]);
      expect(sequenceOfPages.isOnlyPage(page1), true);

      // Sequence with multiple pages
      sequenceOfPages = SequenceOfPages(pages: [page1, page2]);
      expect(sequenceOfPages.isOnlyPage(page1), false);
      expect(sequenceOfPages.isOnlyPage(page2), false);

      // Empty sequence
      sequenceOfPages = SequenceOfPages(pages: []);
      expect(sequenceOfPages.isOnlyPage(page1), false);
    });
  });
}
