// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_mobile/renderers/text_part_painter.dart';
import 'base_component_renderer.dart';

/// A class that extends the [BaseComponentRenderer] class to render text components.
/// This class renders a text component on the screen based on 
/// the properties defined in the [TextComponent] class.
class TextComponentRenderer extends BaseComponentRenderer<TextComponent> {
  /// Renders the given [TextComponent] as a widget.
  /// [component] is expected to be of type `TextComponent`
  /// [screenSize] provides the dimensions of the screen or parent container
  /// within which the component will be rendered.
  @override
  Widget renderComponent(dynamic component, Size screenSize) {
    if (component is TextComponent) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final topLeft = Offset(
            component.boundingBox.topLeftCorner.dx * constraints.maxWidth,
            component.boundingBox.topLeftCorner.dy * constraints.maxHeight,
          );

          final width = (component.boundingBox.width as Percent).value * constraints.maxWidth;
          final height = (component.boundingBox.height as Percent).value * constraints.maxHeight;

          return CustomPaint(
            painter: TextPartPainter(
              topLeft: topLeft,
              width: width,
              height: height,
              textParts: component.textChildren,
            ),
            size: Size(constraints.maxWidth, constraints.maxHeight),
          );
        },
      );
    } else {
      throw ArgumentError(
        'Invalid component type for TextComponentRenderer',
      );
    }
  }
}
