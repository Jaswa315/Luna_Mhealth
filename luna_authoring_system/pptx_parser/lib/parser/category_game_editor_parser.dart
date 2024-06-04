import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:pptx_parser/utils/parser_tools.dart';

/// CategoryGameEditorParser parses specific slides that follows Luna Category Game Editor Slide.
const String keyPicture = 'p:pic';
const String keyShape = 'p:sp';
const String keyLunaCategoryContainer = 'luna_category_container';
const String keyLunaCategoryPicture = 'luna_category_picture';
const String keyLunaCategoryTitle = 'luna_category_title';

class CategoryGameEditorParser {
  static const List<String> keyLunaCategorySlideLayout = [
    '2_category',
    '3_category',
    '4_category',
    '5_category',
    '6_category'
  ];

  static List<dynamic> categoryContainerTransform = [];
  static List<dynamic> categoryImageTransform = [];
  static List<dynamic> categoryTextTransform = [];

  Map<String, dynamic>? slideRelationship = {};
  Map<String, dynamic> placeholderToTransform = {};

  CategoryGameEditorParser();

  PrsNode parseCategoryGameEditor(
      Map<String, dynamic> slideMap,
      Map<String, dynamic> slideLayoutMap,
      var slideIdList,
      int slideIndex,
      Map<String, dynamic>? slideRelationship) {
    this.slideRelationship = slideRelationship;

    _parseTransformFromSlideLayout(slideLayoutMap);

    CategoryGameEditorNode node = CategoryGameEditorNode();
    var shapeTree = slideMap['p:sld']['p:cSld']['p:spTree'];
    node.slideId = slideIdList[slideIndex - 1];

    for (int i = 0; i < categoryContainerTransform.length; i++) {
      node.children.add(CategoryNode());
    }

    shapeTree.forEach((key, value) {
      switch (key) {
        case keyPicture:
          var picObj = shapeTree[key];

          if (picObj is List) {
            for (var obj in picObj) {
              var element = _parseCategoryGameImage(obj);
              Transform? shapeElement = element.children[0] as Transform;
              int? index = _addToCategory(element);
              categoryImageTransform.any((item) =>
                      item.offset.x == shapeElement.offset.x &&
                      item.offset.y == shapeElement.offset.y &&
                      item.size.x == shapeElement.size.x &&
                      item.size.y == shapeElement.size.y)
                  ? (node.children[index ?? 0] as CategoryNode).categoryImage =
                      element as CategoryGameImageNode
                  : node.children[index ?? 0].children.add(element);
            }
          } else if (picObj is Map<String, dynamic>) {
            var element = _parseCategoryGameImage(picObj);
            Transform? shapeElement = element.children[0] as Transform;
            int? index = _addToCategory(element);
            categoryImageTransform.any((item) =>
                    item.offset.x == shapeElement.offset.x &&
                    item.offset.y == shapeElement.offset.y &&
                    item.size.x == shapeElement.size.x &&
                    item.size.y == shapeElement.size.y)
                ? (node.children[index ?? 0] as CategoryNode).categoryImage =
                    element as CategoryGameImageNode
                : node.children[index ?? 0].children.add(element);
          }
          break;
        case keyShape:
          var shapeObj = shapeTree[key];
          if (shapeObj is List) {
            for (var obj in shapeObj) {
              var element = _parseCategoryGameTextBox(obj);
              (node.children[_addToCategory(element) ?? 0] as CategoryNode)
                  .categoryName = element as CategoryGameTextNode;
            }
          } else if (shapeObj is Map<String, dynamic>) {
            var element = _parseCategoryGameTextBox(shapeObj);
            (node.children[_addToCategory(element) ?? 0] as CategoryNode)
                .categoryName = element as CategoryGameTextNode;
          }
          break;
      }
    });

    return node;
  }

