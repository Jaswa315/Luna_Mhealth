import 'package:luna_authoring_system/pptx_data_objects/relationship.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';

/// The slide represents the slide data in PowerPoint.
class Slide {
  late List<Shape>? shapes;

  late List<Relationship>? relationships;

  /// fileName of the slide
  /// Needed to form relationships
  late String fileName;

  Slide();
}
