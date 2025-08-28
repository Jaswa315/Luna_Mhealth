import 'package:flutter/material.dart';
import 'package:luna_core/models/components/bounding_box_component.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:luna_core/units/bounding_box.dart';
import 'package:luna_core/utils/types.dart';
import 'package:luna_mobile/renderers/text_component_renderer.dart';

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