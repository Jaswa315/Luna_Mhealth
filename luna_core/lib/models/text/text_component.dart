// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';

import '../../enums/component_type.dart';
import '../component.dart';

/// Represents a text component that can be used in the Luna mHealth Mobile app.
///
/// This class extends the [Component] class and provides additional functionality
/// specific to text components.
class TextComponent extends Component {
  /// The text to display in the text component.
  String text;

  /// The font size of the text.
  double fontSize;

  /// The font style of the text.
  FontStyle fontStyle;

  /// The color of the text.
  Color color;

  /// Constructs a new instance of [TextComponent] with the given parameters.
  TextComponent({
    required this.text,
    this.fontSize = 16.0,
    this.fontStyle = FontStyle.normal,
    this.color = Colors.black,
    required double x,
    required double y,
    required double width,
    required double height,
  }) : super(
          type: ComponentType.text,
          x: x,
          y: y,
          width: width,
          height: height,
          name: 'TextComponent',
        );

  @override
  Future<Widget> render() {
    return Future.value(
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontStyle: fontStyle,
          color: color,
        ),
      ),
    );
  }

  /// Converts a JSON object to a [TextComponent] instance.
  ///
  /// The [json] parameter is a JSON object that contains the data for the [TextComponent].
  /// Returns a new instance of [TextComponent] with the data from the JSON object.
  static TextComponent fromJson(Map<String, dynamic> json) {
    return TextComponent(
      text: json['text'],
      fontSize: json['text_properties']?['font_size']?.toDouble() ?? 16.0,
      x: json['position']['left'].toDouble(),
      y: json['position']['top'].toDouble(),
      width: json['position']['width'].toDouble(),
      height: json['position']['height'].toDouble(),
    );
  }

  /// Handles the click event for the text component.
  @override
  void onClick() {}
}
