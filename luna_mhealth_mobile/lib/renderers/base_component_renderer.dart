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

/// A base class for rendering components.
abstract class BaseComponentRenderer<T extends Component> implements IRenderer {
  @override
  Widget renderComponent(dynamic component, double scale) {
    if (component is T) {
      return FutureBuilder<Widget>(
        future: component.render(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error loading component');
          }
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return Text('No data');
        },
      );
    } else {
      throw ArgumentError('component must be of type ${T.toString()}');
    }
  }
}
