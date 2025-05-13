import 'package:mockito/annotations.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';

@GenerateMocks([PptxTree, Slide, Shape])
@GenerateNiceMocks([
  MockSpec<PptxTransformBuilder>(),
  MockSpec<Transform>(),
  MockSpec<PptxConnectionShapeBuilder>(),
  MockSpec<ConnectionShape>(),
  MockSpec<PptxXmlToJsonConverter>(),
  MockSpec<PptxSlideCountParser>(),
  MockSpec<PptxShapeBuilder>(),
  MockSpec<PptxRelationshipParser>(),
])
void main() {}
