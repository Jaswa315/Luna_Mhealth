import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/components/image_component.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/models/components/text_component.dart';
import 'package:luna_core/utils/types.dart';

/// A utility class responsible for serializing and deserializing [Component] objects.
///
/// This class provides static methods to convert component instances to and from JSON format.
/// It supports extensibility through a registry that maps component types to their corresponding
/// deserialization functions.
class ComponentSerializer {
  /// A registry that maps a string identifier to a deserialization function.
  ///
  /// This allows the serializer to determine the appropriate [Component] subclass to instantiate
  /// based on the 'componentType' field in the JSON object.
  static final Map<String, Component Function(Json)> _registry = {
    'line': (json) => LineComponent.fromJson(json),
    'text': (json) => TextComponent.fromJson(json),
    'image': (json) => ImageComponent.fromJson(json),
  };

  /// A reverse mapping that links a [Component] subclass to its string type identifier.
  ///
  /// Used during serialization to embed the type information so that the correct deserialization
  /// logic can be applied later.
  static final Map<Type, String> _typeMapping = {
    LineComponent: 'line',
    TextComponent: 'text',
    ImageComponent: 'image',
  };

  /// Deserializes a JSON object into a [Component] instance.
  ///
  /// This method uses the 'componentType' field to determine which subclass of [Component]
  /// to instantiate. Throws an [Exception] if the component type is not registered.
  static Component fromJson(Json json) {
    final type = json['componentType'];
    final builder = _registry[type];
    if (builder == null) {
      throw Exception('Unsupported component type: $type');
    }

    return builder(json);
  }

  /// Serializes a [Component] instance into a JSON object.
  ///
  /// This method adds a 'componentType' field to the serialized output to indicate
  /// the type of the component, which is required for proper deserialization.
  /// Throws an [Exception] if the component type is not recognized.
  static Json serializeComponent(Component component) {
    final type = _typeMapping[component.runtimeType];
    if (type == null) {
      throw Exception('Unknown component type: ${component.runtimeType}');
    }

    final json = component.toJson();

    return {
      'componentType': type,
      ...json,
    };
  }
}
