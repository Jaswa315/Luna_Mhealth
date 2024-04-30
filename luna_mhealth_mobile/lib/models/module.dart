// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:uuid/uuid.dart';

import '../enums/item_type.dart';
import 'item.dart';
import 'page.dart';

/// Represents a module in the application.
class Module extends Item {
  /// The title of the module.
  final String title;

  /// The pages in the module.
  final List<Page> pages;

  /// The width of the module.
  final double width;

  /// The height of the module.
  final double height;

  /// Constructs a new [Module] instance.
  ///
  /// The [id] parameter is optional. If not provided, a new UUID will be generated.
  /// The [title] parameter is required and represents the title of the module.
  /// The [pages] parameter is required and represents the list of pages in the module.
  /// The [width] parameter is required and represents the width of the module.
  /// The [height] parameter is required and represents the height of the module.
  Module({
    String? id,
    required this.title,
    required this.pages,
    required this.width,
    required this.height,
  }) : super(id: id ?? Uuid().v4(), name: title, itemType: ItemType.module);

  /// A factory method that creates a [Module] object from a JSON map.
  ///
  /// The [json] parameter is a map containing the JSON data for the module.
  /// The method parses the JSON data and returns a new [Module] object.
  factory Module.fromJson(Map<String, dynamic> json) {
    print('Module.fromJson: ${json['module_name']}');

    if (json['slides'] == null) {
      throw FormatException('Expected a "slides" field with an array value.');
    }

    final pages = (json['slides'] as List<dynamic>)
        .map((slideJson) => Page.fromJson(slideJson))
        .toList();

    return Module(
      title: json['module_name'] as String,
      pages: pages,
      width: (json['dimensions']['width'] as num).toDouble(),
      height: (json['dimensions']['height'] as num).toDouble(),
    );
  }
}
