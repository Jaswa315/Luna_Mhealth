import 'package:flutter/material.dart';
import 'package:luna_core/enums/component_type.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';
import 'package:luna_core/utils/types.dart';
import 'package:luna_mobile/renderers/line_component_renderer.dart';

/// Represents a line component that can be used in the Luna mHealth Mobile app.
/// This component provides a line to separate content sections visually,
/// with customizable properties like color, thickness, and style.
class LineComponent extends Component {
  /// The start point of the line in percentage coordinates.
  final Point2DPercentage startPoint;

  /// The end point of the line in percentage coordinates.
  final Point2DPercentage endPoint;

  /// The color of the line.
  final Color color;

  /// The thickness of the line in logical pixels.
  final double thickness;

  /// The style of the line's border.
  final BorderStyle style;

  /// Overrides `x, y, width, height` dynamically based on `startPoint` and `endPoint`.
  static double _calculateWidth(
    Point2DPercentage start,
    Point2DPercentage end,
  ) {
    return (end.x - start.x).abs();
  }

  static double _calculateHeight(
    Point2DPercentage start,
    Point2DPercentage end,
  ) {
    return (end.y - start.y).abs();
  }

  /// Constructs a new instance of [LineComponent].
  /// Parameters:
  /// - [color]: The color of the line. Defaults to `Color.fromARGB(255, 43, 116, 179)`.
  /// - [thickness]: The thickness of the line in logical pixels. Defaults to 5.0.
  /// - [style]: The border style of the line. Defaults to `BorderStyle.solid`.
  /// - [x]: The x-coordinate position of the line's top-left corner.
  /// - [y]: The y-coordinate position of the line's top-left corner.
  /// - [width]: The width of the line.
  /// - [height]: The height of the line.
  /// - [startPoint]: The start point of the line in percentage coordinates.
  /// - [endPoint]: The end point of the line in percentage coordinates.
  LineComponent({
    required this.color,
    required this.thickness,
    required this.style,
    required this.startPoint,
    required this.endPoint,
  }) : super(
          type: ComponentType.line,
          x: startPoint.x,
          y: startPoint.y,
          width: _calculateWidth(startPoint, endPoint),
          height: _calculateHeight(startPoint, endPoint),
          name: 'LineComponent',
        );

  /// Renders the line as a [Widget].
  @override
  Future<Widget> render(Size screenSize) async {
    return LineComponentRenderer().renderComponent(this, screenSize);
  }

  /// Converts the current [LineComponent] instance to a JSON object.
  /// Returns: A [Json] object containing all the properties of the line.
  @override
  Json toJson() {
    return {
      'type': type.name,
      'startPoint': {'x': startPoint.x, 'y': startPoint.y},
      'endPoint': {'x': endPoint.x, 'y': endPoint.y},
      'color': color.value,
      'thickness': thickness,
      'style': style.index,
    };
  }

  /// Creates a new [LineComponent] instance from a JSON object.
  /// Parameters: - [json]: A [Json] object containing the data to initialize the line.
  /// Returns: A [LineComponent] instance with properties derived from the JSON object.
  /// Throws: An [Exception] if the JSON is missing required fields like `x`, `y`, `width`, or `height`.
  static LineComponent fromJson(Json json) {
    return LineComponent(
      startPoint: Point2DPercentage(
        json['startPoint']['x'].toDouble(),
        json['startPoint']['y'].toDouble(),
      ),
      endPoint: Point2DPercentage(
        json['endPoint']['x'].toDouble(),
        json['endPoint']['y'].toDouble(),
      ),
      color: Color(json['color']),
      thickness: (json['thickness'] as num).toDouble(),
      style: BorderStyle.values[json['style']],
    );
  }
}
