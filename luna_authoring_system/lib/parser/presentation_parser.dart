// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:luna_core/utils/types.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'presentation_tree.dart';

/// From MS-PPTX Documentation
const String keyPicture = 'p:pic';

/// The XML key for a shape element in a PowerPoint presentation.
const String keyShape = 'p:sp';

/// The XML key for a connection shape element in a PowerPoint presentation.
const String keyConnectionShape = 'p:cxnSp';

/// The schema URL for the slide layout relationships in PowerPoint presentations.
const String keySlideLayoutSchema =
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout";

/// The schema URL for the slide master relationships in PowerPoint presentations.
const String keySlideMasterSchema =
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster";

/// The schema URL for theme relationships in PowerPoint presentations.
const String keyThemeSchema =
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme";

// contant value for padding
/// value representing the custom design name for Luna.
const String keyLunaCustomDesign = "Pregnancy Symptoms and Conditions";

/// The placeholder for the Luna top system bar.
const String keyLunaTopSystemBar = "{luna top_system_bar}";

/// The placeholder for the Luna bottom system bar.
const String keyLunaBottomSystemBar = "{luna bottom_system_bar}";

/// The placeholder for the Luna left padding value.
const String keyLunaLeftPadding = "{luna left_padding}";

/// The placeholder for the Luna right padding value.
const String keyLunaRightPadding = "{luna right_padding}";

/// A map representing zero padding values for all sides (left, top, right, bottom).
const Map<String, double> zeroPadding = {
  "left": 0,
  "top": 0,
  "right": 0,
  "bottom": 0
};

/// A parser class for handling PowerPoint presentations.
class PresentationParser {
  // removed static so the localization_test and parser_test work
  late final File _file;

  /// A UUID generator instance for generating unique identifiers.
  static const uuidGenerator = Uuid();

  /// for audio and hyperlink
  Json? slideRelationship;

  /// The index of the current slide being processed.
  int? slideIndex;

  /// The total number of slides in the presentation.
  int? slideCount;
  // for slides made upon a slideLayout
  /// A map that transforms placeholders to corresponding values for slides made upon a slide layout.
  Json placeholderToTransform = {};
  int _nextTextNodeUID = 1;
  ///
  PresentationParser(File file) {
    _file = file;
  }

  /// Parses the PowerPoint presentation and returns a [PrsNode].
  Future<PrsNode> toPrsNode() async {
    PresentationParser parser = PresentationParser(_file);
    return parser._parsePresentation();
  }

  /// Converts the presentation to a map representation.
  Future<Json> toMap() async {
    PrsNode prsTree = await toPrsNode();
    return prsTree.toJson();
  }

  /// Writes the presentation data to a JSON file at the specified [outputPath]
  Future<File> toJSON(String outputPath) async {
    Json astJson = await toMap();
    String jsonString = jsonEncode(astJson);
    File outputFile = File(outputPath);
    await outputFile.writeAsString(jsonString);
    return outputFile;
  }

