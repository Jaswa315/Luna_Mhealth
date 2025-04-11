import 'package:luna_core/models/bounding_box.dart';
import 'package:luna_core/models/components/bounding_box_component.dart';
import 'package:luna_core/utils/types.dart';

/// Represents an image component that can be rendered and clicked.
class ImageComponent extends BoundingBoxComponent {
  /// The path to the image file.
  String imagePath;

  /// Optional hyperlink associated with the component
  String? hyperlink;

  /// Constructs a new instance of [ImageComponent] with the given [imagePath] and [boundingBox].
  ImageComponent({
    required this.imagePath,
    required BoundingBox boundingBox,
    this.hyperlink,
  }) : super(
          boundingBox: boundingBox,
        );

  /// Creates an [ImageComponent] from a JSON map.
  /// Updated the fromJson method to include moduleName
  static ImageComponent fromJson(Json json) {
    final boundingBox = BoundingBox.fromJson({
      'topLeftCorner': {
        'dx': (json['x'] as num).toDouble(),
        'dy': (json['y'] as num).toDouble(),
      },
      'width': json['width'],
      'height': json['height'],
    });

    return ImageComponent(
      imagePath: json['image_path'],
      boundingBox: boundingBox,
      hyperlink: json['hyperlink'],
    );
  }

  @override
  Json toJson() => {
        'type': 'image',
        'image_path': imagePath,
        'boundingBox': boundingBox.toJson(),
        'hyperlink': hyperlink,
      };
}
