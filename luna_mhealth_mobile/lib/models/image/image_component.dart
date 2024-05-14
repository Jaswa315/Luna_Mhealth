// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';
import 'package:luna_mhealth_mobile/core/services/module_handler_service.dart';

import '../../enums/component_type.dart';
import '../component.dart';

/// Represents an image component that can be rendered and clicked.
class ImageComponent extends Component {
  /// The path to the image file.
  String imagePath;

  /// Constructs a new instance of [ImageComponent] with the given [imagePath], [x], [y], [width], and [height].
  ImageComponent({
    required this.imagePath,
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

    return FutureBuilder<Uint8List?>(
      future: ModuleHandler.getImageBytes(imageFileName),
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
  static ImageComponent fromJson(Map<String, dynamic> json) {
    return ImageComponent(
      imagePath: json['image_path'],
      x: json['position']['left'].toDouble(),
      y: json['position']['top'].toDouble(),
      width: json['position']['width'].toDouble(),
      height: json['position']['height'].toDouble(),
    );
  }

  @override
  void onClick() {}
}
