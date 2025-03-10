import 'package:flutter/material.dart';
import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/helper/emu_conversions.dart';
import 'package:luna_authoring_system/helper/line_positioner.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';

class LineBuilder implements IBuilder<LineComponent> {
  final int _moduleWidth;
  final int _moduleHeight;
  late Point2DPercentage _startPoint;
  late Point2DPercentage _endPoint;
  late Color _color;
  late double _thickness;
  late BorderStyle _style;

  LineBuilder(this._moduleWidth, this._moduleHeight);

  LineBuilder setStartAndEndPoints(ConnectionShape shape) {
    final points = LinePositioner.getStartAndEndPoints(
      shape,
      _moduleWidth,
      _moduleHeight,
    );
    _startPoint = points['startPoint']!;
    _endPoint = points['endPoint']!;

    return this;
  }

  LineBuilder setThickness(ConnectionShape shape) {
    _thickness = EmuConversions.updateThicknessToDisplayPixels(shape.width);

    return this;
  }

  LineBuilder setColor(ConnectionShape shape) {
    _color = shape.color;

    return this;
  }

  LineBuilder setStyle(ConnectionShape shape) {
    _style = shape.style;

    return this;
  }

  @override
  LineComponent build() {
    return LineComponent(
      startPoint: _startPoint,
      endPoint: _endPoint,
      color: _color,
      thickness: _thickness,
      style: _style,
    );
  }
}
