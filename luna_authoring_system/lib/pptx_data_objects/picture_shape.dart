import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/source_rectangle.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';

/// This class represents the picture element (p:pic) in the PowerPoint.
/// url is the path to the image file.
class PictureShape implements Shape {
  @override
  Transform transform;
  String url;
  SourceRectangle sourceRectangle;

  PictureShape({
    required this.transform,
    required this.url,
    required this.sourceRectangle,
  });

  @override
  ShapeType get type => ShapeType.picture;
}