  /// Extracts a file from a zip archive.
  ArchiveFile extractFileFromZip(String filePath) {
    var bytes = _file.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    return archive.firstWhere((file) => p.equals(file.name, filePath));
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

  /// Converts an XML file from a zip archive to JSON.
  /// [filePath] - Path of the XML file in the archive.
  /// Returns the JSON representation of the extracted XML.
  dynamic jsonFromArchive(String filePath) {
    XmlDocument doc = _extractXMLFromZip(filePath);
    return _xmlDocumentToJson(doc);
  }

  bool _isTextBox(Json json) {
    if (!json.containsKey('p:nvSpPr')) {
      return false;
    }

    // element must have nvPr to have placeholder
    String placeholderType = json['p:nvSpPr']?['p:nvPr'].isNotEmpty
        ? (json['p:nvSpPr']?['p:nvPr']?['p:ph']?['_type'] ?? "")
        : "";

    if (json['p:nvSpPr']['p:cNvSpPr'].isNotEmpty &&
            json['p:nvSpPr']['p:cNvSpPr'].containsKey('_txBox') &&
            json['p:nvSpPr']['p:cNvSpPr']['_txBox'] == '1' ||
        ['body', 'title'].contains(placeholderType)) {
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
    } else if (slideIdList is Json) {
      parsedSlideIdList.add('S${slideIdList["_id"]}');
    }

    if (presentationMap['p:presentation']['p:extLst'] == null ||
        presentationMap['p:presentation']['p:extLst']['p:ext']
            is Json ||
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
      List<dynamic> slideLayoutInfo = _lookAheadTheme(i);
      String? slideLayoutName = slideLayoutInfo[0];
      int? slideMasterIndex = slideLayoutInfo[1];
      PrsNode slide = PrsNode();
      slideRelationship = _parseSlideRels(i);

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

      node.children.add(slide);
      placeholderToTransform = {};
    }

    return node;
  }

  Map<String, double> _parsePadding(Json json) {
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
      var descr = element['p:nvSpPr']?['p:cNvPr']?['_descr'];
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
      var descr = element['p:nvPicPr']?['p:cNvPr']?['_descr'];
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
    dynamic slideLayoutElement;
    if (slideRelationshipElement is List) {
      slideLayoutElement = slideRelationshipElement.firstWhere(
        (element) => element['_Type'] == keySlideLayoutSchema,
        orElse: () => "",
      );
    } else if (slideRelationshipElement is Json) {
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
    dynamic slideMasterElement;
    if (slideLayoutRelationshipElement is List) {
      slideMasterElement = slideLayoutRelationshipElement.firstWhere(
        (element) => element['_Type'] == keySlideMasterSchema,
        orElse: () => "",
      );
    } else if (slideLayoutRelationshipElement is Json) {
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

    return [themeName, slideMasterIndex];
  }

  Json _parseSlideRels(int slideNum) {
    var relsMap = jsonFromArchive("ppt/slides/_rels/slide$slideNum.xml.rels");
    var rIdList = relsMap['Relationships']['Relationship'];

    Json rIdToTarget = {};
    if (rIdList is List) {
      for (var element in rIdList) {
        rIdToTarget[element['_Id']] = element['_Target'];
        if (placeholderToTransform.isEmpty) {
          placeholderToTransform = _parseSlideLayout(element);
        }
      }
    } else if (rIdList is Json) {
      rIdToTarget[rIdList['_Id']] = rIdList['_Target'];
      if (placeholderToTransform.isEmpty) {
        placeholderToTransform = _parseSlideLayout(rIdList);
      }
    }

    return rIdToTarget;
  }

  Json _parseTransformForPlaceholder(
      Json json) {
    Json result = {};

    var ph = json['p:nvSpPr']['p:nvPr']?['p:ph'];
    var spPr = json['p:spPr'].isEmpty ? null : json['p:spPr'];

    if (ph?['_idx'] != null &&
        spPr?['a:xfrm'] != null &&
        (ph?['_type'] == null ||
            ['body', 'title', 'subTitle', 'pic'].contains(ph['_type']))) {
      result[ph['_idx']] = _parseTransform(json);
    }
    return result;
  }

  Json _parseSlideLayout(Json json) {
    Json phToP = {};
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
          } else if (shapeTree[key] is Json) {
            phToP.addAll(_parseTransformForPlaceholder(shapeTree[key]));
          }
        }
      });
    }

    return phToP;
  }

  Json _parseSection(List<dynamic> json, List slideIdKeys) {
    Json sectionWithSlide = {};

    int currentSlideNumber = 0;

    for (var section in json) {
      String currentSection = section['_name'];
      sectionWithSlide[currentSection] = [];

      // if sldIdLst is "", it means it has 0 slides in that section
      // if sldId is Map, it only contains one slide in that section
      // if sldId is List, it has at least 2 slides in that section

      dynamic sectionData;
      if (section['p14:sldIdLst'].isNotEmpty) {
        sectionData = section['p14:sldIdLst']['p14:sldId'];
      }

      if (sectionData != null) {
        if (sectionData is Json) {
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
          } else if (picList is Json) {
            node.children.add(_parseImage(picList));
          }
        case keyShape:
          var shapeObj = shapeTree[key];
          if (shapeObj is List) {
            for (var element in shapeObj) {
              node.children.add(_parseShape(element));
            }
          } else if (shapeObj is Json) {
            node.children.add(_parseShape(shapeObj));
          }
        case keyConnectionShape:
          var connectionShapeObj = shapeTree[key];
          if (connectionShapeObj is List) {
            for (var element in connectionShapeObj) {
              node.children.add(_parseConnectionShape(element));
            }
          } else if (connectionShapeObj is Json) {
            node.children.add(_parseConnectionShape(connectionShapeObj));
          }
      }
    });

    return node;
  }

  PrsNode _parseImage(Json json) {
    ImageNode node = ImageNode();

    node.imageName = json['p:nvPicPr']['p:cNvPr']['_name'];
    node.altText = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    String audioRelsLink = json['p:nvPicPr']['p:nvPr'].isNotEmpty
        ? (json['p:nvPicPr']['p:nvPr']['a:audioFile']?['_r:link'] ?? "")
        : "";

    node.path = slideRelationship?[relsLink];
    node.audioPath = slideRelationship?[audioRelsLink];
    node.hyperlink =
        _getHyperlink(json['p:nvPicPr']?['p:cNvPr']?['a:hlinkClick']);

    // initiated transform
    node.transform = _parseTransform(json) as Transform;

    node.children.add(_parseBasicShape(json));

    return node;
  }

  PrsNode _parseShape(Json json) {
    if (_isTextBox(json)) {
      return _parseTextBox(json);
    }

    // Basic Shape (Ellipse, Rectangle)
    return _parseBasicShape(json);
  }

  PrsNode _parseTransform(Json json) {
    // helper function to get transform data from json
    Transform getTransformData(Json json) {
      Json? xfrm = json['p:spPr']?['a:xfrm'];

      if (xfrm == null) {
        LogManager().logTrace(
            'Invalid transform to parse: ${json['p:spPr']}\n May have a placeholder instead.',
            LunaSeverityLevel.Warning);
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
    var nvPr = json['p:nvPicPr']?['p:nvPr'] ??
        json['p:nvSpPr']?['p:nvPr'] ??
        json['p:nvCxnSpPr']?['p:nvPr'];

    if (placeholderToTransform.isNotEmpty &&
        nvPr.isNotEmpty &&
        nvPr['p:ph'] != null) {
      String? phIdx = nvPr['p:ph']['_idx'];

      if (phIdx != null) {
        // Return existing placeholder transform if available
        if (placeholderToTransform.containsKey(phIdx)) {
          return placeholderToTransform[phIdx]!;
        } else {
          LogManager().logTrace('Invalid placeholder to parse: $phIdx',
              LunaSeverityLevel.Warning);
          var node = getTransformData(json);
          // update placeholder map
          placeholderToTransform[phIdx] = node;
          return node;
        }
      }
    }

    // Return default transform if no placeholder or transform found
    return getTransformData(json);
  }

  PrsNode _parseBasicShape(Json json) {
    String shape = json['p:spPr'].isNotEmpty
        ? (json['p:spPr']?['a:prstGeom']?['_prst'] ?? 'rect')
        : "rect";

    ShapeNode node = ShapeNode();

    if (!_isTextBox(json) && json['p:txBody'] != null) {
      node.textBody = _parseTextBody(json['p:txBody']);
    } else {
      node.textBody = null;
    }

    node.transform = _parseTransform(json);

    node.audioPath = slideRelationship?[json['p:nvSpPr']?['p:cNvPr']
        ?['a:hlinkClick']?['a:snd']?['_r:embed']];

    node.hyperlink =
        _getHyperlink(json['p:nvSpPr']?['p:cNvPr']?['a:hlinkClick']);

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

  PrsNode _parseConnectionShape(Json json) {
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

  PrsNode _parseTextBox(Json json) {
    TextBoxNode node = TextBoxNode();

    node.audioPath = slideRelationship?[json['p:nvSpPr']?['p:cNvPr']
        ?['a:hlinkClick']?['a:snd']?['_r:embed']];
    node.hyperlink =
        _getHyperlink(json['p:nvSpPr']?['p:cNvPr']?['a:hlinkClick']);

    node.children.add(_parseBasicShape(json));
    node.children.add(_parseTextBody(json['p:txBody']));

    return node;
  }

  PrsNode _parseTextBody(Json json) {
    TextBodyNode node = TextBodyNode();

    node.wrap = json['a:bodyPr'].isNotEmpty
        ? (json['a:bodyPr']?['_wrap'] ?? "rect")
        : "rect";

    var pObj = json['a:p'];
    if (pObj is List) {
      for (var element in pObj) {
        node.children.add(_parseTextPara(element));
      }
    } else if (pObj is Json) {
      node.children.add(_parseTextPara(pObj));
    }

    return node;
  }

  PrsNode _parseTextPara(Json json) {
    TextParagraphNode node = TextParagraphNode();

    // TODO: get from defaultTextStyle in presentation.xml
    node.alignment = json['a:pPr']?['_algn'] ?? 'l';

    var rObj = json['a:r'];

    if (rObj is List) {
      for (var element in rObj) {
        node.children.add(_parseText(element));
      }
    } else if (rObj is Json) {
      node.children.add(_parseText(rObj));
    }
    return node;
  }

  PrsNode _parseText(Json json) {
    TextNode node = TextNode();

    node.italics = (json['a:rPr']['_i'] == '1') ? true : false;
    node.bold = (json['a:rPr']['_b'] == '1') ? true : false;
    node.underline = (json['a:rPr']['_u'] == 'sng' ? true : false);
    String? sizeStr = json['a:rPr']['_sz'];
    node.size = sizeStr != null ? int.parse(sizeStr) : null;
    // ToDo: Colors will come from either directly with srgbClr or schemeClr.  Need to map both
    // if schemeClr, need to lookup against correct themeX.xml
    node.color = json['a:rPr']?['a:solidFill']?['a:srgbClr']?['_val'];
    node.highlightColor = json['a:rPr']?['a:highlight']?['a:srgbClr']?['_val'];
    node.language = json['a:rPr']['_lang'];
    node.text = json['a:t'];
    node.hyperlink = _getHyperlink(json['a:rPr']?['a:hlinkClick']);
    node.uid = _nextTextNodeUID++;

    return node;
  }

  int? _getHyperlink(Json? json) {
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
