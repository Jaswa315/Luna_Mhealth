// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:ui';

/// Possible shape geometry in a presentation
enum ShapeGeometry { 
  /// an ellipse shape
  ellipse, 
  /// a recangle shape
  rectangle,
  /// a line shape
  line }

/// From MS-ODRAW 1.1 Glossary
const double emuToPointFactor = 12700;

/// mixin to have classes implement toJson
mixin ToJson {
  /// Ensure all toJson classes implement a toJson method which returns a map
  Map<String, dynamic> toJson();
}

/// a parsed 2D point from a presentation
class Point2D with ToJson {
  /// x location
  final double x;
  /// y location
  final double y;

  /// Constructer with specifiied [x] and [y] coordinates
  Point2D(this.x, this.y);

  @override
  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }
}

/// [Transform] which is a [PrsNode] that includes offset and size information
class Transform extends PrsNode with ToJson {
  /// offset of the transform
  late final Point2D offset;
  /// size of the transform
  late final Point2D size;

  /// Constructor for [Transform]
  Transform();

  @override
  Map<String, dynamic> toJson() {
    return {'offset': offset.toJson(), 'size': size.toJson()};
  }
}

/// A class for presentations that ensures a toJson method and a name
class PrsNode with ToJson {
  /// name of prsnode
  late String name;
  /// nodes children
  List<PrsNode> children = [];

  /// constructor for [PrsNode]
  PrsNode();

  @override
  Map<String, dynamic> toJson() {
    return {
      name: {'children': children.map((child) => child.toJson()).toList()}
    };
  }
}

/// A class a generic presentation node
class PresentationNode extends PrsNode {
  /// module id
  late final String moduleID;
  /// title
  late final String title;
  /// author
  late final String author;
  /// number of slides
  late final int slideCount;
  /// section
  late final Map<String, dynamic> section;
  /// width of this node
  late final double width;
  /// height of this node
  late final double height;
  /// language locale of prs node
  late final Locale langLocale;

  /// default placeholder for default section
  static const String defaultSection = 'Default Section';
  /// default language locale
  static const Locale defaultlangLocale = Locale('en', 'US');

/// A constructor for the [PresentationNode]
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
        'author': author,
        'slideCount': slideCount,
        'section': section,
        'width': width,
        'height': height,
        'language': langLocale.toLanguageTag(),
        'slides': children.map((child) => child.toJson()).toList()
      }
    };
  }
}

/// A node for a slide
class SlideNode extends PrsNode {
  /// ID for the slide
  late final String slideId;
  /// left, top, right, bottom padding of the slide
  late final Map<String, double>
      padding; 

/// Constructor for a [SlideNode] sets name to "slide"
  SlideNode() {
    name = 'slide';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': name,
      'slideId': slideId,
      'padding': padding,
      'shapes': children.map((child) => child.toJson()).toList()
    };
  }
}

/// a text box from a PowerPoint presentation
class TextBoxNode extends PrsNode {
  /// audio location for the textbox
  late final String? audioPath;
  /// hyperlink for the text
  late final int? hyperlink;

  /// Constructor for text box that sets a static name
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

/// Body for text from a PowerPoint presentation
class TextBodyNode extends PrsNode {
  /// whether to wrap the text
  late final String? wrap;

  /// Constructor for textbody node
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

/// A paragraph of text parsed from a PowerPoint presentation
class TextParagraphNode extends PrsNode {
  /// the alignment of the text
  late final String? alignment;

  /// Constructor for [TextParagraphNode]
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

/// A TextNode is one text token from powerpoint. There can be multiple
/// text tokens in a text box. They are separated by text formatting.
class TextNode extends PrsNode {
  /// Setting for it text has italics
  late final bool italics;
  /// Setting for it text has bold
  late final bool bold;
  /// Setting for it text has underline
  late final bool underline;
  /// Setting for font size of text
  late final int? size;
  /// UID for text
  late int? uid;
  /// Color of text
  late final String? color;
  /// Highlight color of text
  late final String? highlightColor;
  /// Language for the text
  late final String? language;
  /// Actual text of the text
  late final String? text;
  /// Hyperlink for the text
  late final int? hyperlink;

  /// Constructor for a [TextNode]
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

/// Title of a PowerPoint presentation
class TitleNode extends PrsNode {
  ///Constructor for title node
  TitleNode() {
    name = 'title';
  }
}

/// Body node of a powerpoint presentation
class BodyNode extends PrsNode {
  ///Constructor for body node
  BodyNode() {
    name = 'body';
  }
}

/// A [ShapeNode] is a shape from a PowerPoint presentation
class ShapeNode extends PrsNode {
  /// Transform of this shape
  late final PrsNode? transform;
  /// The type of geometry this shape has
  late final ShapeGeometry shape;
  /// Possible audio path location for this shape
  late final String? audioPath;
  /// Possible hyperlink for this shape
  late final int? hyperlink;
  /// Possible textBody for this shape
  late final PrsNode? textBody;

  /// Constructor for shape node
  ShapeNode();

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': shape.name,
      'transform': transform?.toJson(),
      if (textBody != null) 'textBody': textBody?.toJson(),
      if (audioPath != null) 'audiopath': audioPath,
      if (hyperlink != null) 'hyperlink': hyperlink,
      'children': children.map((child) => child.toJson()).toList()
    };
  }
}

/// A connection from a PowerPoint presentation
class ConnectionNode extends PrsNode {
  /// Default half of the line width
  static const double defaultHalfLineWidth = 6350;
  /// Transform for this connection node
  late final Transform transform;
  /// Weight of the connection
  late final double weight;
  /// Shape of the connection
  late final ShapeGeometry shape;

  /// Constructor for the connection node
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

/// Page Image
class ImageNode extends PrsNode {
  /// Name of the image
  late final String? imageName;
  /// Path of the image
  late final String path;
  /// Alternate text for the image
  late final String? altText;
  /// Audio path for the iamge
  late final String? audioPath;
  /// Hyperlink for the image
  late final int? hyperlink;
  /// Transform for the image
  late Transform transform;

  /// Constructor for an [ImageNode]
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
      'transform': transform.toJson(),
      'children': children.map((child) => child.toJson()).toList()
    };
  }
}
