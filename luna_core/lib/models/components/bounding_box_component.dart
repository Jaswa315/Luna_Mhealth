import 'package:luna_core/models/bounding_box.dart';
import 'package:luna_core/utils/types.dart';

///BBComponent represents a component with a bounding box, such as a text box or image.
///It is used to define spatial layout for components that require specific positioning and sizing. */
class BoundingBoxComponent {
  /// The bounding box specifying the start position, width, and height of the component.
  final BoundingBox boundingBox;

  /// Creates a BBComponent with a required bounding box.
  BoundingBoxComponent({required this.boundingBox});

  /// Factory method to create a BBComponent instance from a JSON map.
  factory BoundingBoxComponent.fromJson(Map<String, dynamic> json) {
    return BoundingBoxComponent(
      boundingBox: BoundingBox.fromJson(json['boundingBox']),
    );
  }

  /// Converts the BBComponent instance to a JSON map.
  Json toJson() {
    return {
      'type': 'boundingBoxComponent',
      'boundingBox': boundingBox.toJson(),
    };
  }
}
