// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';

import '../models/text/text_component.dart';
import 'component_factory.dart';

/// A class that implements the [ComponentRenderer] interface and is responsible for rendering text components.
class TextComponentRenderer implements ComponentRenderer {
  @override
  Widget renderComponent(dynamic component, double scale, String moduleTitle) {
    if (component is TextComponent) {
      return FutureBuilder<Widget>(
        future: component.render(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error loading text');
              } else {
                return snapshot.data!;
              }
            default:
              return CircularProgressIndicator();
          }
        },
      );
    } else {
      throw ArgumentError('component must be of type TextComponent');
    }
  }
}
