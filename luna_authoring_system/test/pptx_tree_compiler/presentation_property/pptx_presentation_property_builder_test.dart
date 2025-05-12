import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/presentation_property/pptx_presentation_property_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/presentation_property/pptx_presentation_property_constants.dart';
import 'package:mockito/mockito.dart';

// Create a mock clcass for PptxXmlToJsonConverter.
class MockPptxXmlToJsonConverter extends Mock implements PptxXmlToJsonConverter {}

void main() {
  late MockPptxXmlToJsonConverter mockPptxLoader;
  late PptxPresentationPropertyBuilder pptxPresentationPropertyBuilder;
  final mockJson = {
    ePresentation: {
      eSlideSize: {
        eCX: '12192000',
        eCY: '6858000',
      },
    },
  };

  setUp(() {
    mockPptxLoader = MockPptxXmlToJsonConverter();
    
    when(mockPptxLoader.getJsonFromPptx('ppt/presentation.xml')).thenReturn(mockJson);
  });

  test('PptxPresentationPropertyParser sets slide width and slide height in CTOR.', () {
    pptxPresentationPropertyBuilder = PptxPresentationPropertyBuilder(mockPptxLoader);
    
    expect(pptxPresentationPropertyBuilder.width.value, 12192000);
    expect(pptxPresentationPropertyBuilder.height.value, 6858000);
  });
}