  /// Parse Slide Layout to get transform information in the slide layout.
  /// These data are used later to dertermine which element is in which category.
  /// Store transform for each Container, Image, and Text placeholder.
  void _parseTransformFromSlideLayout(Map<String, dynamic> json) {
    var shapeTree = json['p:sldLayout']['p:cSld']['p:spTree'];

    shapeTree.forEach((key, value) {
      if (key == keyShape) {
        if (shapeTree[key] is List) {
          for (var element in shapeTree[key]) {
            var descr = ParserTools.getNullableValue(
                element, ['p:nvSpPr', 'p:cNvPr', '_descr']);
            switch (descr) {
              case keyLunaCategoryContainer:
                CategoryGameEditorParser.categoryContainerTransform
                    .add(_parseCategoryTransform(element));
                break;
              case keyLunaCategoryPicture:
                CategoryGameEditorParser.categoryImageTransform
                    .add(_parseCategoryTransform(element));
                break;
              case keyLunaCategoryTitle:
                CategoryGameEditorParser.categoryTextTransform
                    .add(_parseCategoryTransform(element));
            }

            Map<String, dynamic> result = {};

            var ph = ParserTools.getNullableValue(
                element, ['p:nvSpPr', 'p:nvPr', 'p:ph']);
            var spPr = element['p:spPr'];
            if (ph != null &&
                ph.containsKey('_idx') &&
                (ParserTools.getNullableValue(spPr, ['a:xfrm']) != null) &&
                (ph['_type'] == null ||
                    ['body', 'title', 'subTitle', 'pic']
                        .contains(ph['_type']))) {
              result[ph['_idx']] = _parseCategoryTransform(element);
            }
            placeholderToTransform.addAll(result);
          }
        } else if (shapeTree[key] is Map<String, dynamic>) {
          var descr = ParserTools.getNullableValue(
              shapeTree, ['p:nvSpPr', 'p:cNvPr', '_descr']);
          switch (descr) {
            case keyLunaCategoryContainer:
              CategoryGameEditorParser.categoryContainerTransform
                  .add(_parseCategoryTransform(shapeTree[key]));
              break;
            case keyLunaCategoryPicture:
              CategoryGameEditorParser.categoryImageTransform
                  .add(_parseCategoryTransform(shapeTree[key]));
              break;
            case keyLunaCategoryTitle:
              CategoryGameEditorParser.categoryTextTransform
                  .add(_parseCategoryTransform(shapeTree[key]));
          }
          Map<String, dynamic> result = {};

          var ph = ParserTools.getNullableValue(
              shapeTree[key], ['p:nvSpPr', 'p:nvPr', 'p:ph']);
          var spPr = shapeTree[key]['p:spPr'];
          if (ph != null &&
              ph.containsKey('_idx') &&
              (ParserTools.getNullableValue(spPr, ['a:xfrm']) != null) &&
              (ph['_type'] == null ||
                  ['body', 'title', 'subTitle', 'pic'].contains(ph['_type']))) {
            result[ph['_idx']] = _parseCategoryTransform(shapeTree[key]);
          }
          placeholderToTransform.addAll(result);
        }
      }
    });
  }

  /// Determine which given element is in which category.
  int? _addToCategory(var element) {
    // element is either Image or TextBox
    Transform shapeElement = element.children[0];

    var centerX = shapeElement.offset.x + shapeElement.size.x / 2;
    var centerY = shapeElement.offset.y + shapeElement.size.y / 2;

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

  PrsNode _parseCategoryGameTextBox(Map<String, dynamic> json) {
    CategoryGameTextNode node = CategoryGameTextNode();

    String categoryName = "";
    if (json['p:txBody']['a:p'] is List) {
      for (var element in json['p:txBody']['a:p']) {
        categoryName += element['a:r']['a:t'] + " ";
      }
    } else if (json['p:txBody']['a:p'] is Map<String, dynamic>) {
      categoryName += json['p:txBody']['a:p']['a:r']['a:t'] + " ";
    }
    categoryName = categoryName.replaceAll(RegExp(r'\\[tnv]\s*'), ' ');
    node.text = categoryName.substring(0, categoryName.length - 1);
    node.children.add(_parseCategoryTransform(json));

    return node;
  }

  PrsNode _parseCategoryGameImage(Map<String, dynamic> json) {
    CategoryGameImageNode node = CategoryGameImageNode();

    node.altText = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    node.path = slideRelationship?[relsLink];
    node.children.add(_parseCategoryTransform(json));

    return node;
  }

  PrsNode _parseCategoryTransform(Map<String, dynamic> json) {
    var nvPr = ParserTools.getNullableValue(json, ['p:nvPicPr', 'p:nvPr']) ??
        ParserTools.getNullableValue(json, ['p:nvSpPr', 'p:nvPr']) ??
        ParserTools.getNullableValue(json, ['p:nvCxnPr', 'p:nvPr']);

    if (ParserTools.getNullableValue(nvPr, ['p:ph']) != null) {
      String phIdx = nvPr['p:ph']['_idx'];
      if (placeholderToTransform.containsKey(phIdx)) {
        return placeholderToTransform[phIdx];
      }
    }

    Transform node = Transform();
    node.offset = Point2D(double.parse(json['p:spPr']['a:xfrm']['a:off']['_x']),
        double.parse(json['p:spPr']['a:xfrm']['a:off']['_y']));

    node.size = Point2D(double.parse(json['p:spPr']['a:xfrm']['a:ext']['_cx']),
        double.parse(json['p:spPr']['a:xfrm']['a:ext']['_cy']));
    return node;
  }

  /// Clean transform data for further parsing
  static void cleanTransformList() {
    categoryContainerTransform = [];
    categoryImageTransform = [];
    categoryTextTransform = [];
  }
}
