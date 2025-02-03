import 'package:flutter/material.dart';
import 'package:luna_core/enums/component_type.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';
import 'package:luna_core/renderers/divider_component_renderer.dart';
import 'package:luna_core/utils/types.dart';

/// Represents a divider component that can be used in the Luna mHealth Mobile app.
/// This component provides a line to separate content sections visually,
/// with customizable properties like color, thickness, and style.
class DividerComponent extends Component {
  /// The start point of the divider in percentage coordinates.
  final Point2DPercentage startPoint;

  /// The end point of the divider in percentage coordinates.
  final Point2DPercentage endPoint;

  /// The color of the divider.
  Color color;

  /// The thickness of the divider line in logical pixels.
  int thickness;

  /// The style of the divider's border.
  BorderStyle style;

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

  /// Constructs a new instance of [DividerComponent].
  /// Parameters:
  /// - [color]: The color of the divider. Defaults to `Color.fromARGB(255, 43, 116, 179)`.
  /// - [thickness]: The thickness of the divider in logical pixels. Defaults to 5.0.
  /// - [style]: The border style of the divider. Defaults to `BorderStyle.solid`.
  /// - [x]: The x-coordinate position of the divider's top-left corner.
  /// - [y]: The y-coordinate position of the divider's top-left corner.
  /// - [width]: The width of the divider.
  /// - [height]: The height of the divider.
  /// - [startPoint]: The start point of the divider in percentage coordinates.
  /// - [endPoint]: The end point of the divider in percentage coordinates.
  DividerComponent({
    this.color = const Color.fromARGB(255, 43, 116, 179),
    this.thickness = 5,
    this.style = BorderStyle.solid,
    required this.startPoint,
    required this.endPoint,
  }) : super(
          type: ComponentType.divider,
          x: startPoint.x,
          y: startPoint.y,
          width: _calculateWidth(startPoint, endPoint),
          height: _calculateHeight(startPoint, endPoint),
          name: 'DividerComponent',
        );

  /// Renders the divider as a [Widget].
  @override
  Future<Widget> render(Size screenSize) async {
    return DividerComponentRenderer().renderComponent(this, screenSize);
  }

  /// Converts the current [DividerComponent] instance to a JSON object.
  /// Returns: A [Json] object containing all the properties of the divider.
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

  /// Creates a new [DividerComponent] instance from a JSON object.
  /// Parameters: - [json]: A [Json] object containing the data to initialize the divider.
  /// Returns: A [DividerComponent] instance with properties derived from the JSON object.
  /// Throws: An [Exception] if the JSON is missing required fields like `x`, `y`, `width`, or `height`.
  static DividerComponent fromJson(Json json) {
    return DividerComponent(
      startPoint: Point2DPercentage(
        json['startPoint']['x'].toDouble(),
        json['startPoint']['y'].toDouble(),
      ),
      endPoint: Point2DPercentage(
        json['endPoint']['x'].toDouble(),
        json['endPoint']['y'].toDouble(),
      ),
      color: json.containsKey('color')
          ? Color(json['color'])
          : const Color.fromARGB(255, 43, 116, 179),
      thickness:
         json.containsKey('thickness') ? int.tryParse(json['thickness'].toString()) ?? 5 : 5,
      style: json.containsKey('style')
          ? BorderStyle.values[json['style']]
          : BorderStyle.solid,
    );
  }

  /// Handles the click event on the divider component.
  /// This method can be overridden to define specific behaviors when the divider
  /// is clicked (e.g., triggering a callback or navigating).
  @override
  void onClick() {
    // TODO: Implement onClick behavior, if needed.
  }
}
