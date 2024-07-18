// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Represents a page in the application.
/// A page can contain multiple components.

import 'dart:convert';
import 'package:luna_core/enums/component_type.dart';
import 'package:luna_core/enums/item_type.dart';
import 'package:luna_core/models/item.dart';
import 'package:luna_mhealth_mobile/games/gamecontext.dart';

import 'component.dart';

/// Represents a page in the application.
///
/// A page contains a list of components that can be added or removed.
/// It can be converted to and from a JSON map.
class Page extends Item {
  /// The unique identifier for the slide.
  final String slideId;

  /// A list of components on the slide.
  final List<Component> components;

  /// Constructs a new instance of [Page].
  Page({    
    required this.slideId,
    List<Component>? components, 
  }) : components = components ?? [], super(itemType: ItemType.page);

  /// Gets the list of components in the page.
  List<Component> get getPageComponents => List.unmodifiable(components);

  /// Adds a component to the page.
  void addComponent(Component component) {
    components.add(component);
  }

  /// Removes a component from the page.
  void removeComponent(Component component) {
    components.remove(component);
  }

  /// Converts a JSON map into a Page, ensuring it only includes slides of type "slide".
  /// ToDo: Fix parameter dependency on GameContext
  factory Page.fromJson(Map<String, dynamic> json,
      {List<GameContext> gameContexts = const []}) {
    if (json['type'] != ItemType.page.name) {
      throw FormatException('Only page type components are allowed');
    }

    List<Component> components = (json['shapes'] as List<dynamic>)
        .map((shapeJson) => Component.fromJson(shapeJson, games: gameContexts))
        .toList();

    return Page(      
      slideId: json['slideId'] as String,
      components: components,
    );
  }

  /// Converts a Page into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': super.itemType.name,
      'slideId': slideId,
      'shapes': components.map((c) => c.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
