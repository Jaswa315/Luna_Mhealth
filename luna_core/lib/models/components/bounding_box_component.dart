import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/units/bounding_box.dart';
import 'package:luna_core/utils/types.dart';

/// BBComponent represents a component with a bounding box, such as a text box or image.
/// It is used to define spatial layout for components that require specific positioning and sizing.
/// This class extends [Component].
class BoundingBoxComponent extends Component {
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
      'boundingBox': boundingBox.toJson(),
    };
  }

  /// Parses a bounding box from legacy JSON with x, y, width, and height fields.
  static BoundingBox parseBoundingBoxFromLegacyJson(Json json) {
    return BoundingBox.fromJson({
      'topLeftCorner': {
        'dx': (json['x'] as num).toDouble(),
        'dy': (json['y'] as num).toDouble(),
      },
      'width': json['width'],
      'height': json['height'],
    });
  }

  @override
  Future<Widget> render(Size screenSize) {
    // ToDo: implement render
    throw UnimplementedError();
  }
}
