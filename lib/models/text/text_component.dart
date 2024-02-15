/// Represents a text component that can be rendered and clicked.
/// Extends the [Component] class and implements the [Clickable] interface.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../../enums/component_type.dart';
import '../component.dart';
import '../interfaces/clickable.dart';

class TextComponent extends Component implements Clickable {
  String text;
  double fontSize;
  FontStyle fontStyle;
  Color color;
  TextAlign alignment;

  /// Constructs a [TextComponent] with the given parameters.
  ///
  /// The [text] parameter is required and represents the text to be displayed.
  /// The [type] parameter represents the type of the component.
  /// The [fontSize] parameter represents the font size of the text.
  /// The [fontStyle] parameter represents the font style of the text.
  /// The [color] parameter represents the color of the text.
  /// The [alignment] parameter represents the alignment of the text.
  /// The [x], [y], [width], and [height] parameters represent the position and size of the component.
  TextComponent({
    required this.text,
    required ComponentType type,
    this.fontSize = 16.0,
    this.fontStyle = FontStyle.normal,
    this.color = Colors.black,
    this.alignment = TextAlign.start,
    double x = 0.0,
    double y = 0.0,
    double width = 0.0,
    double height = 0.0,
  }) : super(type: type, x: x, y: y, width: width, height: height);

  @override
  void load() {
    // Implementation for load method
  }

  /// Renders the text component.
  /// Returns a [Container] widget containing the text.
  @override
  Widget render() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontStyle: fontStyle,
          color: color,
        ),
        textAlign: alignment,
      ),
    );
  }

  /// Handles the click event for the text component.
  @override
  void onClick() {
    print('Text Component Clicked!');
  }
}
