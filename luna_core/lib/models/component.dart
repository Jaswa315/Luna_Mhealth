// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/widgets.dart';
import 'package:luna_core/enums/component_type.dart';
import 'package:luna_core/enums/item_type.dart';
import 'package:luna_core/models/image/image_component.dart';
import 'package:luna_core/models/interfaces/clickable.dart';
import 'package:luna_core/models/item.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'package:luna_core/models/text/text_component.dart';

/// A class that represents a component in the UI.
/// Components are the building blocks of the UI and can be of different types like text, image, etc.
/// Components can be rendered on the screen.
abstract class Component extends Item with ChangeNotifier, Clickable {
  /// The type of the component.
  final ComponentType type;

  /// x position of component
  final double x;

  /// y position of component
  final double y;

  /// width of component
  final double width;

  /// height of component
  final double height;

  /// The position and size of the component represented as a Rect.
  Rect _bounds;

  /// Getter for bounds as a defensive copy to prevent external modification.
  Rect get bounds =>
      Rect.fromLTWH(_bounds.left, _bounds.top, _bounds.width, _bounds.height);

  /// Creates a new Component instance.
  Component({
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required String name,
  })  : _bounds = Rect.fromLTWH(x, y, width, height),
        super(itemType: ItemType.component, name: name);

  /// Abstract method for rendering the UI.
  /// Should be implemented by subclasses to render the UI for the component.
  /// Returns a [Widget] that represents the rendered UI for the component.
  Future<Widget> render(Size screenSize);

  /// Converts a JSON object to a Component object.
  ///
  /// This method takes a [json] object and returns a Component object based on the 'type' field in the JSON.

  static Component fromJson(Map<String, dynamic> json) {
    ComponentType? type = _typeMapping[json['type']];
    switch (type) {
      case ComponentType.image:
        return ImageComponent.fromJson(json);
      case ComponentType.text:
        return TextComponent.fromJson(json);
      case ComponentType.divider:
        return DividerComponent.fromJson(json);
      default:
        throw Exception('Unsupported component type: $type.toString()');
    }
  }
}

/// A mapping of component type IDs to ComponentType enum values.
const Map<String, ComponentType> _typeMapping = {
  'image': ComponentType.image,
  'text': ComponentType.text,
  'divider': ComponentType.divider
};
