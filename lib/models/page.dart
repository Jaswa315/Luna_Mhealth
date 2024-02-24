// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Represents a page in the application.
/// A page can contain multiple components.
// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'component.dart';

/// Represents a page in the application.
///
/// A page contains a list of components that can be added or removed.
/// It can be converted to and from a JSON map.
class Page {
  int index;
  final List<Component> _components = [];

  /// Constructs a new instance of [Page] with the given [index].
  Page({required this.index});

  List<Component> get components => List.unmodifiable(_components);

  /// Adds a [component] to the page.
  void addComponent(Component component) {
    _components.add(component);
  }

  /// Removes a [component] from the page.
  void removeComponent(Component component) {
    _components.remove(component);
  }

  /// Converts a Page into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'components': _components.map((c) => c.toJson()).toList(),
    };
  }

  /// Creates a Page from a JSON map.
  factory Page.fromJson(Map<String, dynamic> json) {
    var page = Page(index: json['index'] as int);

    if (json['components'] != null) {
      var componentsList =
          List<Map<String, dynamic>>.from(json['components'] as List);
      for (var compJson in componentsList) {
        var component = Component.fromJson(compJson);
        page.addComponent(component);
      }
    }

    return page;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
