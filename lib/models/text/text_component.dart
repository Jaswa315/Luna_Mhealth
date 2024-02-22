// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Represents a text component that can be rendered and clicked.
/// Extends the [Component] class and implements the [Clickable] interface.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/component_type.dart';
import '../../providers/click_state_provider.dart';
import '../component.dart';
import '../interfaces/clickable.dart';

class TextComponent extends Component {
  String text;
  double fontSize;
  FontStyle fontStyle;
  Color color;
  TextAlign alignment;
  bool _isBold = false; // Internal state for font weight

  /// Constructs a [TextComponent] with the given parameters.
  ///
  /// The [text] parameter is required and represents the text to be displayed.
  /// The [type] parameter represents the type of the component.
  /// The [fontSize] parameter represents the font size of the text.
  /// The [fontStyle] parameter represents the font style of the text.
  /// The [color] parameter represents the color of the text.
  /// The [alignment] parameter represents the alignment of the text.
  /// The [x], [y], [width], and [height] parameters represent the position and size of the component.
  TextComponent({
    required this.text,
    required ComponentType type,
    this.fontSize = 16.0,
    this.fontStyle = FontStyle.normal,
    this.color = Colors.black,
    this.alignment = TextAlign.start,
    double x = 0.0,
    double y = 0.0,
    double width = 0.0,
    double height = 0.0,
  }) : super(type: type, x: x, y: y, width: width, height: height);

  /// Renders the text component.
  /// Returns a [Container] widget containing the text.
  // @override
  // Widget render() {
  //   return Consumer<ClickStateProvider>(
  //     builder: (context, clickStateProvider, child) {
  //       return GestureDetector(
  //         onTap: () {
  //           print("TextComponent clicked! Current isBold: $_isBold");
  //           _isBold = !_isBold; // Update internal state
  //           clickStateProvider.clickState
  //               .toggleBold(); // Notify Provider change
  //         },
  //         child: Container(
  //           padding: EdgeInsets.all(10.0),
  //           child: Text(
  //             text,
  //             style: TextStyle(
  //               fontSize: fontSize,
  //               fontStyle: fontStyle,
  //               color: color,
  //               fontWeight: clickStateProvider.clickState.isBold
  //                   ? FontWeight.bold
  //                   : FontWeight.normal,
  //             ),
  //             textAlign: alignment,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget render() {
    return Consumer<ClickStateProvider>(
      builder: (context, clickStateProvider, child) {
        return GestureDetector(
          onTap: () {
            clickStateProvider.clickState.changeText(); // Change the text
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              clickStateProvider.clickState.text, // Use the text from the state
              style: TextStyle(
                  fontSize: fontSize, fontStyle: fontStyle, color: color),
              textAlign: alignment,
            ),
          ),
        );
      },
    );
  }

  /// Handles the click event for the text component.
  @override
  void onClick() {
    print('Text Component Clicked: $text');
  }
}
