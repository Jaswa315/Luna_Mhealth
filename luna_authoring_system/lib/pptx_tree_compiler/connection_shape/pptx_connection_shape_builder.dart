import 'dart:ui';

import 'package:luna_authoring_system/helper/color_conversions.dart';
import 'package:luna_authoring_system/pptx_data_objects/alpha.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/srgb_color.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_constants.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/utils/types.dart';

/// This class parses slide{n}.xml and slideLayout{n}.xml files,
/// where it is capable of building ConnectionShapes object
/// that represent lines in a PowerPoint file.
class PptxConnectionShapeBuilder {
  PptxConnectionShapeBuilder();

  Transform _getTransform(Json transformMap) {
    Point2D offset = Point2D(
      EMU(int.parse(transformMap[eOffset][eX])),
      EMU(int.parse(transformMap[eOffset][eY])),
    );

    Point2D size = Point2D(
      EMU(int.parse(transformMap[eSize][eCX])),
      EMU(int.parse(transformMap[eSize][eCY])),
    );

    return Transform(
      offset,
      size,
    );
  }

  Color _getLineColor(Json lineMap) {
    SrgbColor color = SrgbColor(lineMap[eLine]?[eSolidFill]?[eSrgbColor]
            ?[eValue] ??
        SrgbColor.defaultColor);
    Alpha alpha =
        Alpha(int.parse(lineMap[eLine]?[eAlpha] ?? "${Alpha.maxAlpha}"));
    Color lineColor =
        ColorConversions.updateSrgbColorAndAlphaToFlutterColor(color, alpha);

    return lineColor;
  }

  EMU _getLineWidth(Json lineMap) {
    return EMU(int.parse(lineMap[eLine]?[eLineWidth] ??
        "${ConnectionShape.defaultWidth.value}"));
  }

  ConnectionShape _buildConnectionShape(Json connectionShapeMap) {
    Transform transform =
        _getTransform(connectionShapeMap[eShapeProperty][eTransform]);

    Color lineColor = _getLineColor(connectionShapeMap[eShapeProperty]);

    EMU lineWidth = _getLineWidth(connectionShapeMap[eShapeProperty]);

    // Extracts the flipVertical attribute from the connection shape's transform properties.
    // set to true if attribute is "1", false otherwise
    bool isFlippedVertically = connectionShapeMap[eShapeProperty]?[eTransform]
                ?[flipVertical]
            ?.toString() ==
        "1";

    return ConnectionShape(
      transform: transform,
      isFlippedVertically: isFlippedVertically,
      color: lineColor,
      width: lineWidth,
    );
  }

  List<Shape> getConnectionShapes(dynamic shapeTree) {
    List<Shape> shapes = [];

    if (shapeTree is List) {
      for (Json connectionShape in shapeTree) {
        shapes.add(_buildConnectionShape(connectionShape));
      }
    } else if (shapeTree is Map) {
      shapes.add(_buildConnectionShape(shapeTree as Json));
    } else {
      throw Exception(
        "Invalid connection shape format: $shapeTree",
      );
    }

    return shapes;
  }
}
