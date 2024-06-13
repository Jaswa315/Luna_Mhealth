// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/foundation.dart';
import 'package:luna_mhealth_mobile/games/gamecontext.dart';
import 'package:uuid/uuid.dart';

import '../enums/item_type.dart';
import 'item.dart';
import 'page.dart';

/// Represents a presentation module in the application.
class Module extends Item {
  /// The type of the module, typically "presentation".
  final String type;

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

  ///The games in the module
  final List<GameContext> games;

  /// The width of the module.
  final double width;

  /// The height of the module.
  final double height;

  /// Constructs a new [Module] instance.
  Module({
    String? id,
    required this.type,
    required this.moduleId,
    required this.title,
    required this.author,
    required this.slideCount,
    required this.section,
    required this.pages,
    required this.games,
    required this.width,
    required this.height,
  }) : super(id: id ?? Uuid().v4(), name: title, itemType: ItemType.module);

  /// A factory method that creates a [Module] from a JSON map.
  factory Module.fromJson(Map<String, dynamic> json) {
    var slidesJson = json['presentation']['slides'] as List<dynamic>;

    final category_games = (json['category_games'] as List<dynamic>)
        .map((slideJson) => GameContext.fromJson(slideJson))
        .toList();

    var pages =
        slidesJson.map((slideJson) => Page.fromJson(slideJson, category_games)).toList();

    var sectionMap =
        Map<String, List<String>>.from(json['presentation']['section']);
    if (json['category_games'] == null) {
      throw FormatException('Expected a "category_games" field with an array value.');
    }

    


    return Module(
      type: json['presentation']['type'] as String,
      moduleId: json['presentation']['moduleId'] as String,
      title: json['presentation']['title'] as String,
      author: json['presentation']['author'] as String,
      slideCount: json['presentation']['slideCount'] as int,
      section: sectionMap,
      pages: pages,
      games: category_games,
      width: (json['dimensions']['width'] as num).toDouble(),
      height: (json['dimensions']['height'] as num).toDouble(),
    );
  }

  /// Converts the [Module] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'presentation': {
        'type': type,
        'moduleId': moduleId,
        'title': title,
        'author': author,
        'slideCount': slideCount,
        'section': section,
        'slides': pages.map((page) => page.toJson()).toList(),
      }
    };
  }

  @override
  String toString() {
    return 'Module: $title';
  }
}
