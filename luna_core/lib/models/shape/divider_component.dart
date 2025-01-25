// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';
import 'package:luna_core/enums/component_type.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/utils/types.dart';

/// Represents a divider component that can be used in the Luna mHealth Mobile app.
/// This component provides a horizontal line to separate content sections visually,
/// with customizable properties like color, thickness, and style.
class DividerComponent extends Component {
  /// The color of the divider.
  /// Defaults to a custom ARGB color (43, 116, 179).
  Color color;

  /// The thickness of the divider line in logical pixels.
  /// Defaults to 5.0.
  double thickness;

  /// The style of the divider's border.
  /// Defaults to a solid line (`BorderStyle.solid`).
  BorderStyle style;

  /// Constructs a new instance of [DividerComponent].
  ///
  /// Parameters:
  /// - [color]: The color of the divider. Defaults to `Color.fromARGB(255, 43, 116, 179)`.
  /// - [thickness]: The thickness of the divider in logical pixels. Defaults to 5.0.
  /// - [style]: The border style of the divider. Defaults to `BorderStyle.solid`.
  /// - [x]: The x-coordinate position of the divider's top-left corner.
  /// - [y]: The y-coordinate position of the divider's top-left corner.
  /// - [width]: The width of the divider.
  /// - [height]: The height of the divider.
  DividerComponent({
    this.color = const Color.fromARGB(255, 43, 116, 179),
    this.thickness = 5.0,
    this.style = BorderStyle.solid,
    required double x,
    required double y,
    required double width,
    required double height,
  }) : super(
          type: ComponentType.divider,
          x: x,
          y: y,
          width: width,
          height: height,
          name: 'DividerComponent',
        );

  /// Renders the divider as a [Widget].
  ///
  /// Parameters:
  /// - [screenSize]: The size of the screen, used to calculate dimensions if needed.
  ///
  /// Returns:
  /// A [Future] that resolves to a [Widget] rendering the divider with the specified
  /// properties (color, thickness, and style).
  @override
  Future<Widget> render(Size screenSize) {
    return Future.value(
      Container(
        width: bounds.width,
        height: bounds.height,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: color,
              width: thickness,
              style: style,
            ),
          ),
        ),
      ),
    );
  }

  /// Converts the current [DividerComponent] instance to a JSON object.
  ///
  /// Returns:
  /// A [Json] object containing all the properties of the divider, including:
  /// - `type`: The component type (e.g., 'divider').
  /// - `x`, `y`, `width`, `height`: The positional and dimensional attributes.
  /// - `color`: The color of the divider as an integer value.
  /// - `thickness`: The thickness of the divider.
  /// - `style`: The style of the divider's border as an index.
  @override
  Json toJson() {
    return {
      'type': type.name,
      'x': bounds.left,
      'y': bounds.top,
      'width': bounds.width,
      'height': bounds.height,
      'color': color.value, // Color represented as an integer
      'thickness': thickness,
      'style': style.index, // BorderStyle represented by its index
    };
  }

  /// Creates a new [DividerComponent] instance from a JSON object.
  ///
  /// Parameters:
  /// - [json]: A [Json] object containing the data to initialize the divider.
  ///
  /// Returns:
  /// A [DividerComponent] instance with properties derived from the JSON object.
  ///
  /// Throws:
  /// An [Exception] if the JSON is missing required fields like `x`, `y`, `width`, or `height`.
  static DividerComponent fromJson(Json json) {
    return DividerComponent(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      color: json.containsKey('color')
          ? Color(json['color']) // Extract color if present
          : const Color.fromARGB(255, 43, 116, 179), // Default color
      thickness: json.containsKey('thickness')
          ? json['thickness'].toDouble() // Extract thickness if present
          : 5.0, // Default thickness
      style: json.containsKey('style')
          ? BorderStyle.values[json['style']] // Extract style if present
          : BorderStyle.solid, // Default style
    );
  }

  /// Handles the click event on the divider component.
  ///
  /// This method can be overridden to define specific behaviors when the divider
  /// is clicked (e.g., triggering a callback or navigating).
  @override
  void onClick() {
    // TODO: Implement onClick behavior, if needed.
  }
}
