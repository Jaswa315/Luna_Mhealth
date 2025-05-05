import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/document_property/pptx_document_property_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/document_property/pptx_document_property_constants.dart';
import 'package:mockito/mockito.dart';

class MockPptxXmlToJsonConverter extends Mock implements PptxXmlToJsonConverter {}

void main() {
  late MockPptxXmlToJsonConverter mockPptxLoader;
  late PptxDocumentPropertyBuilder pptxDocumentPropertyBuilder;
  final mockJson = {
    eCoreProperties: {
      eTitle: "A Title Name",
      eAuthor: "An Author Name",
    },
  };

  setUp(() {
    mockPptxLoader = MockPptxXmlToJsonConverter();

    when(mockPptxLoader.getJsonFromPptx('docProps/core.xml')).thenReturn(mockJson);
  });

  test('PptxDocumentPropertBuilder sets author and title in CTOR.', () {
    pptxDocumentPropertyBuilder = PptxDocumentPropertyBuilder(mockPptxLoader);

    expect(pptxDocumentPropertyBuilder.title, "A Title Name");
    expect(pptxDocumentPropertyBuilder.author, "An Author Name");
  });
}
