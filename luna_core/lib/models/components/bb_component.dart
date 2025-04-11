import 'package:luna_core/models/bounding_box.dart';

/*  BBComponent represents a component with a bounding box, such as a text box or image.
    It is used to define spatial layout for components that require specific positioning and sizing. */
class BBComponent {
  /// The bounding box specifying the start position, width, and height of the component.
  final BoundingBox boundingBox;

  /// Creates a BBComponent with a required bounding box.
  BBComponent({required this.boundingBox});

  /// Factory method to create a BBComponent instance from a JSON map.
  factory BBComponent.fromJson(Map<String, dynamic> json) {
    return BBComponent(
      boundingBox: BoundingBox.fromJson(json['boundingBox']),
    );
  }

  /// Converts the BBComponent instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': 'bbComponent',
      'boundingBox': boundingBox.toJson(),
    };
  }
}
