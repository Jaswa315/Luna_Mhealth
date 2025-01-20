import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape.dart';

part 'slide.g.dart';

/// The slide represents the slide data in PowerPoint.
abstract class Slide implements Built<Slide, SlideBuilder> {
  int? get slideNumber;
  BuiltList<Shape>? get shapes;

  Slide._();

  factory Slide([updates(SlideBuilder b)]) = _$Slide;
}