import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'dart:io';

PptxRelationshipParser getPptxRelationshipParser(PptxHierarchy pptxHierarchy) {
  final pptxFile = File('test/test_assets/Sections.pptx');
  PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
  return PptxRelationshipParser(pptxLoader, pptxHierarchy);
}

void main() {
  group('PptxRelationshipParser Tests for Slide', () {
    PptxRelationshipParser pptxSlideRelationshipParser =
        getPptxRelationshipParser(PptxHierarchy.slide);

    test('getParentIndex returns correct slideLayout index for a slide', () {
      int slideIndex = 1;
      int slideLayoutIndex =
          pptxSlideRelationshipParser.getParentIndex(slideIndex);

      expect(slideLayoutIndex, 1);
    });

    test('Throws exception for invalid slide index', () {
      expect(
        () => pptxSlideRelationshipParser.getParentIndex(999),
        throwsException,
      );
    });
  });

  group('PptxRelationshipParser Tests for SlideLayout', () {
    PptxRelationshipParser pptxSlideLayoutRelationshipParser =
        getPptxRelationshipParser(PptxHierarchy.slideLayout);

    test('getParentIndex returns correct slideMaster index for a slideLayout',
        () {
      int slideLayoutIndex = 1;
      int slideMasterIndex =
          pptxSlideLayoutRelationshipParser.getParentIndex(slideLayoutIndex);

      expect(slideMasterIndex, 1);
    });

    test('Throws exception for invalid slideLayout index', () {
      expect(
        () => pptxSlideLayoutRelationshipParser.getParentIndex(999),
        throwsException,
      );
    });
  });

  group('PptxRelationshipParser Tests for SlideMaster', () {
    PptxRelationshipParser pptxSlideMasterRelationshipParser =
        getPptxRelationshipParser(PptxHierarchy.slideMaster);

    test('getParentIndex returns correct theme index for a slideMaster', () {
      int slideMasterIndex = 1;
      int themeIndex =
          pptxSlideMasterRelationshipParser.getParentIndex(slideMasterIndex);

      expect(themeIndex, 1);
    });

    test('Throws exception for invalid slideMaster index', () {
      expect(
        () => pptxSlideMasterRelationshipParser.getParentIndex(999),
        throwsException,
      );
    });
  });

  group('PptxRelationshipParser Tests for Theme', () {
    PptxRelationshipParser pptxThemeRelationshipParser =
        getPptxRelationshipParser(PptxHierarchy.theme);

    test('Throws exception for theme as it has no parent', () {
      expect(
        () => pptxThemeRelationshipParser.getParentIndex(1),
        throwsException,
      );
    });
  });
}
