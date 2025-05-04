import 'package:flutter/material.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_core/utils/types.dart';
import 'package:luna_mobile/renderers/line_component_renderer.dart';

/// Represents a line component that can be used in the Luna mHealth Mobile app.
/// This component provides a line to separate content sections visually,
/// with customizable properties like color, thickness, and style.
/// It relies on `startPoint` and `endPoint` directly for its rendering.
class LineComponent extends Component {
  /// The start point of the line in percentage coordinates.
  final Point startPoint;

  /// The end point of the line in percentage coordinates.
  final Point endPoint;

  /// The color of the line.
  final Color color;

  /// The thickness of the line in logical pixels.
  final double thickness;

  /// The style of the line's border.
  final BorderStyle style;

  /// Constructs a new instance of [LineComponent].
  /// Parameters:
  /// - [color]: The color of the line. Defaults to `Color.fromARGB(255, 43, 116, 179)`.
  /// - [thickness]: The thickness of the line in logical pixels. Defaults to 5.0.
  /// - [style]: The border style of the line. Defaults to `BorderStyle.solid`.
  /// - [startPoint]: The start point of the line in percentage coordinates.
  /// - [endPoint]: The end point of the line in percentage coordinates.
  LineComponent({
    required this.color,
    required this.thickness,
    required this.style,
    required this.startPoint,
    required this.endPoint,
  }) : super(name: 'LineComponent');

  /// Renders the line as a [Widget].
  @override
  Future<Widget> render(Size screenSize) async {
    return LineComponentRenderer().renderComponent(this, screenSize);
  }

  /// Converts the current [LineComponent] instance to a JSON object.
  /// Returns: A [Json] object containing all the properties of the line.
  Json toJson() {
    return {
      'type': 'line',
      'startPoint': {
        'x': (startPoint.x as Percent).value,
        'y': (startPoint.y as Percent).value,
      },
      'endPoint': {
        'x': (endPoint.x as Percent).value,
        'y': (endPoint.y as Percent).value,
      },
      'color': color.toARGB32(),
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
      startPoint: Point(
        Percent((json['startPoint']['x'] as num).toDouble()),
        Percent((json['startPoint']['y'] as num).toDouble()),
      ),
      endPoint: Point(
        Percent((json['endPoint']['x'] as num).toDouble()),
        Percent((json['endPoint']['y'] as num).toDouble()),
      ),
      color: Color(json['color']),
      thickness: (json['thickness'] as num).toDouble(),
      style: BorderStyle.values[json['style']],
    );
  }
}
