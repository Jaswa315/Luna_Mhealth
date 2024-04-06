import 'package:archive/archive.dart';
import 'presentation_ast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

class PresentationParser {
  static late final String _fileName;

  PresentationParser(String fileName) {
    _fileName = fileName;
  }

  XmlDocument extractXMLFromZip(String xmlFilePath) {
    var bytes = File(_fileName).readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    var file = archive.firstWhere((file) => file.name == xmlFilePath);
    return XmlDocument.parse(utf8.decode(file.content));
  }

  dynamic xmlDocumentToJson(XmlDocument document) {
    Xml2Json xml2json = Xml2Json();

    xml2json.parse(document.toXmlString());

    return jsonDecode(xml2json.toParkerWithAttrs());
  }

  dynamic jsonFromArchive(String filePath) {
    XmlDocument doc = extractXMLFromZip(filePath);
    return xmlDocumentToJson(doc);
  }

  AstNode parsePresentationToAst() {
    Map<String, dynamic> attributes = {};
    List<AstNode> children = [];

    var coreMap = jsonFromArchive("docProps/core.xml");
    var appMap = jsonFromArchive("docProps/app.xml");

    attributes['title'] = coreMap['cp:coreProperties']['dc:title'];
    attributes['author'] = coreMap['cp:coreProperties']['dc:creator'];
    attributes['slide_count'] = appMap['Properties']['Slides'];

    for (int i = 1; i <= int.parse(attributes['slide_count']); i++) {
      AstNode slide = parseSlideToAst(i);
      children.add(slide);
    }

    return PresentationNode(children: children, attributes: attributes);
  }

  AstNode parseSlideToAst(int slideNum) {
    Map<String, dynamic> attributes = {};
    List<AstNode> children = [];

    var slideMap = jsonFromArchive("ppt/slides/slide$slideNum.xml");

    var shapeTree = slideMap['p:sld']['p:cSld']['p:spTree'];

    attributes['slide_number'] = slideNum;

    shapeTree.forEach((key, value) {
      if (key == 'p:pic') {
        var picList = shapeTree[key];
        picList.forEach((jsonMap) {
          children.add(parseImageToAst(jsonMap, slideNum));
        });
      }
      if (key == 'p:sp') {
        var shapeObj = shapeTree[key];
        if (shapeObj is Map<String, dynamic>) {
          children.add(parseShapeToAst(shapeObj));
        } else if (shapeObj is List) {
          shapeObj.forEach((jsonMap) {
            children.add(parseShapeToAst(jsonMap));
          });
        }
      }
    });

    return SlideNode(attributes: attributes, children: children);
  }

  AstNode parseImageToAst(Map<String, dynamic> json, int slideNumber) {
    Map<String, dynamic> attributes = {};
    List<AstNode> children = [];

    var relsMap =
        jsonFromArchive("ppt/slides/_rels/slide$slideNumber.xml.rels");

    attributes['name'] = json['p:nvPicPr']['p:cNvPr']['_name'];
    attributes['alt_txt'] = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    var relNode = relsMap['Relationships']['Relationship']
        .firstWhere((node) => node['_Id'] == relsLink, orElse: () => "");
    attributes['path'] = relNode['_Target'];

    children.add(parseShapeToAst(json['p:spPr']));

    return ImageNode(children: children, attributes: attributes);
  }

  AstNode parseShapeToAst(Map<String, dynamic> json) {
    Map<String, dynamic> attributes = {};
    List<AstNode> children = [];

    if (json['p:nvSpPr']?['p:cNvSpPr']?['_txBox'] == '1') {
      return parseTextBoxToAst(json);
    }

    if (json['p:nvSpPr']?['p:nvPr']?['p:ph']?['_type'] == 'title') {
      // title not finished yet
      return TitleNode(children: [], attributes: {});
    }

    if (json['p:nvSpPr']?['p:nvPr']?['p:ph']?['_type'] == 'body') {
      // title not finished yet
      return BodyNode(children: [], attributes: {});
    }

    attributes['Offset'] = {};
    attributes['Offset']['x'] = json['a:xfrm']['a:off']['_x'];
    attributes['Offset']['y'] = json['a:xfrm']['a:off']['_y'];
    attributes['Size'] = {};
    attributes['Size']['x'] = json['a:xfrm']['a:ext']['_cx'];
    attributes['Size']['y'] = json['a:xfrm']['a:ext']['_cy'];
    String shape = json['a:prstGeom']['_prst'];

    switch (shape) {
      case 'rect':
        return RectangleNode(children: children, attributes: attributes);
      case 'ellipse:':
        return EllipseNode(children: children, attributes: attributes);
      case 'line':
        return LineNode(children: children, attributes: attributes);
      default:
        print('Invalid shape to parse: $shape');
        return AstNode(children, attributes);
    }
  }

  AstNode parseTextBoxToAst(Map<String, dynamic> json) {
    Map<String, dynamic> attributes = {};
    List<AstNode> children = [];

    children.add(parseShapeToAst(json['p:spPr']));
    children.add(parseTextBodyToAst(json['p:txBody']));

    return TextBoxNode(children: children, attributes: attributes);
  }

  AstNode parseTextBodyToAst(Map<String, dynamic> json) {
    Map<String, dynamic> attributes = {};
    List<AstNode> children = [];

    attributes['wrap'] = json['a:bodyPr']?['_wrap'];
    var pObj = json['a:p'];
    if (pObj is List) {
      pObj.forEach((pNode) {
        children.add(parseTextParaToAst(pNode));
      });
    } else if (pObj is Map<String, dynamic>) {
      children.add(parseTextParaToAst(pObj));
    }

    return TextBodyNode(children: children, attributes: attributes);
  }

  AstNode parseTextParaToAst(Map<String, dynamic> json) {
    Map<String, dynamic> attributes = {};
    List<AstNode> children = [];

    attributes['alignment'] = json['a:pPr']?['align'];
    var rObj = json['a:r'];
    if (rObj is List) {
      rObj.forEach((rNode) {
        children.add(parseTextToAst(rNode));
      });
    } else if (rObj is Map<String, dynamic>) {
      children.add(parseTextToAst(rObj));
    }

    return TextParagraphNode(children: children, attributes: attributes);
  }

  AstNode parseTextToAst(Map<String, dynamic> json) {
    Map<String, dynamic> attributes = {};
    List<AstNode> children = [];

    attributes['italics'] = json['a:rPr']['_i'];
    attributes['bold'] = json['a:rPr']['_b'];
    attributes['underline'] = json['a:rPr']['_u'];
    attributes['size'] = json['a:rPr']['_sz'];
    attributes['color'] = json['a:rPr']['a:solidFill']?['a:schemeClr']?['_val'];
    attributes['highlightColor'] =
        json['a:rPr']['a:highligh']?['a:srgbClr']?['_val'];
    attributes['text'] = json['a:t'];

    return TextNode(children: children, attributes: attributes);
  }
}

void main() {
  var filename = "Luna_sample_module.pptx";

  PresentationParser parse = PresentationParser(filename);

  AstNode ast = parse.parsePresentationToAst();

  Map<String, dynamic> astJson = ast.toJson();
  String jsonOutput = JsonEncoder.withIndent('  ').convert(astJson);  

  File('module.json').writeAsStringSync(jsonOutput);
}
