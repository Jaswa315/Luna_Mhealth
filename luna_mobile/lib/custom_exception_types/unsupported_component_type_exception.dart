import 'package:luna_mobile/custom_exception_types/renderer_exception.dart';

class UnsupportedComponentTypeException extends RendererException {
  final String unsupportedComponentType;
  final List<String> supportedComponentTypes;

  UnsupportedComponentTypeException(
    this.unsupportedComponentType, 
    this.supportedComponentTypes,
    [String? customMessage]
  ) : super(
    customMessage ?? 'Component "$unsupportedComponentType" is not supported. '
        'Supported component types for rendering: ${supportedComponentTypes.join(", ")}'
  );
}