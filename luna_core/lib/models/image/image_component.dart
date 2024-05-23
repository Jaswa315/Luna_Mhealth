// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:luna_core/enums/component_type.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';

/// Represents an image component that can be rendered and clicked.
class ImageComponent extends Component {
  /// The path to the image file.
  String imagePath;

  /// The name of the module.
  String moduleName;

  /// Constructs a new instance of [ImageComponent] with the given [imagePath], [x], [y], [width], and [height].
  ImageComponent({
    required this.imagePath,
    required this.moduleName,
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
  Future<Widget> render() async {
    String imageFileName = imagePath.split('/').last;

    /// Updated the render method to use the new getImageBytes signature
    return FutureBuilder<Uint8List?>(
      future: ModuleResourceFactory.getImageBytes(
          moduleName, imageFileName), //added module name
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(snapshot.data!);
        }
        return Text(AppConstants.noImageErrorMessage);
      },
    );
  }

  /// Creates an [ImageComponent] from a JSON map.
  /// Updated the fromJson method to include moduleName
  static ImageComponent fromJson(Map<String, dynamic> json) {
    return ImageComponent(
      imagePath: json['image_path'],
      moduleName: json['module_name'], //added module name
      x: json['position']['left'].toDouble(),
      y: json['position']['top'].toDouble(),
      width: json['position']['width'].toDouble(),
      height: json['position']['height'].toDouble(),
    );
  }

  @override
  void onClick() {}
}
