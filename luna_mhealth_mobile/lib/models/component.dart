// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Represents a component in the Luna mHealth Mobile application.
///
/// A component is an abstract class that defines the common properties and methods
/// for all UI components in the application. It provides information about the type,
/// position, size, and rendering of a component.
///
/// Subclasses of [Component] should implement the [load] method to load any required
/// assets and the [render] method to render the UI for the component.
// ignore_for_file: public_member_api_docs, comment_references

import 'package:flutter/widgets.dart';
import 'package:luna_mhealth_mobile/enums/item_type.dart';

import '../enums/component_type.dart';
import 'image/image_component.dart';
import 'interfaces/clickable.dart';
import 'item.dart';
import 'text/text_component.dart';

/// Represents an abstract component in the application.
/// A component is an item that can be rendered on the screen and interacted with.
/// It extends the [Item] class and implements the [Clickable] interface.
/// The position and size of the component are represented by a [Rect].
/// Subclasses must implement the [render] method to render the UI for the component.
/// The component can be converted from a JSON map using the fromJson] method.
abstract class Component extends Item with ChangeNotifier implements Clickable {
  /// The type of the component.
  final ComponentType type;

  /// The position and size of the component represented as a Rect.
  Rect _bounds;

  /// Getter for bounds as a defensive copy to prevent external modification.
  Rect get bounds =>
      Rect.fromLTWH(_bounds.left, _bounds.top, _bounds.width, _bounds.height);

  /// Creates a new Component instance.
  Component({
    required this.type,
    required double x,
    required double y,
    required double width,
    required double height,
    required String name,
  })  : _bounds = Rect.fromLTWH(x, y, width, height),
        super(itemType: ItemType.component, name: name);

  /// Abstract method for rendering the UI.
  /// Should be implemented by subclasses to render the UI for the component.
  /// Returns a [Widget] that represents the rendered UI for the component.
  Widget render();

  static Component fromJson(Map<String, dynamic> json, [String? directoryPath]) {
    print('Component.fromJson: $json');
    ComponentType? type = typeMapping[json['type']];
    switch (type) {
      case ComponentType.image:
        return ImageComponent.fromJson(json, directoryPath);
      case ComponentType.text:
        return TextComponent.fromJson(json);
      default:
        throw Exception('Unsupported component type');
    }
  }
}

const Map<int, ComponentType> typeMapping = {
  13: ComponentType.image,
  17: ComponentType.text,
};
