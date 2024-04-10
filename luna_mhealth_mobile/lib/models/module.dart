// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// ignore_for_file: public_member_api_docs

import '../enums/item_type.dart';
import 'item.dart';
import 'page.dart';

/// Represents a module in the application.
///
/// A module is a component that contains a title, description, and a list of pages.
/// It inherits from the [Item] class and implements the [toJson] method for serialization.
class Module extends Item {
  String title;
  String description;
  final List<Page> _pages = [];

  /// Constructs a new instance of the [Module] class with the given [title] and [description].
  ///
  /// The [id] parameter is optional and can be used to specify a unique identifier for the module.
  Module({
    String? id,
    required this.title,
    required this.description,
  }) : super(id: id, name: title, itemType: ItemType.module);

  /// Gets the list of pages in the module.
  List<Page> get pages => List.unmodifiable(_pages);

  /// Adds a [page] to the module.
  ///
  /// The [page] parameter represents the page to be added.
  /// If the page already exists in the module, it will not be added again.
  void addPage(Page page) {
    if (!_pages.contains(page)) {
      _pages.add(page);
    }
  }

  /// Removes a [page] from the module.
  ///
  /// The [page] parameter represents the page to be removed.
  /// If the page exists in the module, it will be removed.
  void removePage(Page page) {
    _pages.remove(page);
  }

  /// Finds a page by its index.
  ///
  /// The [index] parameter represents the index of the page to be found.
  /// Returns the page if found, otherwise returns null.
  Page? findPageByIndex(int index) {
    for (var page in _pages) {
      if (page.index == index) {
        return page;
      }
    }
    return null;
  }

  /// Converts a Module with its Pages to a JSON map.
  ///
  /// Returns a JSON map representation of the module, including its ID, name, description, and pages.
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(), // Include the ID, name, and itemType
      'title': title,
      'description': description,
      'pages': _pages.map((page) => page.toJson()).toList(),
    };
  }

  /// Creates a Module from a JSON map.
  ///
  /// The [json] parameter represents the JSON map to be converted into a module.
  /// Returns a new instance of the Module class.
  factory Module.fromJson(Map<String, dynamic> json) {
    var module = Module(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
    );

    if (json['pages'] != null) {
      var pageList = List<Map<String, dynamic>>.from(json['pages'] as List);
      for (var pageJson in pageList) {
        module.addPage(Page.fromJson(pageJson));
      }
    }

    return module;
  }
}
