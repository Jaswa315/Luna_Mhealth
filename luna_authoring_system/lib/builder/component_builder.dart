import 'package:flutter/cupertino.dart';
import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/builder/line_builder.dart';
import 'package:luna_authoring_system/builder/text_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbox_shape.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';

/// ComponentBuilder is responsible for constructing a [Component] object.
///
/// It takes in a shape extracted from a PowerPoint file and determines
/// the appropriate component type to build. Currently, it supports [LineComponent]
/// if the shape is a [ConnectionShape].
///
/// If an unsupported shape type is encountered, an [ArgumentError] is thrown.
class ComponentBuilder implements IBuilder<Component> {
  final Shape _shape;

  ComponentBuilder(this._shape);

  @override
  Component build() {
    if (_shape is ConnectionShape) {
      return _buildLineComponent(_shape);
    } else if (_shape is TextboxShape) {
      return _buildTextComponent(_shape);
    }

    throw ArgumentError("Unsupported shape type: ${_shape.runtimeType}");
  }

  LineComponent _buildLineComponent(ConnectionShape shape) {
    return LineBuilder()
        .setStartAndEndPoints(shape)
        .setThickness(shape)
        .setColor(shape)
        .setStyle(shape)
        .build();
  }

  TextComponent _buildTextComponent(TextboxShape shape) {
    return TextBuilder()
        .setTextChildren(shape)
        .setBoundingBox(shape)
        .build();
  }
}
