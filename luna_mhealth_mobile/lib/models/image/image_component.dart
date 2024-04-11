// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';

import 'package:flutter/material.dart';

import '../../enums/component_type.dart';
import '../component.dart';

/// Represents an image component that can be rendered and clicked.
class ImageComponent extends Component {
  /// The path to the image file.
  String imagePath;

  /// The path to the directory containing the image file.
  final String? directoryPath;

  /// Constructs a new instance of [ImageComponent] with the given [imagePath], [x], [y], [width], and [height].
  ImageComponent({
    required this.imagePath,
    this.directoryPath,
    required double x,
    required double y,
    required double width,
    required double height,
  }) : super(
            type: ComponentType.image,
            x: x,
            y: y,
            width: width,
            height: height,
            name: 'ImageComponent');

  @override
  Widget render() {
    //print('ImageComponent.render: $imagePath');

    String fullPath =
        directoryPath != null ? '$directoryPath/$imagePath' : imagePath;
    //print('ImageComponent.render: Full Path => $fullPath');
    return Image(
      image: FileImage(File(fullPath)),
      fit: BoxFit.cover,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Icon(Icons.error); // Placeholder widget in case of an error
      },
    );
  }

  /// Creates an [ImageComponent] from a JSON map.
  static ImageComponent fromJson(Map<String, dynamic> json,
      [String? directoryPath]) {
    return ImageComponent(
      imagePath: json['image_path'],
      directoryPath: directoryPath,
      x: json['position']['left'].toDouble(),
      y: json['position']['top'].toDouble(),
      width: json['position']['width'].toDouble(),
      height: json['position']['height'].toDouble(),
    );
  }

  @override
  void onClick() {
    print('Image Component Clicked: $imagePath');
  }
}
