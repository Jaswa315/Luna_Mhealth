enum ShapeGeometry { ellipse, rect, line }

class AstNode {
  late String name;
  List<AstNode> children;
  Map<String, dynamic> attributes;

  AstNode(this.children, this.attributes);

  Map<String, dynamic> toJson() {
    return {
      name: {        
        'children': children.map((child) => child.toJson()).toList(),
        'attributes': attributes,
      }
    };
  }
}

class PresentationNode extends AstNode {
  PresentationNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Presentation';
  }
}

class SlideNode extends AstNode {
  SlideNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Slide';
  }
}

class TextBoxNode extends AstNode {
  TextBoxNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'TextBox';
  }
}

class TextParagraphNode extends AstNode {
  TextParagraphNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Paragraph';
  }
}

class TextBodyNode extends AstNode {
  TextBodyNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'TextBody';
  }
}

class TextNode extends AstNode {
  TextNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Text';
  }
}

class TitleNode extends AstNode {
  TitleNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Title';
  }
}

class BodyNode extends AstNode {
  BodyNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Body';
  }
}

class PositionNode extends AstNode {
  PositionNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Position';
  }
}

class RectangleNode extends AstNode {
  RectangleNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Rectangle';
  }
}

class EllipseNode extends AstNode {
  EllipseNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Ellipse';
  }
}

class LineNode extends AstNode {
  LineNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Line';
  }
}

class ImageNode extends AstNode {
  ImageNode(
      {required List<AstNode> children,
      required Map<String, dynamic> attributes})
      : super(children, attributes) {
    name = 'Image';
  }
}
