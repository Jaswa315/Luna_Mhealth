enum ShapeGeometry { ellipse, rectangle, line }

class Offset {
  final double x;
  final double y;

  Offset(this.x, this.y);

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }
}

class Size {
  final double x;
  final double y;

  Size(this.x, this.y);

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }
}

class PrsNode {
  late String name;
  List<PrsNode> children = [];

  PrsNode();

  Map<String, dynamic> toJson() {
    return {
      name: {'children': children.map((child) => child.toJson()).toList()}
    };
  }
}

class PresentationNode extends PrsNode {
  late final String title;
  late final String author;
  late final int slideCount;
  late final List section;

  PresentationNode() {
    name = 'presentation';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      name: {
        'type': name,
        'title': title,
        'author': author,
        'slideCount': slideCount,
        // TODO: should we combine section with the slides?
        // For example, 
        // slides[0] = "Default Section"
        // slides[1] = actual slide 
        // slides[2] = actual slide 
        // slides[3] = "Section 2"
        // ...
        'section' : section,
        'slides': children.map((child) => child.toJson()).toList()
      }
    };
  }
}

class SlideNode extends PrsNode {
  late final int slideNum;

  SlideNode() {
    name = 'slide';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'slideNum': slideNum,
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

class TextNode extends PrsNode {
  late final bool italics;
  late final bool bold;
  late final bool underline;
  late final int? size;
  late final String? color;
  late final String? highlightColor;
  late final String? text;
  TextNode() {
    name = 'text';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'italics': italics,
      'bold': bold,
      'underline': underline,
      'size': size,
      'color': color,
      'highlightcolor': highlightColor,
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
  late final Offset offset;
  late final Size size;
  late final ShapeGeometry shape;

  ShapeNode(this.offset, this.size, this.shape) {
    name = shape.name;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': name, "offset": offset, "size": size, "shape": shape.name};
  }
}

class ConnectionNode extends PrsNode {
  late final Offset offset;
  late final Size size;
  late final double weight;
  late final ShapeGeometry shape;

  ConnectionNode(this.offset, this.size, this.weight, this.shape) {
    name = shape.name;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': name, "offset": offset, "size": size, "weight": weight, "shape": shape.name};
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
      'imagename': imageName,
      'path': path,
      'alttext': altText,
      'shapes': children.map((child) => child.toJson()).toList()
    };
  }
}
