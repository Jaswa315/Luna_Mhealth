import 'package:luna_authoring_system/custom_exception_types/slide_layout_exception.dart';

class PlaceholderShapeNotFoundException extends SlideLayoutException {
  final int placeholderIndex;
  
  PlaceholderShapeNotFoundException(this.placeholderIndex)
      : super('Placeholder shape with index $placeholderIndex not found in parent slide layout');
  
  @override
  String toString() => 'PlaceholderShapeNotFoundException: $message';
}