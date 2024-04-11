// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Represents a text component that can be rendered and clicked.
/// Extends the [Component] class and implements the [Clickable] interface.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../../enums/component_type.dart';
import '../component.dart';
import '../interfaces/clickable.dart';

class TextComponent extends Component {
  String text;
  double fontSize;
  FontStyle fontStyle;
  Color color;

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
  Widget render() {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontStyle: fontStyle, color: color),
    );
  }

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
  void onClick() {
    print('Text Component Clicked: $text');
  }
}
