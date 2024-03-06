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
import 'interfaces/clickable.dart';
import 'item.dart';

/// Represents an abstract component in the application.
/// A component is an item that can be rendered on the screen and interacted with.
/// It extends the [Item] class and implements the [Clickable] interface.
/// The position and size of the component are represented by a [Rect].
/// Subclasses must implement the [render] method to render the UI for the component.
/// The component can be converted to and from a JSON map using the [toJson] and [fromJson] methods.
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
    double x = 0.0,
    double y = 0.0,
    double width = 0.0,
    double height = 0.0,
  })  : _bounds = Rect.fromLTWH(x, y, width, height),
        super(itemType: ItemType.component);

  /// Sets the position of the component. To ensure that
  /// any change to position notifies listeners for re-rendering.
  void setPosition(double x, double y) {
    _bounds = _bounds.shift(Offset(x - _bounds.left, y - _bounds.top));
    notifyListeners(); // Notifies consumers that a change has occurred.
  }

  /// Sets the size of the component. To ensure that
  /// any change to size notifies listeners for re-rendering.
  void setSize(double width, double height) {
    _bounds = Rect.fromLTWH(_bounds.left, _bounds.top, width, height);
    notifyListeners(); // Notifies consumers that a change has occurred.
  }

  @override
  void onClick() {
    // Should be implemented by subclasses to handle click events.
    // Subclasses will call `notifyListeners()` if the state changes as a result of the click.
  }

  /// Abstract method for rendering the UI.
  /// Should be implemented by subclasses to render the UI for the component.
  /// Returns a [Widget] that represents the rendered UI for the component.
  Widget render();

  /// Converts the component to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'bounds': {
        'x': _bounds.left,
        'y': _bounds.top,
        'width': _bounds.width,
        'height': _bounds.height,
      },
    };
  }

  /// Factory constructor to create a Component from a JSON map.
  static Component fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}
