import 'dart:ui';

import 'package:luna_authoring_system/helper/color_conversions.dart';
import 'package:luna_authoring_system/pptx_data_objects/alpha.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/srgb_color.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_base_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/utils/types.dart';

/// This class is capable of building ConnectionShapes object
/// that represent lines in a PowerPoint file.
class PptxConnectionShapeBuilder extends PptxBaseShapeBuilder<ConnectionShape> {
  final PptxTransformBuilder _transformBuilder;

  PptxConnectionShapeBuilder(this._transformBuilder);

  /// Extracts the line color from the connection shape's line properties.
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

  /// Extracts the line width from the connection shape's line properties.
  EMU _getLineWidth(Json lineMap) {
    return EMU(int.parse(lineMap[eLine]?[eLineWidth] ??
        "${ConnectionShape.defaultWidth.value}"));
  }

  /// Builds a ConnectionShape object from the provided connection shape map.
  @override
  ConnectionShape buildShape(Json connectionShapeMap) {
    Transform transform =
        _transformBuilder.getTransform(connectionShapeMap[eShapeProperty][eTransform]);

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
}
