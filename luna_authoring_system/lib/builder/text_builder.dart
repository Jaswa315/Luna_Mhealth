import 'dart:ui';
import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbox_shape.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:luna_core/units/bounding_box.dart';

/// TextBuilder is a builder class for constructing a [TextComponent].
/// It extracts necessary properties from a [TextboxShape] and
/// maps PowerPoint text properties to Luna's text component structure.
class TextBuilder implements IBuilder<TextComponent> {
  late List<TextPart> _textChildren;
  late BoundingBox _boundingBox;
  
  TextBuilder();

  /// Sets the text children for the TextComponent.
  TextBuilder setTextChildren(TextboxShape shape) {
    _textChildren = [];
    for (var paragraph in shape.textbody.paragraphs) {
      for (var run in paragraph.runs) {
        _textChildren.add(TextPart(
          text: run.text,
          fontSize: run.fontSize.value / 100.0,
          fontWeight: run.bold ? FontWeight.bold : FontWeight.normal,
          fontStyle: run.italics ? FontStyle.italic : FontStyle.normal,
          fontUnderline: run.underlineType == SimpleTypeTextUnderlineType.none
              ? TextDecoration.none
              : TextDecoration.underline,
        ));
      }
    }
    return this;
  }

  /// Sets the bounding box for the TextComponent.
  TextBuilder setBoundingBox(TextboxShape shape) {
    _boundingBox = BoundingBox(
      topLeftCorner: Offset(double.parse(shape.transform.offset.x.toString()),
        (double.parse(shape.transform.offset.y.toString()))),
      width: shape.transform.size.x,
      height: shape.transform.size.y,
    );
    return this;
  }

  /// The [build] method finalizes the object and returns a `TextComponent`.
  @override
  TextComponent build() {
    return TextComponent(
      textChildren: _textChildren,
      boundingBox: _boundingBox,
    );
  }
}