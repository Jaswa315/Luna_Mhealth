// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';
import '../models/component.dart';
import 'irenderer.dart';

/// An abstract class representing a base component renderer.
/// It implements the [IRenderer] interface.
abstract class BaseComponentRenderer<T extends Component> implements IRenderer {
  /// Renders the given [component].
  /// The [component] parameter represents the dynamic component to be rendered.
  /// Returns a [Widget] representing the rendered component.
  /// Throws an [ArgumentError] if the component is not of the correct type.
  @override
  Widget renderComponent(dynamic component) {
    if (component is T) {
      return FutureBuilder<Widget>(
        future: component.render(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) throw Exception('Error loading component');
          if (!snapshot.hasData) throw Exception('No data');

          Map<String, double> lpXY =
              scaleToLogicalPixel(context, component.x, component.y);

          return Positioned(left: lpXY['X'], top: lpXY['Y'], child: snapshot.data!);
        },
      );
    } else {
      throw ArgumentError('component must be of type ${T.toString()}');
    }
  }
}
