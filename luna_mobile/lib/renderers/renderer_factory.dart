// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_mobile/renderers/irenderer.dart';
import 'package:luna_mobile/renderers/line_component_renderer.dart';
import 'package:luna_mobile/renderers/text_component_renderer.dart';

/// A factory class for creating component renderers.
class RendererFactory {
  static final Map<Type, IRenderer> _renderers = {
    LineComponent: LineComponentRenderer(),
    TextComponent: TextComponentRenderer(),
  };

  /// Returns the renderer for the specified component type.
  ///
  /// Throws an exception if the component type is not supported.
  static IRenderer getRenderer(Type componentType) {
    if (_renderers.containsKey(componentType)) {
      return _renderers[componentType]!;
    } else {
      throw Exception('Unsupported component type');
    }
  }
}
