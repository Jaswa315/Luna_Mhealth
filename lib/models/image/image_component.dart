/// Represents an image component that can be rendered in a Flutter application.
///
/// The [ImageComponent] class extends the [Component] class and provides functionality
/// for rendering an image using the [Image.asset] widget. It takes in the path of the image
/// and other optional parameters such as position, width, and height.
///
/// Example usage:
///
/// ```dart
/// ImageComponent image = ImageComponent(
///   imagePath: 'assets/images/my_image.png',
///   type: ComponentType.image,
///   x: 100.0,
///   y: 100.0,
///   width: 200.0,
///   height: 200.0,
/// );
/// ```
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../../enums/component_type.dart';
import '../component.dart';

class ImageComponent extends Component {
  /// The path of the image.
  String imagePath;

  /// Creates a new instance of [ImageComponent].
  ///
  /// The [imagePath] parameter is required and specifies the path of the image.
  /// The [type] parameter is required and specifies the type of the component.
  /// The [x], [y], [width], and [height] parameters are optional and specify the position
  /// and dimensions of the component.
  ImageComponent({
    required this.imagePath,
    required ComponentType type,
    double x = 0.0,
    double y = 0.0,
    double width = 0.0,
    double height = 0.0,
  }) : super(type: type, x: x, y: y, width: width, height: height);

  /// Renders the image component.
  /// Returns an [Image.asset] widget with the specified image path, width, and height.
  @override
  Widget render() {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
    );
  }

  @override
  void load() {
    // TODO: implement loading logic
  }
}
