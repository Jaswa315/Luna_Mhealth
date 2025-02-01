// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'package:luna_core/renderers/line_painter.dart';
import 'base_component_renderer.dart';

/// A renderer class for the `DividerComponent`.
/// This class is responsible for rendering a divider component on the screen
/// based on the specified properties such as position, size, thickness, and color.
/// It uses the `LinePainter` to draw the divider on a canvas.
class DividerComponentRenderer extends BaseComponentRenderer<DividerComponent> {
  /// Renders the given `DividerComponent` as a widget.
  ///[component] is expected to be of type `DividerComponent`
  /// [screenSize] provides the dimensions of the screen or parent container
  /// within which the component will be rendered.
  /// Throws an [ArgumentError] if the component is not of type `DividerComponent`.
  @override
  Widget renderComponent(dynamic component, Size screenSize) {
    if (component is DividerComponent) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Dynamically calculate the start and end positions based on the current constraints
          final double startX = component.startPoint.x * constraints.maxWidth;
          final double startY = component.startPoint.y * constraints.maxHeight;
          final double endX = component.endPoint.x * constraints.maxWidth;
          final double endY = component.endPoint.y * constraints.maxHeight;

          // Retrieve the thickness of the divider in pixels
          final double thicknessInPixels = component.thickness;

          // Return a CustomPaint widget that uses the LinePainter to render the divider
          return CustomPaint(
            painter: LinePainter(
              startX: startX,
              startY: startY,
              endX: endX,
              endY: endY,
              thickness: thicknessInPixels,
              color: component.color,
            ),
            size: Size(constraints.maxWidth, constraints.maxHeight),
          );
        },
      );
    } else {
      // Throw an error if the provided component is not a DividerComponent
      throw ArgumentError(
        'Invalid component type for DividerComponentRenderer',
      );
    }
  }
}
