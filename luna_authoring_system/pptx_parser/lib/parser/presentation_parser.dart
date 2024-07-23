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
import 'package:luna_core/utils/logging.dart';
import 'package:pptx_parser/parser/category_game_editor_parser.dart';
import 'package:pptx_parser/utils/parser_tools.dart';

// From MS-PPTX Documentation
const String keyPicture = 'p:pic';
const String keyShape = 'p:sp';
const String keyConnectionShape = 'p:cxnSp';
const String keySlideLayoutSchema =
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout";
const String keySlideMasterSchema =
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster";
const String keyThemeSchema =
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme";

// contant value for padding
const String keyLunaCustomDesign = "Pregnancy Symptoms and Conditions";
const String keyLunaTopSystemBar = "{luna top_system_bar}";
const String keyLunaBottomSystemBar = "{luna bottom_system_bar}";
const String keyLunaLeftPadding = "{luna left_padding}";
const String keyLunaRightPadding = "{luna right_padding}";
const Map<String, double> zeroPadding = {
  "left": 0,
  "top": 0,
  "right": 0,
  "bottom": 0
};

class PresentationParser {
  // removed static so the localization_test and parser_test work
  late final File _file;
  static const uuidGenerator = Uuid();
  // for audio and hyperlink
  Map<String, dynamic>? slideRelationship;
  int? slideIndex;
  int? slideCount;
  // for slides made upon a slideLayout
  Map<String, dynamic> placeholderToTransform = {};
  int _nextTextNodeUID = 1;

  CategoryGameEditorParser categoryGameEditorParser =
      CategoryGameEditorParser();

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

  ArchiveFile extractFileFromZip(String filePath) {
    var bytes = _file.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    return archive.firstWhere((file) => file.name == filePath);
  }

