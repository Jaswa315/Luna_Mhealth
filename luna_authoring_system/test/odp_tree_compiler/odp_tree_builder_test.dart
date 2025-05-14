import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/odp_tree_compiler/odp_tree_builder.dart';
import 'package:luna_authoring_system/odp_tree_compiler/odp_xml_element_constants.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/units/emu.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks
@GenerateNiceMocks([MockSpec<PptxXmlToJsonConverter>()])
import 'odp_tree_builder_test.mocks.dart';

void main() {
  group('Tests for OdpTreeBuilder', () {
    late MockPptxXmlToJsonConverter mockConverter;
    late OdpTreeBuilder odpTreeBuilder;

    // Constants for test data
    const mockTitle = 'A title';
    const mockAuthor = 'Author Name';
    const mockPageLayoutName = 'PM0';
    const mockPageWidth = '28cm';
    const mockPageHeight = '15.75cm';
    const mockX1 = '5.08cm';
    const mockX2 = '18.415cm';
    const mockY1 = '10.16cm';
    const mockY2 = '10.16cm';

    setUp(() {
      mockConverter = MockPptxXmlToJsonConverter();
      when(mockConverter.getJsonFromPptx("meta.xml")).thenReturn({
        eMetaDocument: {
          eMeta: {
            eTitle: mockTitle,
            eAuthor: mockAuthor,
          }
        }
      });
       when(mockConverter.getJsonFromPptx("styles.xml")).thenReturn({
        eStylesDocument: {
          eMasterStyles: {
            eMasterPage: {
              ePageLayoutName: mockPageLayoutName
            }
          },
          eAutomaticStyles: {
            ePageLayout: [
              {
                ePageLayoutProperties: {
                  ePageWidth: mockPageWidth,
                  ePageHeight: mockPageHeight,
                }
              }
            ]
          }
        }
      });
      when(mockConverter.getJsonFromPptx("content.xml")).thenReturn({
        eContentDocument: {
          eBody: {
            ePresentation: {
              ePage: [
                {
                  eConnectionShape: {
                    eX1: mockX1,
                    eX2: mockX2,
                    eY1: mockY1,
                    eY2: mockY2,
                  }
                }
              ]
            }
          }
        }
      });
      odpTreeBuilder = OdpTreeBuilder(mockConverter);
    });

    test('odpTree method initializes title.', () async {
      final odpTree = odpTreeBuilder.getOdpTree();
      expect(odpTree.title, mockTitle);
    });

    test('odpTree method initializes author.', () async {
      final odpTree = odpTreeBuilder.getOdpTree();
      expect(odpTree.author, mockAuthor);
    });

    test('odpTree method initializes width.', () async {
      final odpTree = odpTreeBuilder.getOdpTree();
      expect(odpTree.width, isA<EMU>());
      expect(odpTree.width.value, 10080000);
    });

    test('odpTree method initializes height.', () async {
      final odpTree = odpTreeBuilder.getOdpTree();
      expect(odpTree.height, isA<EMU>());
      expect(odpTree.height.value, 5670000);
    });

    test('A horizontal line is parsed', () async {
      final odpTree = odpTreeBuilder.getOdpTree();
      expect(odpTree.slides, isA<List<Slide>>());
      expect(odpTree.slides.length, 1);

      final slide = odpTree.slides[0];
      expect(slide.shapes, isA<List<Shape>>());
      expect(slide.shapes!.length, 1);

      final horizontalLine = slide.shapes![0] as ConnectionShape;
      expect(horizontalLine.type, ShapeType.connection);
      expect(horizontalLine.width.value, 6350);
      expect((horizontalLine.transform.offset.x as EMU).value, 1828800);
      expect((horizontalLine.transform.offset.y as EMU).value, 3657600);
      expect((horizontalLine.transform.size.x as EMU).value, 4800600);
      expect((horizontalLine.transform.size.y as EMU).value, 0);
      expect(horizontalLine.isFlippedVertically, false);
    });

  });
}