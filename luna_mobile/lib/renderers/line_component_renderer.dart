import 'package:flutter/material.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/utils/percentage_conversion.dart';
import 'package:luna_mobile/renderers/line_painter.dart';

import 'base_component_renderer.dart';

/// A renderer class for the `LineComponent`.
/// This class is responsible for rendering a line component on the screen
/// based on the specified properties such as start and end positions, thickness, and color.
/// It uses the `LinePainter` to draw the line on a canvas.
class LineComponentRenderer extends BaseComponentRenderer<LineComponent> {
  /// Renders the given `LineComponent` as a widget.
  ///[component] is expected to be of type `LineComponent`
  /// [screenSize] provides the dimensions of the screen or parent container
  /// within which the component will be rendered.
  /// Throws an [ArgumentError] if the component is not of type `LineComponent`.
  @override
  Widget renderComponent(dynamic component, Size screenSize) {
    if (component is LineComponent) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final start = PercentageConversion.updatePercentageToDisplayPixel(
            component.startPoint,
            Size(constraints.maxWidth, constraints.maxHeight),
          );
          final end = PercentageConversion.updatePercentageToDisplayPixel(
            component.endPoint,
            Size(constraints.maxWidth, constraints.maxHeight),
          );

          return CustomPaint(
            painter: LinePainter(
              start: start,
              end: end,
              thickness: component.thickness.toDouble(),
              color: component.color,
            ),
            size: Size(constraints.maxWidth, constraints.maxHeight),
          );
        },
      );
    } else {
      // Throw an error if the provided component is not a LineComponent
      throw ArgumentError(
        'Invalid component type for LineComponentRenderer',
      );
    }
  }
}
