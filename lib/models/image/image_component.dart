// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/component_type.dart';
import '../../providers/click_state_provider.dart';
import '../component.dart';

class ImageComponent extends Component {
  /// The path of the image.
  String imagePath;
  Color _borderColor = Colors.transparent; // Internal state for border color

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
  }) : super(type: type, x: x, y: y, width: width, height: height, name: '');

  /// Renders the image component.
  /// Returns an [Image.asset] widget with the specified image path, width, and height.
  @override
  Widget render() {
    return Consumer<ClickStateProvider>(
      builder: (context, clickStateProvider, child) {
        return GestureDetector(
          onTap: () {
            //print("ImageComponent clicked! Current isBold: $_borderColor");
            _borderColor = _updateBorderColor(); // Update internal state
            clickStateProvider.clickState
                .changeBorderColor(); // Notify Provider change
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: _borderColor, width: 5.0), // Use internal state
            ),
            child: Image.asset(
              imagePath,
              //width: width,
              //height: height,
            ),
          ),
        );
      },
    );
  }

  @override
  void onClick() {
    print('Image clicked: $imagePath');
  }

  // Helper function to cycle border colors
  Color _updateBorderColor() {
    if (_borderColor == Colors.transparent) {
      return Colors.blue;
    } else if (_borderColor == Colors.blue) {
      return Colors.red;
    } else {
      return Colors.transparent;
    }
  }
}
