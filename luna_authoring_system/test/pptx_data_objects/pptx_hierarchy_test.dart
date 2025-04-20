import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';

void main() {
  group('PptxHierarchy Enum Tests', () {
    test('Each hierarchy level has the correct parent', () {
      expect(PptxHierarchy.slide.parent, PptxHierarchy.slideLayout);
      expect(PptxHierarchy.slideLayout.parent, PptxHierarchy.slideMaster);
      expect(PptxHierarchy.slideMaster.parent, PptxHierarchy.theme);
      expect(PptxHierarchy.theme.parent, isNull);
    });

    test('Enum values are correctly defined', () {
      expect(PptxHierarchy.values.length, 4);
      expect(PptxHierarchy.values, containsAll([
        PptxHierarchy.theme,
        PptxHierarchy.slideMaster,
        PptxHierarchy.slideLayout,
        PptxHierarchy.slide,
      ]));
    });

    test('Enum toString returns the correct name', () {
      expect(PptxHierarchy.theme.name, 'theme');
      expect(PptxHierarchy.slideMaster.name, 'slideMaster');
      expect(PptxHierarchy.slideLayout.name, 'slideLayout');
      expect(PptxHierarchy.slide.name, 'slide');
    });

    test('Parent traversal works correctly', () {
      PptxHierarchy? current = PptxHierarchy.slide;
      List<PptxHierarchy> hierarchy = [];

      while (current != null) {
        hierarchy.add(current);
        current = current.parent;
      }

      expect(hierarchy, [
        PptxHierarchy.slide,
        PptxHierarchy.slideLayout,
        PptxHierarchy.slideMaster,
        PptxHierarchy.theme,
      ]);
    });
  });
}