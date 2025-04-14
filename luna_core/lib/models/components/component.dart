// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/widgets.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/utils/types.dart';

/// A class that represents a component in the UI.
/// Components are the building blocks of the UI and can be of different types like text, image, etc.
/// Components can be rendered on the screen.
abstract class Component {
  /// Creates a new Component instance.
  Component({
    required String name,
  });

  /// Abstract method for rendering the UI.
  /// Should be implemented by subclasses to render the UI for the component.
  /// Returns a [Widget] that represents the rendered UI for the component.
  Future<Widget> render(Size screenSize);

  /// Converts a JSON object to a Component object.
  ///
  /// This method takes a [json] object and returns a Component object based on the 'type' field in the JSON.

  static Component fromJson(Json json) {
    final String? type = json['type'];
    switch (type) {
      case 'line':
        return LineComponent.fromJson(json);
      default:
        throw Exception('Unsupported component type: $type');
    }
  }

  static Json serializeComponent(Component component) {
    if (component is LineComponent) {
      return component.toJson();
    } else {
      throw UnimplementedError(
        'Unknown component type: ${component.runtimeType}',
      );
    }
  }
}
