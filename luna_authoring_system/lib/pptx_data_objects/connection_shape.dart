import 'package:flutter/rendering.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/units/emu.dart';

/// The ConnectionShape represents the connectors in the PowerPoint.
/// weight represents the thickness of the connector.
class ConnectionShape implements Shape {
  static EMU defaultWidth = EMU(6350); // Default width (0.5pt)
  static Color defaultColor =
      const Color.fromARGB(255, 0, 0, 0); // Default color (black)
  static BorderStyle defaultStyle = BorderStyle.solid;

  EMU width;

  Color color;

  BorderStyle style;

  @override
  Transform transform;

  bool isFlippedVertically;

  ConnectionShape({
    EMU? width,
    Color? color,
    BorderStyle? style,
    required this.isFlippedVertically,
    required this.transform,
  })  : width = width ?? defaultWidth,
        color = color ?? defaultColor,
        style = style ?? defaultStyle;

  @override
  ShapeType get type => ShapeType.connection;
}
