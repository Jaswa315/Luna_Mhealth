import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';

void main() {
  group('PptxHierarchy Enum Tests', () {
    test('Each hierarchy level has the correct parent', () {
      expect(PptxHierarchy.slide.parent, PptxHierarchy.slideLayout);
      expect(PptxHierarchy.slideLayout.parent, PptxHierarchy.slideMaster);
      expect(PptxHierarchy.slideMaster.parent, isNull);
    });

    test('Enum values are correctly defined', () {
      expect(PptxHierarchy.values.length, 3);
      expect(
          PptxHierarchy.values,
          containsAll([
            PptxHierarchy.slideMaster,
            PptxHierarchy.slideLayout,
            PptxHierarchy.slide,
          ]));
    });

    test('Enum toString returns the correct name', () {
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
      ]);
    });
    test('Each hierarchy level has the correct relationshipType', () {
      expect(PptxHierarchy.slideMaster.relationshipType,
          "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster");
      expect(PptxHierarchy.slideLayout.relationshipType,
          "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout");
      expect(PptxHierarchy.slide.relationshipType,
          "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide");
    });

    test('Parent and relationshipType traversal works correctly', () {
      PptxHierarchy? current = PptxHierarchy.slide;
      List<String?> relationshipTypes = [];

      while (current != null) {
        relationshipTypes.add(current.relationshipType);
        current = current.parent;
      }

      expect(relationshipTypes, [
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide",
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout",
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster",
      ]);
    });

    test('xmlKey is set correctly for all enums.', () {
      PptxHierarchy? current = PptxHierarchy.slide;
      List<String> xmlKeys = [];

      while (current != null) {
        xmlKeys.add(current.xmlKey);
        current = current.parent;
      }

      expect(xmlKeys, [
        "p:sld",
        "p:sldLayout",
        "p:sldMaster",
      ]);
    });
  });
}
