import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'dart:io';

void main() {
  group('Tests for Section', () {
    final pptxFile = File('test/test_assets/Sections.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxRelationshipParser pptxRelationshipParser =
        PptxRelationshipParser(pptxLoader);
    group('PptxRelationshipParser Tests for Slide', () {
      test('getParentIndex returns correct slideLayout index for a slide', () {
        int slideIndex = 1;
        int slideLayoutIndex = pptxRelationshipParser.getParentIndex(
            slideIndex, PptxHierarchy.slide);

        expect(slideLayoutIndex, 1);
      });

      test('Throws exception for invalid slide index', () {
        expect(
          () => pptxRelationshipParser.getParentIndex(999, PptxHierarchy.slide),
          throwsException,
        );
      });
    });

    group('PptxRelationshipParser Tests for SlideLayout', () {
      test('getParentIndex returns correct slideMaster index for a slideLayout',
          () {
        int slideLayoutIndex = 1;
        int slideMasterIndex = pptxRelationshipParser.getParentIndex(
            slideLayoutIndex, PptxHierarchy.slideLayout);

        expect(slideMasterIndex, 1);
      });

      test('Throws exception for invalid slideLayout index', () {
        expect(
          () => pptxRelationshipParser.getParentIndex(
              999, PptxHierarchy.slideLayout),
          throwsException,
        );
      });
    });

    group('PptxRelationshipParser Tests for SlideMaster', () {
      test('Throws exception for invalid slideMaster index', () {
        expect(
          () => pptxRelationshipParser.getParentIndex(
              999, PptxHierarchy.slideMaster),
          throwsException,
        );
      });
    });
  });

  group('Tests for Picture', () {
    final pptxFile = File('test/test_assets/1 Picture.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxRelationshipParser pptxRelationshipParser =
        PptxRelationshipParser(pptxLoader);

    test('findTargetByRId returns correct target for a given rId', () {
      int slideIndex = 1;
      PptxHierarchy pptxHierarchy = PptxHierarchy.slide;
      String rId = 'rId2';

      String target = pptxRelationshipParser.findTargetByRId(
          slideIndex, pptxHierarchy, rId);

      expect(target, '../media/image1.jpeg');
    });

    test('Throws exception for invalid rId', () {
      int slideIndex = 1;
      PptxHierarchy pptxHierarchy = PptxHierarchy.slide;
      String rId = 'invalidRId';

      expect(
        () => pptxRelationshipParser.findTargetByRId(
            slideIndex, pptxHierarchy, rId),
        throwsException,
      );
    });
  });
}
