import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/utils/emu.dart';

/// The ConnectionShape represents the connectors in the PowerPoint.
/// weight represents the thickness of the connector.
class ConnectionShape implements Shape {
  static EMU defaultWidth = EMU(6350); // Default width (0.5pt)
  static String defaultColor = "#000000"; // Default color (black)
  static int defaultShape = 1;

  EMU width;

  String color;

  int shape;

  @override
  Transform transform;

  bool isFlippedVertically;

  ConnectionShape({
    EMU? width,
    String? color,
    int? shape,
    required this.isFlippedVertically,
    required this.transform,
  })  : width = width ?? defaultWidth,
        color = color ?? defaultColor,
        shape = shape ?? defaultShape;

  @override
  ShapeType get type => ShapeType.connection;
}