  XmlDocument _extractXMLFromZip(String xmlFilePath) {
    return XmlDocument.parse(
        utf8.decode(extractFileFromZip(xmlFilePath).content));
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

  bool _isTextBox(Map<String, dynamic> json) {
    if (ParserTools.getNullableValue(
                json, ['p:nvSpPr', 'p:cNvSpPr', '_txBox']) ==
            '1' ||
        ['body', 'title'].contains(ParserTools.getNullableValue(
            json, ['p:nvSpPr', 'p:nvPr', 'p:ph', '_type']))) {
      return true;
    } else {
      return false;
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
    node.moduleID = uuidGenerator.v4();
    slideCount = node.slideCount;

    node.width =
        double.parse(presentationMap['p:presentation']['p:sldSz']['_cx']);
    node.height =
        double.parse(presentationMap['p:presentation']['p:sldSz']['_cy']);

    var slideIdList =
        presentationMap['p:presentation']['p:sldIdLst']['p:sldId'];
    List<String> parsedSlideIdList = [];
    if (slideIdList is List) {
      for (var element in slideIdList) {
        parsedSlideIdList.add('S${element["_id"]}');
      }
    } else if (slideIdList is Map<String, dynamic>) {
      parsedSlideIdList.add('S${slideIdList["_id"]}');
    }

    if (presentationMap['p:presentation']['p:extLst'] == null ||
        presentationMap['p:presentation']['p:extLst']['p:ext']
            is Map<String, dynamic> ||
        presentationMap['p:presentation']['p:extLst']['p:ext'][0]
                ['p14:sectionLst'] ==
            null) {
      node.section = {
        PresentationNode.defaultSection: List<String>.generate(
            node.slideCount, (index) => parsedSlideIdList[index])
      };
    } else {
      node.section = _parseSection(
          presentationMap['p:presentation']['p:extLst']['p:ext'][0]
              ['p14:sectionLst']['p14:section'],
          parsedSlideIdList);
    }

    for (int i = 1; i <= node.slideCount; i++) {
      slideIndex = i;
      // TODO: Separate getting slideLayoutName and slideLayoutIndex
      List<dynamic> slideLayoutInfo = _lookAheadTheme(i);
      String? slideLayoutName = slideLayoutInfo[0];
      int? slideLayoutIndex = slideLayoutInfo[1];
      int? slideMasterIndex = slideLayoutInfo[2];
      PrsNode slide = PrsNode();
      slideRelationship = _parseSlideRels(i);
      if (slideLayoutName == CategoryGameEditorParser.keyLunaCategoryTheme) {
        slide = categoryGameEditorParser.parseCategoryGameEditor(
            jsonFromArchive("ppt/slides/slide$slideIndex.xml"),
            jsonFromArchive(
                "ppt/slideLayouts/slideLayout$slideLayoutIndex.xml"),
            parsedSlideIdList,
            slideIndex!,
            slideRelationship);
      } else {
        slide = _parseSlide(parsedSlideIdList);
        if (slideLayoutName == keyLunaCustomDesign) {
          SlideNode contentSlide = slide as SlideNode;
          Map<String, double> padding = _parsePadding(jsonFromArchive(
              "ppt/slideMasters/slideMaster$slideMasterIndex.xml"));
          contentSlide.padding = padding;
          slide = contentSlide as PrsNode;
        } else {
          SlideNode contentSlide = slide as SlideNode;
          contentSlide.padding = zeroPadding;
          slide = contentSlide as PrsNode;
        }
      }
      node.children.add(slide);
      placeholderToTransform = {};
    }

    return node;
  }

  Map<String, double> _parsePadding(Map<String, dynamic> json) {
    Map<String, double> padding = {
      "left": 0,
      "top": 0,
      "right": 0,
      "bottom": 0
    };
    var slideMasterShapeTree =
        json['p:sldMaster']['p:cSld']['p:spTree'][keyShape];

    for (var element in slideMasterShapeTree) {
      // get the alt text of the shape
      var descr = ParserTools.getNullableValue(
          element, ['p:nvSpPr', 'p:cNvPr', '_descr']);
      switch (descr) {
        case keyLunaLeftPadding:
          padding["left"] =
              double.parse(element['p:spPr']['a:xfrm']['a:ext']['_cx']);
          break;
        case keyLunaRightPadding:
          padding["right"] =
              double.parse(element['p:spPr']['a:xfrm']['a:ext']['_cx']);
          break;
      }
    }
    var slideMasterPicTree =
        json['p:sldMaster']['p:cSld']['p:spTree'][keyPicture];
    for (var element in slideMasterPicTree) {
      // get the alt text of the shape
      var descr = ParserTools.getNullableValue(
          element, ['p:nvPicPr', 'p:cNvPr', '_descr']);
      switch (descr) {
        case keyLunaTopSystemBar:
          padding["top"] =
              double.parse(element['p:spPr']['a:xfrm']['a:ext']['_cy']);
          break;
        case keyLunaBottomSystemBar:
          padding["bottom"] =
              double.parse(element['p:spPr']['a:xfrm']['a:ext']['_cy']);
          break;
      }
    }
    return padding;
  }

  List<dynamic> _lookAheadTheme(int slideNum) {
    // get slide layout index
    var slideRelationshipElement = jsonFromArchive(
            "ppt/slides/_rels/slide$slideNum.xml.rels")['Relationships']
        ['Relationship'];
    var slideLayoutElement;
    if (slideRelationshipElement is List) {
      slideLayoutElement = slideRelationshipElement.firstWhere(
        (element) => element['_Type'] == keySlideLayoutSchema,
        orElse: () => "",
      );
    } else if (slideRelationshipElement is Map<String, dynamic>) {
      slideLayoutElement =
          slideRelationshipElement['_Type'] == keySlideLayoutSchema
              ? slideRelationshipElement
              : "";
    }
    int slideLayoutIndex = int.parse(RegExp(r"(?<=slideLayout)\d+(?=.xml)")
            .firstMatch(slideLayoutElement['_Target'])
            ?.group(0) ??
        "1");

    // get slide master index
    var slideLayoutRelationshipElement = jsonFromArchive(
            "ppt/slideLayouts/_rels/slideLayout$slideLayoutIndex.xml.rels")[
        'Relationships']['Relationship'];
    var slideMasterElement;
    if (slideLayoutRelationshipElement is List) {
      slideMasterElement = slideLayoutRelationshipElement.firstWhere(
        (element) => element['_Type'] == keySlideMasterSchema,
        orElse: () => "",
      );
    } else if (slideLayoutRelationshipElement is Map<String, dynamic>) {
      slideMasterElement =
          slideLayoutRelationshipElement['_Type'] == keySlideMasterSchema
              ? slideLayoutRelationshipElement
              : "";
    }
    int slideMasterIndex = int.parse(RegExp(r"(?<=slideMaster)\d+(?=.xml)")
            .firstMatch(slideMasterElement['_Target'])
            ?.group(0) ??
        "1");

    // get theme index
    List<dynamic> slideMasterRelsList = jsonFromArchive(
            "ppt/slideMasters/_rels/slideMaster$slideMasterIndex.xml.rels")[
        'Relationships']['Relationship'];
    var themeElement = slideMasterRelsList.firstWhere(
        (element) => element['_Type'] == keyThemeSchema,
        orElse: () => "");
    int themeIndex = int.parse(RegExp(r"(?<=theme)\d+(?=.xml)")
            .firstMatch(themeElement['_Target'])
            ?.group(0) ??
        "-1");

    // get Theme name
    String? themeName = themeIndex == -1
        ? ""
        : jsonFromArchive("ppt/theme/theme$themeIndex.xml")['a:theme']['_name'];

    return [themeName, slideLayoutIndex, slideMasterIndex];
  }

  Map<String, dynamic> _parseSlideRels(int slideNum) {
    var relsMap = jsonFromArchive("ppt/slides/_rels/slide$slideNum.xml.rels");
    var rIdList = relsMap['Relationships']['Relationship'];

    Map<String, dynamic> rIdToTarget = {};
    if (rIdList is List) {
      for (var element in rIdList) {
        rIdToTarget[element['_Id']] = element['_Target'];
        if (placeholderToTransform.isEmpty) {
          placeholderToTransform = _parseSlideLayout(element);
        }
      }
    } else if (rIdList is Map<String, dynamic>) {
      rIdToTarget[rIdList['_Id']] = rIdList['_Target'];
      if (placeholderToTransform.isEmpty) {
        placeholderToTransform = _parseSlideLayout(rIdList);
      }
    }

    return rIdToTarget;
  }

  Map<String, dynamic> _parseTransformForPlaceholder(
      Map<String, dynamic> json) {
    Map<String, dynamic> result = {};

    var ph = ParserTools.getNullableValue(json, ['p:nvSpPr', 'p:nvPr', 'p:ph']);
    var spPr = json['p:spPr'];
    if (ph != null &&
        ph.containsKey('_idx') &&
        (ParserTools.getNullableValue(spPr, ['a:xfrm']) != null) &&
        (ph['_type'] == null ||
            ['body', 'title', 'subTitle', 'pic'].contains(ph['_type']))) {
      result[ph['_idx']] = _parseTransform(json);
    }
    return result;
  }

  Map<String, dynamic> _parseSlideLayout(Map<String, dynamic> json) {
    Map<String, dynamic> phToP = {};
    if (json['_Type'] == keySlideLayoutSchema) {
      RegExp regex = RegExp(r"(?<=slideLayout)\d+(?=.xml)");
      int slideIndex =
          int.parse(regex.firstMatch(json['_Target'])?.group(0) ?? "1");

      var slideLayoutMap =
          jsonFromArchive("ppt/slideLayouts/slideLayout$slideIndex.xml");
      var shapeTree = slideLayoutMap['p:sldLayout']['p:cSld']['p:spTree'];

      shapeTree.forEach((key, value) {
        if (key == keyShape) {
          if (shapeTree[key] is List) {
            for (var element in shapeTree[key]) {
              phToP.addAll(_parseTransformForPlaceholder(element));
            }
          } else if (shapeTree[key] is Map<String, dynamic>) {
            phToP.addAll(_parseTransformForPlaceholder(shapeTree[key]));
          }
        }
      });
    }

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

      var sectionData =
          ParserTools.getNullableValue(section, ['p14:sldIdLst', 'p14:sldId']);

      if (sectionData != null) {
        if (sectionData is Map<String, dynamic>) {
          sectionWithSlide[currentSection].add(slideIdKeys[currentSlideNumber]);
          currentSlideNumber += 1;
        } else {
          List slideList = sectionData;
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
          if (picList is List) {
            for (var element in picList) {
              node.children.add(_parseImage(element));
            }
          } else if (picList is Map<String, dynamic>) {
            node.children.add(_parseImage(picList));
          }
        case keyShape:
          var shapeObj = shapeTree[key];
          if (shapeObj is List) {
            for (var element in shapeObj) {
              node.children.add(_parseShape(element));
            }
          } else if (shapeObj is Map<String, dynamic>) {
            node.children.add(_parseShape(shapeObj));
          }
        case keyConnectionShape:
          var connectionShapeObj = shapeTree[key];
          if (connectionShapeObj is List) {
            for (var element in connectionShapeObj) {
              node.children.add(_parseConnectionShape(element));
            }
          } else if (connectionShapeObj is Map<String, dynamic>) {
            node.children.add(_parseConnectionShape(connectionShapeObj));
          }
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
    audioRelsLink = ParserTools.getNullableValue(
            json['p:nvPicPr'], ['p:nvPr', 'a:audioFile', '_r:link']) ??
        "";
    node.path = slideRelationship?[relsLink];
    node.audioPath = slideRelationship?[audioRelsLink];
    node.hyperlink = _getHyperlink(ParserTools.getNullableValue(
        json['p:nvPicPr'], ['p:cNvPr', 'a:hlinkClick']));

    // initiated transform
    node.transform = _parseTransform(json) as Transform;

    node.children.add(_parseBasicShape(json));

    return node;
  }

  PrsNode _parseShape(Map<String, dynamic> json) {
    if (_isTextBox(json)) {
      return _parseTextBox(json);
    }

    // Basic Shape (Ellipse, Rectangle)
    return _parseBasicShape(json);
  }

  PrsNode _parseTransform(Map<String, dynamic> json) {
    // helper function to get transform data from json
    Transform _getTransformData(Map<String, dynamic> json) {
      var xfrm = json['p:spPr']?['a:xfrm'];
      if (xfrm == null) {
        LogManager().logTrace(
            'Invalid transform to parse: ${json['p:spPr']}\n May have a placeholder instead.',
            LunaSeverityLevel.Critical);
        return Transform();
      }
  
      Transform node = Transform();
      node.offset = Point2D(
          double.parse(json['p:spPr']['a:xfrm']['a:off']['_x']),
          double.parse(json['p:spPr']['a:xfrm']['a:off']['_y']));

      node.size = Point2D(
          double.parse(json['p:spPr']['a:xfrm']['a:ext']['_cx']),
          double.parse(json['p:spPr']['a:xfrm']['a:ext']['_cy']));
      return node;
    }

    // Check for transform in placeholder
    var nvPr = ParserTools.getNullableValue(json, ['p:nvPicPr', 'p:nvPr']) ??
        ParserTools.getNullableValue(json, ['p:nvSpPr', 'p:nvPr']) ??
        ParserTools.getNullableValue(json, ['p:nvCxnPr', 'p:nvPr']);

    if (placeholderToTransform.isNotEmpty &&
        ParserTools.getNullableValue(nvPr, ['p:ph']) != null) {
      String? phIdx = nvPr['p:ph']['_idx'];

      if (phIdx != null) {
        // Return existing placeholder transform if available
        if (placeholderToTransform.containsKey(phIdx)) {
          return placeholderToTransform[phIdx]!;
        } else {
          LogManager().logTrace('Invalid placeholder to parse: $phIdx',
              LunaSeverityLevel.Warning);
          var node = _getTransformData(json);
          // update placeholder map
          placeholderToTransform[phIdx] = node;
          return node;
        }
      }
    }

    // Return default transform if no placeholder or transform found
    return _getTransformData(json);
  }

  PrsNode _parseBasicShape(Map<String, dynamic> json) {
    String shape =
        ParserTools.getNullableValue(json, ['p:spPr', 'a:prstGeom', '_prst']) ==
                null
            ? 'rect'
            : json['p:spPr']['a:prstGeom']['_prst'];

    ShapeNode node = ShapeNode();

    node.transform = _parseTransform(json);

    // A Shape can have textBody
    if (!_isTextBox(json) &&
        ParserTools.getNullableValue(json, ['p:txBody']) != null) {
      node.textBody = _parseTextBody(json['p:txBody']);
    } else {
      node.textBody = null;
    }

    node.audioPath = slideRelationship?[ParserTools.getNullableValue(
        json, ['p:nvSpPr', 'p:cNvPr', 'a:hlinkClick', 'a:snd', '_r:embed'])];

    node.hyperlink = _getHyperlink(ParserTools.getNullableValue(
        json, ['p:nvSpPr', 'p:cNvPr', 'a:hlinkClick']));

    switch (shape) {
      case 'rect':
        node.shape = ShapeGeometry.rectangle;
        return node;
      case 'ellipse':
        node.shape = ShapeGeometry.ellipse;
        return node;
      default:
        LogManager().logTrace(
            'Invalid shape to parse: $shape', LunaSeverityLevel.Error);
        return PrsNode();
    }
  }

  PrsNode _parseConnectionShape(Map<String, dynamic> json) {
    Transform transform = _parseTransform(json) as Transform;

    double weight =
        json['p:spPr']['a:ln'] == null || json['p:spPr']['a:ln']['_w'] == null
            ? ConnectionNode.defaultHalfLineWidth
            : double.parse(json['p:spPr']['a:ln']['_w']);

    String shape = json['p:spPr']['a:prstGeom']['_prst'];

    switch (shape) {
      case 'line':
        return ConnectionNode(transform, weight, ShapeGeometry.line);
      default:
        LogManager().logTrace(
            'Invalid shape to parse: $shape', LunaSeverityLevel.Error);
        return PrsNode();
    }
  }

  PrsNode _parseTextBox(Map<String, dynamic> json) {
    TextBoxNode node = TextBoxNode();

    node.audioPath = slideRelationship?[ParserTools.getNullableValue(
        json, ['p:nvSpPr', 'p:cNvPr', 'a:hlinkClick', 'a:snd', '_r:embed'])];
    node.hyperlink = _getHyperlink(ParserTools.getNullableValue(
        json, ['p:nvSpPr', 'p:cNvPr', 'a:hlinkClick']));

    node.children.add(_parseBasicShape(json));
    node.children.add(_parseTextBody(json['p:txBody']));

    return node;
  }

  PrsNode _parseTextBody(Map<String, dynamic> json) {
    TextBodyNode node = TextBodyNode();

    node.wrap = ParserTools.getNullableValue(json, ['a:bodyPr']) == null
        ? "rect"
        : ParserTools.getNullableValue(json, ['a:bodyPr', '_wrap']);
    var pObj = json['a:p'];

    if (pObj is List) {
      for (var element in pObj) {
        node.children.add(_parseTextPara(element));
      }
    } else if (pObj is Map<String, dynamic>) {
      node.children.add(_parseTextPara(pObj));
    }

    return node;
  }

  PrsNode _parseTextPara(Map<String, dynamic> json) {
    TextParagraphNode node = TextParagraphNode();

    node.alignment = ParserTools.getNullableValue(json, ['a:pPr', 'align']);
    var rObj = json['a:r'];

    if (rObj is List) {
      for (var element in rObj) {
        node.children.add(_parseText(element));
      }
    } else if (rObj is Map<String, dynamic>) {
      node.children.add(_parseText(rObj));
    }
    return node;
  }

  PrsNode _parseText(Map<String, dynamic> json) {
    TextNode node = TextNode();

    node.italics = (json['a:rPr']['_i'] == '1') ? true : false;
    node.bold = (json['a:rPr']['_b'] == '1') ? true : false;
    node.underline = (json['a:rPr']['_u'] == 'sng' ? true : false);
    String? sizeStr = json['a:rPr']['_sz'];
    node.size = sizeStr != null ? int.parse(sizeStr) : null;
    // ToDo: Map this to a real color value
    // Some are just showing up as 'accent1' and such.
    node.color = ParserTools.getNullableValue(
        json['a:rPr'], ['a:solidFill', 'a:schemeClr', '_val']);
    node.highlightColor = ParserTools.getNullableValue(
        json['a:rPr'], ['a:highlight', 'a:srgbClr', '_val']);
    node.language = json['a:rPr']['_lang'];
    node.text = json['a:t'];
    node.hyperlink = _getHyperlink(
        ParserTools.getNullableValue(json, ['a:rPr', 'a:hlinkClick']));
    node.uid = _nextTextNodeUID++;

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
