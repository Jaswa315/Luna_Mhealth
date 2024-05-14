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

// From MS-PPTX Documentation
const String keyPicture = 'p:pic';
const String keyShape = 'p:sp';
const String keyConnectionShape = 'p:cxnSp';
const String keySlideLayoutSchema =
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout";
const String keyLunaCategoryContainer = 'luna_category_container';
const String keyLunaCategoryPicture = 'luna_category_picture';

class PresentationParser {
  // removed static so the localization_test and parser_test work
  late final File _file;
  static const uuidGenerator = Uuid();
  // for audio and hyperlink
  Map<String, dynamic>? slideRelationship;
  int? slideIndex;
  int? slideCount;
  // for slides made upon a slideLayout
  Map<String, dynamic>? placeholderToTransform;
  List<dynamic> categoryContainerTransform = [];
  List<dynamic> categoryImageTransform = [];

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

  dynamic _getNullableValue(dynamic map, List<String> keys) {
    dynamic value = map;
    for (var key in keys) {
      if (value == null || value == "") {
        return null;
      }
      value = value[key];
    }

    return (value == null || value == "") ? null : value;
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
    List<String> parsedSlideIdList = [];
    _processDynamicCollection(slideIdList, (para) {
      parsedSlideIdList.add('S${para["_id"]}');
    });

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
      slideRelationship = _parseSlideRels(i);
      PrsNode slide = categoryContainerTransform.isEmpty
          ? _parseSlide(parsedSlideIdList)
          : _parseCategoryGameEditor(parsedSlideIdList);
      node.children.add(slide);
      placeholderToTransform = null;
      categoryContainerTransform = [];
      categoryImageTransform = [];
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
        placeholderToTransform = _parseSlideLayout(
            int.parse(regex.firstMatch(para['_Target'])?.group(0) ?? "1"));
      }
    });

    return rIdToTarget;
  }

  Map<String, dynamic> _parseSlideLayout(int slideIndex) {
    Map<String, dynamic> phToP = {};
    var slideLayoutMap =
        jsonFromArchive("ppt/slideLayouts/slideLayout$slideIndex.xml");
    var shapeTree = slideLayoutMap['p:sldLayout']['p:cSld']['p:spTree'];

    shapeTree.forEach((key, value) {
      if (key == keyShape) {
        _processDynamicCollection(shapeTree[key], (para) {
          var descr =
              _getNullableValue(para, ['p:nvSpPr', 'p:cNvPr', '_descr']);
          switch (descr) {
            case keyLunaCategoryContainer:
              categoryContainerTransform.add(_parseTransform(para));
              break;
            case keyLunaCategoryPicture:
              categoryImageTransform.add(_parseTransform(para));
          }

          var ph = _getNullableValue(para, ['p:nvSpPr', 'p:nvPr', 'p:ph']);
          var spPr = para['p:spPr'];
          if (ph != null &&
              ph.containsKey('_idx') &&
              (_getNullableValue(spPr, ['a:xfrm']) != null) &&
              (ph['_type'] == null ||
                  ['body', 'title', 'subTitle', 'pic'].contains(ph['_type']))) {
            phToP[ph['_idx']] = _parseTransform(para);
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

      var sectionData =
          _getNullableValue(section, ['p14:sldIdLst', 'p14:sldId']);

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

  PrsNode _parseCategoryGameEditor(var slideIdList) {
    CategoryGameEditorNode node = CategoryGameEditorNode();
    var slideMap = jsonFromArchive("ppt/slides/slide$slideIndex.xml");
    var shapeTree = slideMap['p:sld']['p:cSld']['p:spTree'];
    node.slideId = slideIdList[slideIndex! - 1];

    for (int i = 0; i < categoryContainerTransform.length; i++) {
      node.children.add(CategoryNode());
    }

    shapeTree.forEach((key, value) {
      switch (key) {
        case keyPicture:
          var picList = shapeTree[key];
          _processDynamicCollection(picList, (para) {
            var element = _parseImage(para);
            ShapeNode? shapeElement = element.children[0] as ShapeNode;
            int? index = _addToCategory(element);
            categoryImageTransform.any((item) =>
                    item.offset.x == shapeElement.transform.offset.x &&
                    item.offset.y == shapeElement.transform.offset.y &&
                    item.size.x == shapeElement.transform.size.x &&
                    item.size.y == shapeElement.transform.size.y)
                ? (node.children[index ?? 0] as CategoryNode).categoryImage =
                    element as ImageNode
                : node.children[index ?? 0].children.add(element);
          });
        case keyShape:
          var shapeObj = shapeTree[key];
          _processDynamicCollection(shapeObj, (para) {
            var element = _parseShape(para);
            (node.children[_addToCategory(element) ?? 0] as CategoryNode)
                .categoryName = element as ShapeNode;
          });
      }
    });

    return node;
  }

  int? _addToCategory(var element) {
    ShapeNode shapeElement =
        element is ShapeNode ? element : element.children[0] as ShapeNode;

    var centerX =
        shapeElement.transform.offset.x + shapeElement.transform.size.x / 2;
    var centerY =
        shapeElement.transform.offset.y + shapeElement.transform.size.y / 2;

    for (int i = 0; i < categoryContainerTransform.length; i++) {
      if (categoryContainerTransform[i].offset.x <= centerX &&
          centerX <=
              categoryContainerTransform[i].offset.x +
                  categoryContainerTransform[i].size.x &&
          categoryContainerTransform[i].offset.y <= centerY &&
          centerY <=
              categoryContainerTransform[i].offset.y +
                  categoryContainerTransform[i].size.y) {
        return i;
      }
    }
    return null;
  }

  PrsNode _parseImage(Map<String, dynamic> json) {
    ImageNode node = ImageNode();

    node.imageName = json['p:nvPicPr']['p:cNvPr']['_name'];
    node.altText = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    String audioRelsLink = "";
    audioRelsLink = _getNullableValue(
            json['p:nvPicPr'], ['p:nvPr', 'a:audioFile', '_r:link']) ??
        "";
    node.path = slideRelationship?[relsLink];
    node.audioPath = slideRelationship?[audioRelsLink];
    node.hyperlink = _getHyperlink(
        _getNullableValue(json['p:nvPicPr'], ['p:cNvPr', 'a:hlinkClick']));

    node.children.add(_parseBasicShape(json));

    return node;
  }

  PrsNode _parseShape(Map<String, dynamic> json) {
    if (_getNullableValue(json, ['p:nvSpPr', 'p:cNvSpPr', '_txBox']) == '1') {
      return _parseTextBox(json);
    }

    // Check if a Textbox has placeholder that follows slidelayout
    if (['body', 'title'].contains(
        _getNullableValue(json, ['p:nvSpPr', 'p:nvPr', 'p:ph' '_type']))) {
      return _parseTextBox(json);
    }

    // Basic Shape (Ellipse, Rectangle)
    return _parseBasicShape(json);
  }

  Transform _parseTransform(Map<String, dynamic> json) {
    // check if it has own transform.
    // if it does not have nvPr, look up in placeholder in slideLayout.

    var nvPr = _getNullableValue(json, ['p:nvPicPr', 'p:nvPr']) ??
        _getNullableValue(json, ['p:nvSpPr', 'p:nvPr']) ??
        _getNullableValue(json, ['p:nvCxnPr', 'p:nvPr']);

    if (placeholderToTransform != null &&
        _getNullableValue(nvPr, ['p:ph']) != null) {
      // this shape follows slideLayout
      String phIdx = nvPr['p:ph']['_idx'];
      return placeholderToTransform?[phIdx];
    } else {
      Transform node = Transform();
      node.offset = Point2D(
          double.parse(json['p:spPr']['a:xfrm']['a:off']['_x']),
          double.parse(json['p:spPr']['a:xfrm']['a:off']['_y']));

      node.size = Point2D(
          double.parse(json['p:spPr']['a:xfrm']['a:ext']['_cx']),
          double.parse(json['p:spPr']['a:xfrm']['a:ext']['_cy']));
      return node;
    }
  }

  PrsNode _parseBasicShape(Map<String, dynamic> json) {
    String shape = _getNullableValue(json, ['p:spPr']) == null
        ? 'rect'
        : json['p:spPr']['a:prstGeom']['_prst'];

    ShapeNode node = ShapeNode();

    node.transform = _parseTransform(json);

    node.audioPath = slideRelationship?[_getNullableValue(
        json, ['p:nvSpPr', 'p:cNvPr', 'a:hlinkClick', 'a:snd', '_r:embed'])];

    if (_getNullableValue(json, ['p:txBody']) != null) {
      node.children.add(_parseTextBody(json['p:txBody']));
    }

    node.hyperlink = _getHyperlink(
        _getNullableValue(json, ['p:nvSpPr', 'p:cNvPr', 'a:hlinkClick']));

    switch (shape) {
      case 'rect':
        node.shape = ShapeGeometry.rectangle;
        return node;
      case 'ellipse':
        node.shape = ShapeGeometry.ellipse;
        return node;
      default:
        //change it into logTrace
        print('Invalid shape to parse: $shape');
        return PrsNode();
    }
  }

  PrsNode _parseConnectionShape(Map<String, dynamic> json) {
    Transform transform = _parseTransform(json);

    double weight =
        json['p:spPr']['a:ln'] == null || json['p:spPr']['a:ln']['_w'] == null
            ? ConnectionNode.defaultHalfLineWidth
            : double.parse(json['p:spPr']['a:ln']['_w']);

    String shape = json['p:spPr']['a:prstGeom']['_prst'];

    switch (shape) {
      case 'line':
        return ConnectionNode(transform, weight, ShapeGeometry.line);
      default:
        print('Invalid shape to parse: $shape');
        return PrsNode();
    }
  }

  PrsNode _parseTextBox(Map<String, dynamic> json) {
    TextBoxNode node = TextBoxNode();

    node.audioPath = slideRelationship?[_getNullableValue(
        json, ['p:nvSpPr', 'p:cNvPr', 'a:hlinkClick', 'a:snd', '_r:embed'])];
    node.hyperlink = _getHyperlink(
        _getNullableValue(json, ['p:nvSpPr', 'p:cNvPr', 'a:hlinkClick']));

    node.children.add(_parseBasicShape(json));
    node.children.add(_parseTextBody(json['p:txBody']));

    return node;
  }

  PrsNode _parseTextBody(Map<String, dynamic> json) {
    TextBodyNode node = TextBodyNode();

    node.wrap = _getNullableValue(json, ['a:bodyPr']) == null
        ? "rect"
        : _getNullableValue(json, ['a:bodyPr', '_wrap']);
    var pObj = json['a:p'];
    _processDynamicCollection(pObj, (para) {
      node.children.add(_parseTextPara(para));
    });

    return node;
  }

  PrsNode _parseTextPara(Map<String, dynamic> json) {
    TextParagraphNode node = TextParagraphNode();

    node.alignment = _getNullableValue(json, ['a:pPr', 'align']);
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
    node.color = _getNullableValue(
        json['a:rPr'], ['a:solidFill', 'a:schemeClr', '_val']);
    node.highlightColor =
        _getNullableValue(json['a:rPr'], ['a:highlight', 'a:srgbClr', '_val']);
    node.language = json['a:rPr']['_lang'];
    node.text = json['a:t'];
    node.hyperlink =
        _getHyperlink(_getNullableValue(json, ['a:rPr', 'a:hlinkClick']));

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
