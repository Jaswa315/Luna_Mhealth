// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:luna_core/models/shape/divider_component.dart';
import 'package:luna_core/renderers/divider_component_renderer.dart';

import '../models/image/image_component.dart';
import '../models/text/text_component.dart';
import 'image_component_renderer.dart';
import 'irenderer.dart';
import 'text_component_renderer.dart';

/// A factory class for creating component renderers.
class RendererFactory {
  static final Map<Type, IRenderer> _renderers = {
    ImageComponent: ImageComponentRenderer(),
    TextComponent: TextComponentRenderer(),
    DividerComponent: DividerComponentRenderer(),
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
