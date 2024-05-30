// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:ui';

enum ShapeGeometry { ellipse, rectangle, line }

// From MS-ODRAW 1.1 Glossary
const double emuToPointFactor = 12700;

double slideWidth = 0;
double slideHeight = 0;

mixin ToJson {
  Map<String, dynamic> toJson();
}

class Point2D with ToJson {
  final double x;
  final double y;

  Point2D(this.x, this.y);

  @override
  Map<String, dynamic> toJson() {
    return {'x': x / slideWidth, 'y': y / slideHeight};
  }
}

class Transform with ToJson {
  late final Point2D offset;
  late final Point2D size;

  Transform();

  @override
  Map<String, dynamic> toJson() {
    return {'offset': offset.toJson(), 'size': size.toJson()};
  }
}

class PrsNode with ToJson {
  late String name;
  List<PrsNode> children = [];

  PrsNode();

  @override
  Map<String, dynamic> toJson() {
    return {
      name: {'children': children.map((child) => child.toJson()).toList()}
    };
  }
}

class PresentationNode extends PrsNode {
  late final String moduleID;
  late final String title;
  late final String author;
  late final int slideCount;
  late final Map<String, dynamic> section;
  late final double x;
  late final double y;
  late final Locale langLocale;

  static const String defaultSection = 'Default Section';
  static const Locale defaultlangLocale = Locale('en', 'US');

  PresentationNode() {
    name = 'presentation';
    //TODO: get locale info dynamically
    langLocale = defaultlangLocale;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      name: {
        'type': name,
        'moduleId': moduleID,
        'title': title,
        'language': langLocale.toLanguageTag(),
        'author': author,
        'slideCount': slideCount,
        'section': section,
        'slides': children.map((child) => child.toJson()).toList()
      }
    };
  }
}

class SlideNode extends PrsNode {
  late final String slideId;

  SlideNode() {
    name = 'slide';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'slideId': slideId,
      'shapes': children.map((child) => child.toJson()).toList()
    };
  }
}

class TextBoxNode extends PrsNode {
  late final String? audioPath;
  late final int? hyperlink;

  TextBoxNode() {
    name = 'textbox';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      if (audioPath != null) 'audiopath': audioPath,
      if (hyperlink != null) 'hyperlink': hyperlink,
      // TODO: change children name to shape and textbody based on type
      'children': children.map((child) => child.toJson()).toList()
    };
  }
}

class TextBodyNode extends PrsNode {
  late final String? wrap;

  TextBodyNode() {
    name = 'textbody';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'wrap': wrap,
      'paragraphs': children.map((child) => child.toJson()).toList()
    };
  }
}

class TextParagraphNode extends PrsNode {
  late final String? alignment;

  TextParagraphNode() {
    name = 'paragraph';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'alignment': alignment,
      'textgroups': children.map((child) => child.toJson()).toList()
    };
  }
}

// A TextNode is one text token from powerpoint. There can be multiple
// text tokens in a text box. They are separated by text formatting.
class TextNode extends PrsNode {
  late final bool italics;
  late final bool bold;
  late final bool underline;
  late final int? size;
  late int? uid;
  late final String? color;
  late final String? highlightColor;
  late final String? language;
  late final String? text;
  late final int? hyperlink;

  TextNode() {
    name = 'text';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      // 'hyperlink': hyperlink,
      'type': name,
      'uid': uid,
      'italics': italics,
      'bold': bold,
      'underline': underline,
      'size': size,
      'color': color,
      'highlightcolor': highlightColor,
      // 'language': language,
      'text': text,
      if (hyperlink != null) 'hyperlink': hyperlink,
    };
  }
}

class TitleNode extends PrsNode {
  TitleNode() {
    name = 'title';
  }
}

class BodyNode extends PrsNode {
  BodyNode() {
    name = 'body';
  }
}

class ShapeNode extends PrsNode {
  late final Transform transform;
  late final ShapeGeometry shape;
  late final String? audioPath;
  late final int? hyperlink;

  ShapeNode();

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': shape.name,
      'transform': transform.toJson(),
      if (audioPath != null) 'audiopath': audioPath,
      if (hyperlink != null) 'hyperlink': hyperlink,
      'children': children.map((child) => child.toJson()).toList()
    };
  }
}

class ConnectionNode extends PrsNode {
  static const double defaultHalfLineWidth = 6350;
  late final Transform transform;
  late final double weight;
  late final ShapeGeometry shape;

  ConnectionNode(this.transform, this.weight, this.shape) {
    name = shape.name;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'transform': transform.toJson(),
      'weight': weight / emuToPointFactor
    };
  }
}

class ImageNode extends PrsNode {
  late final String? imageName;
  late final String path;
  late final String? altText;
  late final String? audioPath;
  late final int? hyperlink;

  ImageNode() {
    name = 'image';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'path': path,
      'alttext': altText,
      if (audioPath != null) 'audiopath': audioPath,
      if (hyperlink != null) 'hyperlink': hyperlink,
      'children': children.map((child) => child.toJson()).toList()
    };
  }
}

class CategoryGameEditorNode extends PrsNode {
  late final String slideId;

  CategoryGameEditorNode() {
    name = 'categorygameeditor';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'children': children.map((child) => child.toJson()).toList()
    };
  }
}

class CategoryNode extends PrsNode {
  ShapeNode? categoryName;
  ImageNode? categoryImage;

  CategoryNode() {
    name = 'category';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'category': categoryName?.toJson(),
      'categoryImage': categoryImage?.toJson(),
      'children': children.map((child) => child.toJson()).toList()
    };
  }
}