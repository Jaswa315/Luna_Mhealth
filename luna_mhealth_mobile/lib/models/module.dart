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

  /// Creates a [Module] instance from a JSON map.
  ///
  /// The [json] parameter is a JSON map representing the module.
  /// The 'slides' key in the [json] map should contain a list of page JSON maps.
  /// The 'module_name' key in the [json] map should contain the title of the module.
  /// The 'dimensions' key in the [json] map should contain a map with 'width' and 'height' keys representing the dimensions of the module.
  factory Module.fromJson(Map<String, dynamic> json, [String? directoryPath]) {
    print('Module.fromJson: $json');
    final pages = (json['slides'] as List<dynamic>)
        .map((slideJson) => Page.fromJson(slideJson, directoryPath))
        .toList();

    print('Module.fromJson: Pages => $pages');

    return Module(
      title: json['module_name'] as String,
      pages: pages,
      width: (json['dimensions']['width'] as num).toDouble(),
      height: (json['dimensions']['height'] as num).toDouble(),
    );
  }
}
