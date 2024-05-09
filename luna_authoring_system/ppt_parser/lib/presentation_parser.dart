// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:archive/archive.dart';
import 'package:path/path.dart';
import 'presentation_tree.dart';
import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'package:uuid/uuid.dart';

// From MS-PPTX Documentation
const String keyPicture = 'p:pic';
const String keyShape = 'p:sp';
const String keyConnectionShape = 'p:cxnSp';
const String keySlideLayoutSchema =
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout";

class PresentationParser {
  // removed static so the localization_test and parser_test work
  late final File _file;
  static const uuidGenerator = Uuid();
  // for audio and hyperlink
  Map<String, dynamic>? slideRelationship;
  int? slideIndex;
  int? slideCount;
  // for slides made upon a slideLayout
  Map<String, dynamic>? placeholderToPosition;

  PresentationParser(File file) {
    _file = file;
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

  void _processDynamicCollection(
      dynamic input, void Function(Map<String, dynamic> para) mapping) {
    if (input is List) {
      for (var element in input) {
        mapping(element);
      }
    } else if (input is Map<String, dynamic>) {
      mapping(input);
    }
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
    slideCount = node.slideCount;

    slideWidth =
        double.parse(presentationMap['p:presentation']['p:sldSz']['_cx']);
    slideHeight =
        double.parse(presentationMap['p:presentation']['p:sldSz']['_cy']);

    var slideIdList =
        presentationMap['p:presentation']['p:sldIdLst']['p:sldId'];
    List<String> parserdSlideIdList = [];
    _processDynamicCollection(slideIdList, (para) {
      parserdSlideIdList.add('S${para["_id"]}');
    });

    if (presentationMap['p:presentation']['p:extLst'] == null ||
        presentationMap['p:presentation']['p:extLst']['p:ext']
            is Map<String, dynamic> ||
        presentationMap['p:presentation']['p:extLst']['p:ext'][0]
                ['p14:sectionLst'] ==
            null) {
      node.section = {
        PresentationNode.defaultSection: List<String>.generate(
            node.slideCount, (index) => parserdSlideIdList[index])
      };
    } else {
      node.section = _parseSection(
          presentationMap['p:presentation']['p:extLst']['p:ext'][0]
              ['p14:sectionLst']['p14:section'],
          parserdSlideIdList);
    }

    for (int i = 1; i <= node.slideCount; i++) {
      slideIndex = i;
      slideRelationship = _parseSlideRels(i);
      PrsNode slide = _parseSlide(parserdSlideIdList);
      node.children.add(slide);
      placeholderToPosition = null;
    }

    return node;
  }

  Map<String, dynamic> _parseSlideRels(int slideNum) {
    var relsMap = jsonFromArchive("ppt/slides/_rels/slide$slideNum.xml.rels");
    var rIdList = relsMap['Relationships']['Relationship'];
    Map<String, dynamic> rIdToTarget = {};

    _processDynamicCollection(rIdList, (para) {
      rIdToTarget[para['_Id']] = para['_Target'];
      if (para['_Type'] == keySlideLayoutSchema) {
        RegExp regex = RegExp(r"(?<=slideLayout)\d+(?=.xml)");
        placeholderToPosition = _parseSlideLayout(
            int.parse(regex.firstMatch(para['_Target'])?.group(0) ?? "1"));
      }
    });

    return rIdToTarget;
  }

  Map<String, dynamic> _parseSlideLayout(int slideIndex) {
    // TODO: Branch if it's a Category Game Editor
    Map<String, dynamic> phToP = {};
    var slideLayoutMap =
        jsonFromArchive("ppt/slideLayouts/slideLayout$slideIndex.xml");
    var shapeTree = slideLayoutMap['p:sldLayout']['p:cSld']['p:spTree'];

    shapeTree.forEach((key, value) {
      if (key == keyShape) {
        _processDynamicCollection(shapeTree[key], (para) {
          var ph = para['p:nvSpPr']?['p:nvPr']?['p:ph'];
          var spPr = para['p:spPr'];
          if (ph != null &&
              ph.containsKey('_idx') &&
              (spPr != "" && spPr['a:xfrm'] != null) &&
              (ph['_type'] == null ||
                  ['body', 'title', 'subTitle', 'pic'].contains(ph['_type']))) {
            phToP[ph['_idx']] = _parsePosition(para);
          }
        });
      }
    });
    return phToP;
  }

  Map<String, dynamic> _parseSection(List<dynamic> json, List slideIdKeys) {
    Map<String, dynamic> sectionWithSlide = {};

    int currentSlideNumber = 0;

    for (var section in json) {
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
    }

    return sectionWithSlide;
  }

  PrsNode _parseSlide(var slideIdList) {
    SlideNode node = SlideNode();

    var slideMap = jsonFromArchive("ppt/slides/slide$slideIndex.xml");

    var shapeTree = slideMap['p:sld']['p:cSld']['p:spTree'];

    node.slideId = slideIdList[slideIndex! - 1];

    shapeTree.forEach((key, value) {
      switch (key) {
        case keyPicture:
          var picList = shapeTree[key];
          _processDynamicCollection(picList, (para) {
            node.children.add(_parseImage(para));
          });
        case keyShape:
          var shapeObj = shapeTree[key];
          _processDynamicCollection(shapeObj, (para) {
            node.children.add(_parseShape(para));
          });
        case keyConnectionShape:
          var connectionShapeObj = shapeTree[key];
          _processDynamicCollection(connectionShapeObj, (para) {
            node.children.add(_parseConnectionShape(para));
          });
      }
    });

    return node;
  }

  PrsNode _parseImage(Map<String, dynamic> json) {
    ImageNode node = ImageNode();

    node.imageName = json['p:nvPicPr']['p:cNvPr']['_name'];
    node.altText = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    String audioRelsLink = "";
    if (json['p:nvPicPr']['p:nvPr'] != "" &&
        json['p:nvPicPr']['p:nvPr']?['a:audioFile'] != null) {
      audioRelsLink = json['p:nvPicPr']['p:nvPr']?['a:audioFile']?['_r:link'];
    }
    node.path = slideRelationship?[relsLink];
    node.audioPath = slideRelationship?[audioRelsLink];
    node.hyperlink =
        _getHyperlink(json['p:nvPicPr']['p:cNvPr']?['a:hlinkClick']);

    node.children.add(_parseVanillaShape(json));

    return node;
  }

  PrsNode _parseShape(Map<String, dynamic> json) {
    // Check if a Textbox has placeholder that follows slidelayout
    if (json['p:nvSpPr']?['p:cNvSpPr'] != "" &&
        json['p:nvSpPr']?['p:cNvSpPr']?['_txBox'] == '1') {
      return _parseTextBox(json);
    }

    if (json['p:nvSpPr']?['p:nvPr'] != "" &&
        ['body', 'title']
            .contains(json['p:nvSpPr']?['p:nvPr']?['p:ph']?['_type'])) {
      return _parseTextBox(json);
    }

    // Vanilla Shape (Ellipse, Rectangle)
    return _parseVanillaShape(json);
  }

  List<Position> _parsePosition(Map<String, dynamic> json) {
    // check if it has own position.
    // if it does not have nvPr, look up in placeholder in slideLayout.

    var nvPr = json['p:nvPicPr']?['p:nvPr'] ??
        json['p:nvSpPr']?['p:nvPr'] ??
        json['p:nvCxnSpPr']?['p:nvPr'];

    if (placeholderToPosition != null &&
        nvPr != "" &&
        nvPr.containsKey('p:ph')) {
      // this shape follows slideLayout
      String phIdx = nvPr['p:ph']['_idx'];
      return placeholderToPosition?[phIdx];
    } else {
      Position offset = Position(
          double.parse(json['p:spPr']['a:xfrm']['a:off']['_x']),
          double.parse(json['p:spPr']['a:xfrm']['a:off']['_y']));

      Position size = Position(
          double.parse(json['p:spPr']['a:xfrm']['a:ext']['_cx']),
          double.parse(json['p:spPr']['a:xfrm']['a:ext']['_cy']));
      return [offset, size];
    }
  }

  PrsNode _parseVanillaShape(Map<String, dynamic> json) {
    List<Position> position = _parsePosition(json);
    String shape =
        json['p:spPr'] == "" ? 'rect' : json['p:spPr']['a:prstGeom']['_prst'];
    String? audioPath = slideRelationship?[json['p:nvSpPr']?['p:cNvPr']
        ?['a:hlinkClick']?['a:snd']?['_r:embed']];

    switch (shape) {
      case 'rect':
        return ShapeNode(
            position[0],
            position[1],
            ShapeGeometry.rectangle,
            audioPath,
            _getHyperlink(json['p:nvSpPr']?['p:cNvPr']?['a:hlinkClick']));
      case 'ellipse':
        return ShapeNode(
            position[0],
            position[1],
            ShapeGeometry.ellipse,
            audioPath,
            _getHyperlink(json['p:nvSpPr']?['p:cNvPr']?['a:hlinkClick']));
      default:
        //change it into logTrace
        print('Invalid shape to parse: $shape');
        return PrsNode();
    }
  }

  PrsNode _parseConnectionShape(Map<String, dynamic> json) {
    List<Position> position = _parsePosition(json);

    double weight =
        json['p:spPr']['a:ln'] == null || json['p:spPr']['a:ln']['_w'] == null
            ? ConnectionNode.defaultHalfLineWidth
            : double.parse(json['p:spPr']['a:ln']['_w']);

    String shape = json['p:spPr']['a:prstGeom']['_prst'];

    switch (shape) {
      case 'line':
        return ConnectionNode(
            position[0], position[1], weight, ShapeGeometry.line);
      default:
        print('Invalid shape to parse: $shape');
        return PrsNode();
    }
  }

  PrsNode _parseTextBox(Map<String, dynamic> json) {
    TextBoxNode node = TextBoxNode();

    String? audioPath = slideRelationship?[json['p:nvSpPr']?['p:cNvPr']
        ?['a:hlinkClick']?['a:snd']?['_r:embed']];
    node.audioPath = audioPath;
    node.hyperlink =
        _getHyperlink(json['p:nvSpPr']?['p:cNvPr']?['a:hlinkClick']);

    node.children.add(_parseVanillaShape(json));
    node.children.add(_parseTextBody(json['p:txBody']));

    return node;
  }

  PrsNode _parseTextBody(Map<String, dynamic> json) {
    TextBodyNode node = TextBodyNode();

    node.wrap = json['a:bodyPr'] == "" ? "rect" : json['a:bodyPr']?['_wrap'];
    var pObj = json['a:p'];
    _processDynamicCollection(pObj, (para) {
      node.children.add(_parseTextPara(para));
    });

    return node;
  }

  PrsNode _parseTextPara(Map<String, dynamic> json) {
    TextParagraphNode node = TextParagraphNode();

    node.alignment = json['a:pPr']?['align'];
    var rObj = json['a:r'];
    _processDynamicCollection(rObj, (para) {
      node.children.add(_parseText(para));
    });

    return node;
  }

  PrsNode _parseText(Map<String, dynamic> json) {
    TextNode node = TextNode();

    node.italics = (json['a:rPr']['_i'] == '1') ? true : false;
    node.bold = (json['a:rPr']['_b'] == '1') ? true : false;
    node.underline = (json['a:rPr']['_u'] == 'sng' ? true : false);
    String? sizeStr = json['a:rPr']['_sz'];
    node.size = sizeStr != null ? int.parse(sizeStr) : null;
    node.color = json['a:rPr']['a:solidFill']?['a:schemeClr']?['_val'];
    node.highlightColor = json['a:rPr']['a:highlight']?['a:srgbClr']?['_val'];
    node.language = json['a:rPr']['_lang'];
    node.text = json['a:t'];
    node.hyperlink = _getHyperlink(json['a:rPr']?['a:hlinkClick']);

    return node;
  }

  int? _getHyperlink(Map<String, dynamic>? json) {
    switch (json?['_action']) {
      case 'ppaction://hlinkshowjump?jump=nextslide':
        // PPTX does nothing for hyperlinks that goes to next slide at the last slide.
        return slideIndex == slideCount ? null : (slideIndex ?? 0) + 1;
      case 'ppaction://hlinkshowjump?jump=previousslide':
        // PPTX does nothing for hyperlinks that goes to previous slide at the first slide.
        return slideIndex == 1 ? null : (slideIndex ?? 0) - 1;
      case "ppaction://hlinkshowjump?jump=firstslide":
        return 1;
      case "ppaction://hlinkshowjump?jump=lastslide":
        return slideCount;
      case 'ppaction://hlinksldjump':
        RegExp regExp = RegExp(r'slide(.*?)\.');
        return int.parse(
            regExp.firstMatch(slideRelationship?[json?['_r:id']])?.group(1) ??
                "1");
      default:
        return null;
    }
  }
}
