// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

enum ShapeGeometry { ellipse, rectangle, line }

const double emuToPointFactor = 12700;

double slideWidth = 0;
double slideHeight = 0;

class Position {
  final double x;
  final double y;

  Position(this.x, this.y);

  Map<String, dynamic> toJson() {
    return {'x': x / slideWidth, 'y': y / slideHeight};
  }
}

mixin ToJson {
  Map<String, dynamic> toJson();
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
  late final String moudleId;
  late final String title;
  late final String author;
  late final int slideCount;
  late final Map<String, dynamic> section;
  late final double x;
  late final double y;
  static const String defulatSection = "Default Section";

  PresentationNode() {
    name = 'presentation';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      name: {
        'type': name,
        'moduleId': moudleId,
        'title': title,
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
  TextBoxNode() {
    name = 'textbox';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      // todo, change children name to shape and textbody based on type
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
  // late final int? hyperlink;
  late final bool italics;
  late final bool bold;
  late final bool underline;
  late final int? size;
  late int?
      uid; // This uid will be used as a key to reference Localized UIDObjects
  late final String? color;
  late final String? highlightColor;
  late final String? language;
  late final String? text;

  TextNode() {
    name = 'text';
    uid = null;
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
      'language': language,
      'text': text
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
  late final Position offset;
  late final Position size;
  late final ShapeGeometry shape;

  ShapeNode(this.offset, this.size, this.shape) {
    name = shape.name;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': name, "offset": offset, "size": size};
  }
}

class ConnectionNode extends PrsNode {
  static const double defaultHalfLineWidth = 6350;
  late final Position offset;
  late final Position size;
  late final double weight;
  late final ShapeGeometry shape;

  ConnectionNode(this.offset, this.size, this.weight, this.shape) {
    name = shape.name;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      "offset": offset,
      "size": size,
      "weight": weight / emuToPointFactor
    };
  }
}

class ImageNode extends PrsNode {
  late final String? imageName;
  late final String path;
  late final String? altText;

  ImageNode() {
    name = 'image';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'path': path,
      'alttext': altText,
      'position': children.map((child) => child.toJson()).toList()
    };
  }
}
