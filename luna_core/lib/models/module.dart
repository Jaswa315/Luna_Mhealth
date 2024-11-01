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
  final String moduleId;
  final String title;
  final String author;
  final int slideCount;
  final List<Page> pages;
  final double width;
  final double height;

  Module({
    String? moduleId,
    required this.title,
    required this.author,
    required this.slideCount,
    required this.pages,
    required this.width,
    required this.height,
    required String name,
  })  : moduleId = moduleId ?? Uuid().v4(),
        super(id: moduleId, name: name, itemType: ItemType.module);

  /// A factory method that creates a [Module] from a JSON map.
  factory Module.fromJson(Json json) {
    var slidesJson = json['module']['pages'] as List<dynamic>;

    var pages =
        slidesJson.map((slideJson) => Page.fromJson(slideJson)).toList();

    return Module(
        moduleId: json['module']['moduleId'] as String,
        title: json['module']['title'] as String,
        author: json['module']['author'] as String,
        slideCount: json['module']['slideCount'] as int,
        pages: pages,
        width: (json['module']['width'] as num).toDouble(),
        height: (json['module']['height'] as num).toDouble(),
        name: json['module']['name']);
  }

  /// Converts the [Module] object to a JSON map.
  Json toJson() {
    return {
      'module': {
        'moduleId': moduleId,
        'title': title,
        'name': super.name,
        'author': author,
        'slideCount': slideCount,
        'pages': pages.map((page) => page.toJson()).toList(),
        'width': width,
        'height': height,
      }
    };
  }

  @override
  String toString() {
    return 'Module: $title';
  }
}
