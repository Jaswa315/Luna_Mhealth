// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:luna_core/utils/types.dart';
import 'package:uuid/uuid.dart';

import '../enums/item_type.dart';
import 'item.dart';
import 'page.dart';

class Module extends Item {
  late final String moduleId;
  late final String title;
  late final String author;
  late List<Page> pages;
  late final int width;
  late final int height;

  // Constructor with optional named parameters and default values
  Module({
    String? moduleId,
    String? title,
    String? author,
    List<Page>? pages,
    int? width,
    int? height,
  })  : moduleId = moduleId ?? Uuid().v4(),
        title = title ?? "Untitled",
        author = author ?? "Unassigned Author",
        pages = pages ?? [],
        width = width ?? 0,
        height = height ?? 0,
        super(id: moduleId, itemType: ItemType.module);

  /// A factory method that creates a [Module] from a JSON map.
  factory Module.fromJson(Json json) {
    var slidesJson = json['module']['pages'] as List<dynamic>;

    var pages =
        slidesJson.map((slideJson) => Page.fromJson(slideJson)).toList();

    return Module(
      moduleId: json['module']['moduleId'] as String,
      title: json['module']['title'] as String,
      author: json['module']['author'] as String,
      pages: pages,
      width: (json['module']['width'] as num).toInt(),
      height: (json['module']['height'] as num).toInt(),
    );
  }

  /// Converts the [Module] object to a JSON map.
  Json toJson() {
    return {
      'module': {
        'moduleId': moduleId,
        'title': title,
        'author': author,
        'pages': pages.map((page) => page.toJson()).toList(),
        'width': width,
        'height': height,
      },
    };
  }

  @override
  String toString() {
    return 'Module: $title';
  }
}