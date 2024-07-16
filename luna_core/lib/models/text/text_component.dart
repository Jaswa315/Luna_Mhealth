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
  List<TextPart> textChildren = [];

  /// Constructs a new instance of [TextComponent] with the given parameters.
  TextComponent({
    //required this.text,
    // this.fontSize = 16.0,
    // this.fontStyle = FontStyle.normal,
    // this.color = Colors.black,
    required List<TextPart> textChildren,
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
    List<TextSpan> textSpans = [];
    for (TextPart textPart in textChildren) {
      textSpans.add(textPart.getTextSpan());
    }

    return Future.value(
      RichText(
          text: TextSpan(
        children: textSpans,
      )),
    );
  }

  /// Converts a JSON object to a [TextComponent] instance.
  ///
  /// The [json] parameter is a JSON object that contains the data for the [TextComponent].
  /// Returns a new instance of [TextComponent] with the data from the JSON object.
  static TextComponent fromJson(Map<String, dynamic> json) {
    List<TextPart> children = (json['textParts'] as List)
        .map((textPartJson) => TextPart.fromJson(textPartJson))
        .toList();

    return TextComponent(
      textChildren: children,
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

class TextPart {
  String text;
  double fontSize;
  FontStyle fontStyle;
  Color color;

  TextPart(
      {required this.text,
      this.fontSize = 16.0,
      this.fontStyle = FontStyle.normal,
      this.color = Colors.black});

  TextSpan getTextSpan() {
    return TextSpan(
        text: text,
        style: TextStyle(
            color: this.color,
            fontStyle: this.fontStyle,
            fontSize: this.fontSize));
  }

  static TextPart fromJson(Map<String, dynamic> json) {
    return TextPart(
        text: json['text'],
        fontSize: json['font_size'] ?? 16.0,
        fontStyle: json['font_style'] ?? FontStyle.normal,
        color: json['font_color'] ?? Colors.black);
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'fontSize': fontSize,
        'fontStyle': fontStyle,
        'color': color
      };
}
