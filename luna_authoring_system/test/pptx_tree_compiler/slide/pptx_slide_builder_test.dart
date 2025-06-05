import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide/pptx_slide_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide/pptx_slide_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'package:luna_core/utils/types.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../mocks/mock.mocks.dart';

void stubMockPptxLoader(MockPptxXmlToJsonConverter mockPptxLoader,
    PptxHierarchy hierarchy, int slideIndex, Json shapeTree) {
  when(mockPptxLoader.getJsonFromPptx(
          "ppt/${hierarchy.name}s/${hierarchy.name}$slideIndex.xml"))
      .thenReturn({
    hierarchy.xmlKey: {
      eCommonSlideData: {eShapeTree: shapeTree}
    }
  });
}

void main() {
  late PptxSlideBuilder pptxSlideBuilder;
  late MockPptxXmlToJsonConverter mockPptxLoader;
  late MockPptxSlideCountParser mockPptxSlideCountParser;
  late MockPptxShapeBuilder mockPptxShapeBuilder;
  late MockPptxRelationshipParser mockPptxRelationshipParser;
  MockConnectionShape mockConnectionShape = MockConnectionShape();
  const int mockSlideIndex = 1;
  const int mockSlideCount = 1;
  const Json mockShapeTree = {eConnectionShape: []};
  const Json mockEmptyShapeTree = {"": []};

  setUp(() {
    mockPptxLoader = MockPptxXmlToJsonConverter();
    mockPptxSlideCountParser = MockPptxSlideCountParser();
    mockPptxShapeBuilder = MockPptxShapeBuilder();
    mockPptxRelationshipParser = MockPptxRelationshipParser();

    when(mockPptxShapeBuilder.getShapes({eConnectionShape: []}, any, any))
        .thenReturn([mockConnectionShape]);
    when(mockPptxSlideCountParser.slideCount).thenReturn(mockSlideCount);
    when(mockPptxRelationshipParser.getParentIndex(any, any))
        .thenReturn(mockSlideIndex);

    pptxSlideBuilder = PptxSlideBuilder(
        mockPptxLoader,
        mockPptxSlideCountParser,
        mockPptxShapeBuilder,
        mockPptxRelationshipParser);
  });

  group('PptxSlideBuilder Tests', () {
    test('A single shape is retrieved from the slide hierarchy.', () {
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slideMaster,
          mockSlideIndex, mockEmptyShapeTree);
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slideLayout,
          mockSlideIndex, mockEmptyShapeTree);
      stubMockPptxLoader(
          mockPptxLoader, PptxHierarchy.slide, mockSlideIndex, mockShapeTree);
      List<Slide> slides = pptxSlideBuilder.getSlides();

      expect(slides.length, 1);
      expect(slides[0].shapes!.length, 1);
    });

    test('A single shape is retrieved from the slide layout hierarchy.', () {
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slideMaster,
          mockSlideIndex, mockEmptyShapeTree);
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slideLayout,
          mockSlideIndex, mockShapeTree);
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slide, mockSlideIndex,
          mockEmptyShapeTree);

      List<Slide> slides = pptxSlideBuilder.getSlides();

      expect(slides.length, 1);
      expect(slides[0].shapes!.length, 1);
    });

    test(
        'A single connection shape is retrieved from the slide master hierarchy.',
        () {
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slideMaster,
          mockSlideIndex, mockShapeTree);
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slideLayout,
          mockSlideIndex, mockEmptyShapeTree);
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slide, mockSlideIndex,
          mockEmptyShapeTree);

      List<Slide> slides = pptxSlideBuilder.getSlides();

      expect(slides.length, 1);
      expect(slides[0].shapes!.length, 1);
    });

    test('Shapes are retrieved from all hierarchies.', () {
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slideMaster,
          mockSlideIndex, mockShapeTree);
      stubMockPptxLoader(mockPptxLoader, PptxHierarchy.slideLayout,
          mockSlideIndex, mockShapeTree);
      stubMockPptxLoader(
          mockPptxLoader, PptxHierarchy.slide, mockSlideIndex, mockShapeTree);

      List<Slide> slides = pptxSlideBuilder.getSlides();

      expect(slides.length, 1);
      expect(slides[0].shapes!.length, 3);
    });
  });
}
