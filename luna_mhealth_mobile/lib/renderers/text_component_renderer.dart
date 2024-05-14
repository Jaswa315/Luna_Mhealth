// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import '../models/text/text_component.dart';
import 'base_component_renderer.dart';

// /// A class that implements the [IRenderer] interface and is responsible for rendering text components.
// class TextComponentRenderer implements IRenderer {
//   @override
//   Widget renderComponent(dynamic component, double scale) {
//     if (component is TextComponent) {
//       return FutureBuilder<Widget>(
//         future: component.render(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return CircularProgressIndicator();
//             case ConnectionState.done:
//               if (snapshot.hasError) {
//                 return Text('Error loading text');
//               } else {
//                 return snapshot.data!;
//               }
//             default:
//               return CircularProgressIndicator();
//           }
//         },
//       );
//     } else {
//       throw ArgumentError('component must be of type TextComponent');
//     }
//   }
// }

/// A class that extends the [BaseComponentRenderer] class to render text components.
class TextComponentRenderer extends BaseComponentRenderer<TextComponent> {}
