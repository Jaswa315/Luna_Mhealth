// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:archive/archive.dart';
import 'presentation_tree.dart';
import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'package:uuid/uuid.dart';

const String keyPicture = 'p:pic';
const String keyShape = 'p:sp';
const String keyConnectionShape = 'p:cxnSp';

class PresentationParser {
  //removed static so the localization_test and parser_test work
  late final File _file;
  static const uuidGenerator = Uuid();

  PresentationParser(File file) {
    _file = file;
  }

  XmlDocument _extractXMLFromZip(String xmlFilePath) {
    var bytes = _file.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    var file = archive.firstWhere((file) => file.name == xmlFilePath);
    return XmlDocument.parse(utf8.decode(file.content));
  }

  dynamic _xmlDocumentToJson(XmlDocument document) {
    Xml2Json xml2json = Xml2Json();

    // "&#xA" is equivalent to Line Feed Character (\n)
    String processedXml = document.toXmlString().replaceAll('&#xA;', '\\n');

    xml2json.parse(processedXml);

    return jsonDecode(xml2json.toParkerWithAttrs());
  }

  dynamic jsonFromArchive(String filePath) {
    XmlDocument doc = _extractXMLFromZip(filePath);
    return _xmlDocumentToJson(doc);
  }

  PrsNode _parsePresentation() {
    PresentationNode node = PresentationNode();

    var coreMap = jsonFromArchive("docProps/core.xml");
    var appMap = jsonFromArchive("docProps/app.xml");
    var presentationMap = jsonFromArchive("ppt/presentation.xml");

    node.title = coreMap['cp:coreProperties']['dc:title'];
    node.author = coreMap['cp:coreProperties']['dc:creator'];
    node.slideCount = int.parse(appMap['Properties']['Slides']);
    node.moudleId = uuidGenerator.v4();

    // parse SlideIdList
    var slideIdList =
        presentationMap['p:presentation']['p:sldIdLst']['p:sldId'];
    List<String> parserdSlideIdList = [];
    if (slideIdList is Map<String, dynamic>) {
      parserdSlideIdList = ['S${slideIdList["_id"]}'];
    } else {
      for (var slide in slideIdList) {
        parserdSlideIdList.add('S${slide["_id"]}');
      }
    }

    // parse Section
    if (presentationMap['p:presentation']['p:extLst'] == null ||
        presentationMap['p:presentation']['p:extLst']['p:ext']
            is Map<String, dynamic> ||
        presentationMap['p:presentation']['p:extLst']['p:ext'][0]
                ['p14:sectionLst'] ==
            null) {
      node.section = {
        PresentationNode.defulatSection: List<String>.generate(
            node.slideCount, (index) => parserdSlideIdList[index])
      };
    } else {
      node.section = _parseSection(
          presentationMap['p:presentation']['p:extLst']['p:ext'][0]
              ['p14:sectionLst']['p14:section'],
          parserdSlideIdList);
    }

    // TODO: Branch if the slide is game editor
    for (int i = 1; i <= node.slideCount; i++) {
      PrsNode slide = _parseSlide(i, parserdSlideIdList);
      node.children.add(slide);
    }

    return node;
  }

  Map<String, dynamic> _parseSection(List<dynamic> json, List slideIdKeys) {
    Map<String, dynamic> sectionWithSlide = {};

    int currentSlideNumber = 0;

    json.forEach((section) {
      String currentSection = section['_name'];
      sectionWithSlide[currentSection] = [];

      // if sldIdLst is "", it means it has 0 slides in that section
      // if sldId is Map, it only contains one slide in that section
      // if sldId is List, it has at least 2 slides in that section

      if (section['p14:sldIdLst'] != "") {
        if (section['p14:sldIdLst']['p14:sldId'] is Map<String, dynamic>) {
          sectionWithSlide[currentSection].add(slideIdKeys[currentSlideNumber]);
          currentSlideNumber += 1;
        } else {
          List slideList = section['p14:sldIdLst']['p14:sldId'];
          sectionWithSlide[currentSection] = List<String>.generate(
              slideList.length.toInt(),
              (index) => slideIdKeys[index + currentSlideNumber]);
          currentSlideNumber += slideList.length.toInt();
        }
      }
    });

    return sectionWithSlide;
  }

  PrsNode _parseSlide(int slideNum, var slideIdList) {
    // TODO: store slide's hyperlink info.
    
    SlideNode node = SlideNode();

    var slideMap = jsonFromArchive("ppt/slides/slide$slideNum.xml");

    var shapeTree = slideMap['p:sld']['p:cSld']['p:spTree'];

    node.slideId = slideIdList[slideNum - 1];

    shapeTree.forEach((key, value) {
      switch (key) {
        case keyPicture:
          var picList = shapeTree[key];
          if (picList is Map<String, dynamic>) {
            node.children.add(_parseImage(picList, slideNum));
          } else if (picList is List) {
            picList.forEach((jsonMap) {
              node.children.add(_parseImage(jsonMap, slideNum));
            });
          }
        case keyShape:
          var shapeObj = shapeTree[key];
          if (shapeObj is Map<String, dynamic>) {
            node.children.add(_parseShape(shapeObj));
          } else if (shapeObj is List) {
            shapeObj.forEach((jsonMap) {
              node.children.add(_parseShape(jsonMap));
            });
          }
        case keyConnectionShape:
          var connectionShapeObj = shapeTree[key];
          if (connectionShapeObj is Map<String, dynamic>) {
            node.children
                .add(_parseConnectionShape(connectionShapeObj['p:spPr']));
          } else if (connectionShapeObj is List) {
            connectionShapeObj.forEach((jsonMap) {
              node.children.add(_parseConnectionShape(jsonMap['p:spPr']));
            });
          }
      }
    });

    return node;
  }

