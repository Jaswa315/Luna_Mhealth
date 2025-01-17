import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'shape_type.g.dart';

/// The shape type class defines acceptable shape types
/// from the pptx file.
class ShapeType extends EnumClass {
  static const ShapeType picture = _$picture;
  static const ShapeType connection = _$connection;
  static const ShapeType textbox = _$textbox;

  const ShapeType._(String name) : super(name);

  static BuiltSet<ShapeType> get values => _$values;
  static ShapeType valueOf(String name) => _$valueOf(name);
}