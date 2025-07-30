import 'package:luna_authoring_system/custom_exception_types/slide_layout_exception.dart';

class ParentShapeMapNotFoundException extends SlideLayoutException {
  final int parentIndex;
  final String shapeType;
  
  ParentShapeMapNotFoundException(this.parentIndex, this.shapeType)
      : super('Parent shape map not found for parent index $parentIndex and type $shapeType');
  
  @override
  String toString() => 'ParentShapeNotFoundException: $message';
}