  PrsNode _parseImage(Map<String, dynamic> json, int slideNumber) {
    ImageNode node = ImageNode();

    var relsMap =
        jsonFromArchive("ppt/slides/_rels/slide$slideNumber.xml.rels");

    node.imageName = json['p:nvPicPr']['p:cNvPr']['_name'];
    node.altText = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    var relNode = relsMap['Relationships']['Relationship']
        .firstWhere((node) => node['_Id'] == relsLink, orElse: () => "");
    node.path = relNode['_Target'];

    node.children.add(_parseGeometry(json['p:spPr']));

    return node;
  }

  PrsNode _parseShape(Map<String, dynamic> json) {
    // Textbox
    if (json['p:nvSpPr']?['p:cNvSpPr'] != "" &&
        json['p:nvSpPr']?['p:cNvSpPr']?['_txBox'] == '1') {
      return _parseTextBox(json);
    }

    if (json['p:nvSpPr']?['p:nvPr'] != "" &&
        json['p:nvSpPr']?['p:nvPr']?['p:ph']?['_type'] == 'title') {
      // title not finished yet
      return PrsNode();
    }

    if (json['p:nvSpPr']?['p:nvPr'] != "" &&
        json['p:nvSpPr']?['p:nvPr']?['p:ph']?['_type'] == 'body') {
      // body not finished yet
      return PrsNode();
    }

    // Vanilla Shape (Ellipse/Oval, Rectangle)
    return _parseGeometry(json['p:spPr']);
  }

  PrsNode _parseGeometry(Map<String, dynamic> json) {
    Position offset = Position(double.parse(json['a:xfrm']['a:off']['_x']),
        double.parse(json['a:xfrm']['a:off']['_y']));

    Position size = Position(double.parse(json['a:xfrm']['a:ext']['_cx']),
        double.parse(json['a:xfrm']['a:ext']['_cy']));

    String shape = json['a:prstGeom']['_prst'];

    switch (shape) {
      case 'rect':
        return ShapeNode(offset, size, ShapeGeometry.rectangle);
      case 'ellipse':
        return ShapeNode(offset, size, ShapeGeometry.ellipse);
      default:
        print('Invalid shape to parse: $shape');
        return PrsNode();
    }
  }

  PrsNode _parseConnectionShape(Map<String, dynamic> json) {
    Position offset = Position(double.parse(json['a:xfrm']['a:off']['_x']),
        double.parse(json['a:xfrm']['a:off']['_y']));

    Position size = Position(double.parse(json['a:xfrm']['a:ext']['_cx']),
        double.parse(json['a:xfrm']['a:ext']['_cy']));

    double weight = json['a:ln'] == null || json['a:ln']['_w'] == null
        ? ConnectionNode.defaultHalfLineWidth
        : double.parse(json['a:ln']['_w']);

    String shape = json['a:prstGeom']['_prst'];

    switch (shape) {
      case 'line':
        return ConnectionNode(offset, size, weight, ShapeGeometry.line);
      default:
        print('Invalid shape to parse: $shape');
        return PrsNode();
    }
  }

  PrsNode _parseTextBox(Map<String, dynamic> json) {
    TextBoxNode node = TextBoxNode();

    node.children.add(_parseGeometry(json['p:spPr']));
    node.children.add(_parseTextBody(json['p:txBody']));

    return node;
  }

  PrsNode _parseTextBody(Map<String, dynamic> json) {
    TextBodyNode node = TextBodyNode();

    node.wrap = json['a:bodyPr']?['_wrap'];
    var pObj = json['a:p'];
    if (pObj is List) {
      pObj.forEach((pNode) {
        node.children.add(_parseTextPara(pNode));
      });
    } else if (pObj is Map<String, dynamic>) {
      node.children.add(_parseTextPara(pObj));
    }

    return node;
  }

  PrsNode _parseTextPara(Map<String, dynamic> json) {
    TextParagraphNode node = TextParagraphNode();

    node.alignment = json['a:pPr']?['align'];
    var rObj = json['a:r'];
    if (rObj is List) {
      rObj.forEach((rNode) {
        node.children.add(_parseText(rNode));
      });
    } else if (rObj is Map<String, dynamic>) {
      node.children.add(_parseText(rObj));
    }

    return node;
  }

  PrsNode _parseText(Map<String, dynamic> json) {
    TextNode node = TextNode();

    // Hyperlinks comes here
    // node.hyperlink = (json['a:rPr']['a:hlinkClick'] == null) ? null : json['a:rPr']['a:hlinkClick']['_r:id'];
    node.italics = (json['a:rPr']['_i'] == '1') ? true : false;
    node.bold = (json['a:rPr']['_b'] == '1') ? true : false;
    node.underline = (json['a:rPr']['_u'] == 'sng' ? true : false);
    String? sizeStr = json['a:rPr']['_sz'];
    node.size = sizeStr != null ? int.parse(sizeStr) : null;
    node.color = json['a:rPr']['a:solidFill']?['a:schemeClr']?['_val'];
    node.highlightColor = json['a:rPr']['a:highlight']?['a:srgbClr']?['_val'];
    node.language = json['a:rPr']['_lang'];
    node.text = json['a:t'];

    return node;
  }

  Future<PrsNode> toPrsNode() async {
    PresentationParser parser = PresentationParser(_file);
    return parser._parsePresentation();
  }

  Future<Map<String, dynamic>> toMap() async {
    PrsNode prsTree = await toPrsNode();
    return prsTree.toJson();
  }

  Future<File> toJSON(String outputPath) async {
    Map<String, dynamic> astJson = await toMap();
    String jsonString = jsonEncode(astJson);
    File outputFile = File(outputPath);
    await outputFile.writeAsString(jsonString);
    return outputFile;
  }
}
