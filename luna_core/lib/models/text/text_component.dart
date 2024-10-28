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
import 'package:luna_core/utils/types.dart';

/// Represents a text component that can be used in the Luna mHealth Mobile app.
///
/// This class extends the [Component] class and provides additional functionality
/// specific to text components.
class TextComponent extends Component {
  /// The text to display in the text component.
  final List<TextPart> textChildren;

  /// Constructs a new instance of [TextComponent] with the given parameters.
  TextComponent({
    //required this.text,
    // this.fontSize = 16.0,
    // this.fontStyle = FontStyle.normal,
    // this.color = Colors.black,
    /// children of component
    required this.textChildren,
    /// x position of component
    required double x,
    /// y position of component
    required double y,
    /// width of component
    required double width,
    /// height of component
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
  Future<Widget> render(Size screenSize) {
    List<TextSpan> textSpans = [];
    for (TextPart textPart in textChildren) {
      textSpans.add(textPart.getTextSpan());
    }

    return Future.value(
      Container(
          width: width * screenSize.width,
          height: height * screenSize.height,
          padding: EdgeInsets.all(16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: textSpans,
            ),
          )),
    );
  }

  /// Converts a JSON object to a [TextComponent] instance.
  ///
  /// The [json] parameter is a JSON object that contains the data for the [TextComponent].
  /// Returns a new instance of [TextComponent] with the data from the JSON object.
  static TextComponent fromJson(Json json) {
    List<TextPart> children = (json['textParts'] as List)
        .map((textPartJson) => TextPart.fromJson(textPartJson))
        .toList();

    return TextComponent(
      textChildren: children,
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
    );
  }

  Json toJson() => {
        'type': ComponentType.text.name,
        'textParts': textChildren.map((textPart) => textPart.toJson()).toList(),
        'x': x,
        'y': y,
        'width': width,
        'height': height
      };

  /// Handles the click event for the text component.
  @override
  void onClick() {}
}

/// String of text with given font 
class TextPart {
  /// string value of text
  String text;
  /// font size of text
  double fontSize;
  /// font style of text
  FontStyle fontStyle;
  /// font weight of text
  FontWeight fontWeight;
  /// underline decoration of text
  TextDecoration fontUnderline;
  /// optional id of text
  int? textID;
  /// optional color of text
  Color? color;

  /// construct a new instance of [TextPart] with the given parameters
  TextPart(
      {required this.text,
      this.fontSize = 16.0,
      this.fontStyle = FontStyle.normal,
      this.fontWeight = FontWeight.normal,
      this.fontUnderline = TextDecoration.none,
      this.textID,
      this.color});

  /// return the span of this [TextPart]
  TextSpan getTextSpan() {
    return TextSpan(
        text: text,
        style: TextStyle(
            color: color,
            fontStyle: fontStyle,
            fontSize: fontSize,
            fontWeight: fontWeight,
            decoration: fontUnderline));
  }

  /// construct new instance of [TextPart] from json
  static TextPart fromJson(Json json) {
    return TextPart(
        text: json['text'],
        textID: json['textID'],
        fontSize: json['fontSize'] ?? 16.0,
        // ToDo: No hardcoding font properties!
        fontStyle:
            json['fontStyle'] == 'italic' ? FontStyle.italic : FontStyle.normal,
        color: json['color'] != null ? Color(json['color']) : Colors.black,
        fontWeight:
            json['fontWeight'] == 'bold' ? FontWeight.bold : FontWeight.normal,
        fontUnderline: json['fontUnderline'] == 'underline'
            ? TextDecoration.underline
            : TextDecoration.none);
  }

  /// construct new json instance from [TextPart]
  Json toJson() => {
        'text': text,
        'textID': textID,
        'fontSize': fontSize,
        'fontStyle': fontStyle.name == FontStyle.italic ? 'italic' : '',
        'color': color?.value,
        'fontWeight': fontWeight == FontWeight.bold ? 'bold' : '',
        'fontUnderline':
            fontUnderline == TextDecoration.underline ? 'underline' : ''
      };
}
