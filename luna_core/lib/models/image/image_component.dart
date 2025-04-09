// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:luna_core/controllers/navigation_controller.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_core/utils/types.dart';
import 'package:luna_mobile/core/constants/constants.dart';

/// Represents an image component that can be rendered and clicked.
class ImageComponent extends Component {
  /// The path to the image file.
  String imagePath;

  /// Optional hyperlink associated with the component
  String? hyperlink;

  /// Constructs a new instance of [ImageComponent] with the given [imagePath], [x], [y], [width], and [height].
  ImageComponent({
    required this.imagePath,
    required double x,
    required double y,
    required double width,
    required double height,
    this.hyperlink,
  }) : super(
          name: 'ImageComponent',
          x: x,
          y: y,
          width: width,
          height: height,
        );

  @override
  Future<Widget> render(Size screenSize) async {
    String imageFileName = imagePath.split('/').last;

    /// Updated the render method to use the new getImageBytes signature
    return FutureBuilder<Uint8List?>(
      future: ModuleResourceFactory.getImageBytes(imageFileName),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data != null) {
          return GestureDetector(
            onTap: onClick,
            child: Image.memory(
              snapshot.data!,
              width: width * screenSize.width,
              height: height * screenSize.height,
            ),
          );
        }

        return Text(AppConstants.noImageErrorMessage);
      },
    );
  }

  /// Creates an [ImageComponent] from a JSON map.
  /// Updated the fromJson method to include moduleName
  static ImageComponent fromJson(Json json) {
    return ImageComponent(
      imagePath: json['image_path'],
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      hyperlink: json['hyperlink'],
    );
  }

  Json toJson() => {
        'type': 'image',
        'image_path': imagePath,
        'x': bounds.left,
        'y': bounds.top,
        'width': bounds.width,
        'height': bounds.height,
        'hyperlink': hyperlink,
      };

  void onClick() {
    // Process hyperlink
    if (hyperlink != null) {
      // Try to parse a single slide number
      int? slideNum = int.tryParse(hyperlink!);
      if (slideNum != null) {
        NavigationController().jumpToPage(slideNum);
      }
    }
  }
}
