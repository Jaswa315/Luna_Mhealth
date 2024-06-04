import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:pptx_parser/utils/parser_tools.dart';

const String keyPicture = 'p:pic';
const String keyShape = 'p:sp';

const String keyLunaCategoryContainer = 'luna_category_container';
const String keyLunaCategoryPicture = 'luna_category_picture';

class CategoryGameEditorParser {
  static List<dynamic> categoryContainerTransform = [];
  static List<dynamic> categoryImageTransform = [];
  late Map<String, dynamic> slideMap;
  late var slideIdList;
  int slideIndex;
  Map<String, dynamic>? slideRelationship;
  Map<String, dynamic> placeholderToTransform;

  CategoryGameEditorParser(this.slideMap, this.slideIdList, this.slideIndex,
      this.slideRelationship, this.placeholderToTransform);

  PrsNode parseCategoryGameEditor() {
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

    if (placeholderToTransform.isNotEmpty &&
        ParserTools.getNullableValue(nvPr, ['p:ph']) != null) {
      // this shape follows slideLayout
      String phIdx = nvPr['p:ph']['_idx'];
      return placeholderToTransform[phIdx];
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
}
