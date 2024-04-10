import 'package:archive/archive.dart';
import 'presentation_tree.dart';
import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

class PresentationParser {
  static late final File _file;
  static int _textTokenCounter = 0; // Global counter to track UID for text tokens 

  PresentationParser(File file) {
    _file = file;
    _textTokenCounter = 0; // Reset the counter when a new PresentationParser instance is created
  }

  XmlDocument extractXMLFromZip(String xmlFilePath) {
    var bytes = _file.readAsBytesSync();
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

  // Changed the return type to PresentationNode
  PresentationNode parsePresentation() {
    PresentationNode node = PresentationNode();

    var coreMap = jsonFromArchive("docProps/core.xml");
    var appMap = jsonFromArchive("docProps/app.xml");

    node.title = coreMap['cp:coreProperties']['dc:title'];
    node.author = coreMap['cp:coreProperties']['dc:creator'];
    node.slideCount = int.parse(appMap['Properties']['Slides']);

    for (int i = 1; i <= node.slideCount; i++) {
      PrsNode slide = parseSlide(i);
      node.children.add(slide);
    }

    return node;
  }

  PrsNode parseSlide(int slideNum) {
    SlideNode node = SlideNode();

    var slideMap = jsonFromArchive("ppt/slides/slide$slideNum.xml");

    var shapeTree = slideMap['p:sld']['p:cSld']['p:spTree'];

    node.slideNum = slideNum;

    shapeTree.forEach((key, value) {
      if (key == 'p:pic') {
        var picList = shapeTree[key];
        picList.forEach((jsonMap) {
          node.children.add(parseImage(jsonMap, slideNum));
        });
      }
      if (key == 'p:sp') {
        var shapeObj = shapeTree[key];
        if (shapeObj is Map<String, dynamic>) {
          node.children.add(parseShape(shapeObj));
        } else if (shapeObj is List) {
          shapeObj.forEach((jsonMap) {
            node.children.add(parseShape(jsonMap));
          });
        }
      }
    });

    return node;
  }

  PrsNode parseImage(Map<String, dynamic> json, int slideNumber) {
    ImageNode node = ImageNode();

    var relsMap =
        jsonFromArchive("ppt/slides/_rels/slide$slideNumber.xml.rels");

    node.imageName = json['p:nvPicPr']['p:cNvPr']['_name'];
    node.altText = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    var relNode = relsMap['Relationships']['Relationship']
        .firstWhere((node) => node['_Id'] == relsLink, orElse: () => "");
    node.path = relNode['_Target'];

    node.children.add(parseShape(json['p:spPr']));

    return node;
  }

  PrsNode parseShape(Map<String, dynamic> json) {
    if (json['p:nvSpPr']?['p:cNvSpPr']?['_txBox'] == '1') {
      return parseTextBox(json);
    }

    if (json['p:nvSpPr']?['p:nvPr']?['p:ph']?['_type'] == 'title') {
      // title not finished yet
      return PrsNode();
    }

    if (json['p:nvSpPr']?['p:nvPr']?['p:ph']?['_type'] == 'body') {
      // title not finished yet
      return PrsNode();
    }

    Offset offset = Offset(double.parse(json['a:xfrm']['a:off']['_x']),
        double.parse(json['a:xfrm']['a:off']['_y']));

    Size size = Size(double.parse(json['a:xfrm']['a:ext']['_cx']),
        double.parse(json['a:xfrm']['a:ext']['_cy']));

    String shape = json['a:prstGeom']['_prst'];

    switch (shape) {
      case 'rect':
        return ShapeNode(offset, size, ShapeGeometry.rectangle);
      case 'ellipse:':
        return ShapeNode(offset, size, ShapeGeometry.ellipse);
      case 'line':
        return ShapeNode(offset, size, ShapeGeometry.line);
      default:
        print('Invalid shape to parse: $shape');
        return PrsNode();
    }
  }

  PrsNode parseTextBox(Map<String, dynamic> json) {
    TextBoxNode node = TextBoxNode();

    node.children.add(parseShape(json['p:spPr']));
    node.children.add(parseTextBody(json['p:txBody']));

    return node;
  }

  PrsNode parseTextBody(Map<String, dynamic> json) {
    TextBodyNode node = TextBodyNode();

    node.wrap = json['a:bodyPr']?['_wrap'];
    var pObj = json['a:p'];
    if (pObj is List) {
      pObj.forEach((pNode) {
        node.children.add(parseTextPara(pNode));
      });
    } else if (pObj is Map<String, dynamic>) {
      node.children.add(parseTextPara(pObj));
    }

    return node;
  }

  PrsNode parseTextPara(Map<String, dynamic> json) {
    TextParagraphNode node = TextParagraphNode();

    node.alignment = json['a:pPr']?['align'];
    var rObj = json['a:r'];
    if (rObj is List) {
      rObj.forEach((rNode) {
        node.children.add(parseText(rNode));
      });
    } else if (rObj is Map<String, dynamic>) {
      node.children.add(parseText(rObj));
    }

    return node;
  }

  PrsNode parseText(Map<String, dynamic> json) {
    TextNode node = TextNode(_textTokenCounter++);
    node.italics = (json['a:rPr']['_i'] == '1') ? true : false;
    node.bold = (json['a:rPr']['_b'] == '1') ? true : false;
    node.underline = (json['a:rPr']['_u'] == 'sng' ? true : false);
    String? sizeStr = json['a:rPr']['_sz'];
    node.size = sizeStr != null ? int.parse(sizeStr) : null;
    node.color = json['a:rPr']['a:solidFill']?['a:schemeClr']?['_val'];
    node.highlightColor = json['a:rPr']['a:highlight']?['a:srgbClr']?['_val'];
    node.text = json['a:t'];

    return node;
  }
}

void main() {
  var filename = "Luna_sample_module.pptx";
  
  File pptx = File(filename);

  PresentationParser parse = PresentationParser(pptx);

  PrsNode prsTree = parse.parsePresentation();

  Map<String, dynamic> astJson = prsTree.toJson();
  String jsonOutput = JsonEncoder.withIndent('  ').convert(astJson);

  File('module.json').writeAsStringSync(jsonOutput);
}
