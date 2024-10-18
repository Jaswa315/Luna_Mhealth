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

/// Represents a presentation module in the application.
class Module extends Item {
  /// The type of the module, typically "presentation".
  final String type = "module";

  /// A unique identifier for the module.
  final String moduleId;

  /// The title of the presentation.
  final String title;

  /// The author of the presentation.
  final String author;

  /// The count of slides in the presentation.
  final int slideCount;

  /// Sections of the presentation with associated slides.
  final Map<String, List<String>> section;

  /// The pages (slides) in the presentation.
  final List<Page> pages;

  /// The width of the module.
  final double width;

  /// The height of the module.
  final double height;

  /// Constructs a new [Module] instance.
  Module({
    String? id,
    required this.moduleId,
    required this.title,
    required this.author,
    required this.slideCount,
    required this.section,
    required this.pages,
    required this.width,
    required this.height,
    required String name,
  }) : super(id: id ?? Uuid().v4(), name: name, itemType: ItemType.module);

  /// A factory method that creates a [Module] from a JSON map.
  factory Module.fromJson(Map<String, dynamic> json) {
    var slidesJson = json['module']['pages'] as List<dynamic>;

    var pages =
        slidesJson.map((slideJson) => Page.fromJson(slideJson)).toList();

    var sectionMap = Map<String, List<String>>.from(json['module']['section']);

    return Module(
        moduleId: json['module']['moduleId'] as String,
        title: json['module']['title'] as String,
        author: json['module']['author'] as String,
        slideCount: json['module']['slideCount'] as int,
        section: sectionMap,
        pages: pages,
        width: (json['module']['width'] as num).toDouble(),
        height: (json['module']['height'] as num).toDouble(),
        name: json['module']['name']);
  }

  /// Converts the [Module] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'module': {
        'moduleId': moduleId,
        'title': title,
        'name': super.name,
        'author': author,
        'slideCount': slideCount,
        'section': section.map((key, value) => MapEntry(key, value)),
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
