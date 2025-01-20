import 'package:built_value/built_value.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape_type.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform.dart';
import 'package:luna_core/utils/emu.dart';

part 'connection_shape.g.dart';

/// The ConnectionShape represents the connectors in the PowerPoint.
/// weight represents the thickness of the connector.
/// The ShapeType is set to connection whenever a builder is created.
abstract class ConnectionShape implements Shape, Built<ConnectionShape, ConnectionShapeBuilder> {
  EMU? get weight;

  @BuiltValueHook(finalizeBuilder: true)
  static void _setShapeType(ConnectionShapeBuilder b) =>
    b..type = ShapeType.connection;

  ConnectionShape._();

  factory ConnectionShape([updates(ConnectionShapeBuilder b)]) = _$ConnectionShape;
}