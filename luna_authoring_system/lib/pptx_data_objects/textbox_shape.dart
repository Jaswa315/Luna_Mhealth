import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbody.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';

/// The TextboxShape class represents the textbox shape element (p:sp) in the PowerPoint.
/// textbody is text contained within the corresponding textbox shape.
class TextboxShape implements Shape {
  @override
  Transform transform;

  Textbody textbody;

  TextboxShape({
    required this.transform,
    required this.textbody,
  });
  
  @override
  ShapeType get type => ShapeType.textbox;
}