import 'package:flutter/material.dart';
import 'package:luna_core/models/bounding_box.dart';
import 'package:luna_core/models/components/bounding_box_component.dart';
import 'package:luna_core/utils/types.dart';

/// Represents a text component that can be used in the Luna mHealth Mobile app.
///
/// This class extends the [BoundingBoxComponent] class and provides additional functionality
/// specific to text components.
class TextComponent extends BoundingBoxComponent {
  /// The text to display in the text component.
  final List<TextPart> textChildren;

  /// Constructs a new instance of [TextComponent] with the given parameters.
  TextComponent({
    required this.textChildren,
    required BoundingBox boundingBox,
  }) : super(
          boundingBox: boundingBox,
        );

  /// Converts a JSON object to a [TextComponent] instance.
  ///
  /// The [json] parameter is a JSON object that contains the data for the [TextComponent].
  /// Returns a new instance of [TextComponent] with the data from the JSON object.
  static TextComponent fromJson(Json json) {
    List<TextPart> children = (json['textParts'] as List)
        .map((textPartJson) => TextPart.fromJson(textPartJson))
        .toList();

    final boundingBox =
        BoundingBoxComponent.parseBoundingBoxFromLegacyJson(json);

    return TextComponent(
      textChildren: children,
      boundingBox: boundingBox,
    );
  }

  @override
  Json toJson() => {
        'type': 'text',
        'textParts': textChildren.map((textPart) => textPart.toJson()).toList(),
        'boundingBox': boundingBox.toJson(),
      };
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
  TextPart({
    required this.text,
    this.fontSize = 16.0,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.fontUnderline = TextDecoration.none,
    this.textID,
    this.color,
  });

  /// return the span of this [TextPart]
  TextSpan getTextSpan() {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontStyle: fontStyle,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: fontUnderline,
      ),
    );
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
          : TextDecoration.none,
    );
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
            fontUnderline == TextDecoration.underline ? 'underline' : '',
      };
}
