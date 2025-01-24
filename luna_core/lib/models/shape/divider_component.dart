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
class DividerComponent extends Component {
  /// The color of the divider.
  Color color;

  /// The thickness of the divider.
  double thickness;

  /// The style of the divider.
  BorderStyle style;

  /// A mapping of integer values to BorderStyle values.
  /// This mapping is used to convert integer values from the JSON object to BorderStyle values.
  static final Map<int, BorderStyle> styleMapping = {
    1: BorderStyle.solid, // Solid line
    2: BorderStyle.none, // No line (use none for now as dotted is unsupported)
    3: BorderStyle.none, // Dashed line (Flutter doesn't support directly)
  };

  /// Constructs a new instance of [DividerComponent] with the given parameters.
  DividerComponent({
    required this.color,
    required this.thickness,
    required this.style,
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

  @override
  Json toJson() {
    return {
      'type': type.name,
      'x': bounds.left,
      'y': bounds.top,
      'width': bounds.width,
      'height': bounds.height,
      'color': color.value,
      'thickness': thickness,

      /// Convert BorderStyle to integer
      'style': styleMapping.entries
          .firstWhere(
            (entry) => entry.value == style,
            orElse: () => MapEntry(1, BorderStyle.solid),
          )
          .key, // Default to solid
    };
  }

  /// Converts a JSON object to a [DividerComponent] instance.
  /// The [json] parameter is a JSON object that contains the data for the [DividerComponent].
  /// Returns a new instance of [DividerComponent] with the data from the JSON object.
  /// Throws an [Exception] if the JSON object is missing required fields.

  static DividerComponent fromJson(Json json) {
    return DividerComponent(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      color: Color(json['color']),
      thickness: json['thickness'].toDouble(),
      style: styleMapping[json['style']] ?? BorderStyle.solid,
    );
  }

  @override
  void onClick() {
    // TODO: implement onClick
  }
}
