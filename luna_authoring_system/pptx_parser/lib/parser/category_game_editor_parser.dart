import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:pptx_parser/parser/presentation_parser.dart';

const String keyPicture = 'p:pic';
const String keyShape = 'p:sp';

const String keyLunaCategoryContainer = 'luna_category_container';
const String keyLunaCategoryPicture = 'luna_category_picture';

class CategoryGameEditorParser {
  List<dynamic> categoryContainerTransform = [];
  List<dynamic> categoryImageTransform = [];
  late Map<String, dynamic> slideMap;
  late var slideIdList;
  int slideIndex;
  Map<String, dynamic>? slideRelationship;

  CategoryGameEditorParser(
      this.slideMap, this.slideIdList, this.slideIndex, this.slideRelationship);

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
              ShapeNode? shapeElement = element.children[0] as ShapeNode;
              int? index = _addToCategory(element);
              categoryImageTransform.any((item) =>
                      item.offset.x == shapeElement.transform.offset.x &&
                      item.offset.y == shapeElement.transform.offset.y &&
                      item.size.x == shapeElement.transform.size.x &&
                      item.size.y == shapeElement.transform.size.y)
                  ? (node.children[index ?? 0] as CategoryNode).categoryImage =
                      element as CategoryGameImageNode
                  : node.children[index ?? 0].children.add(element);
            }
          } else if (picObj is Map<String, dynamic>) {
            var element = _parseCategoryGameImage(picObj);
            ShapeNode? shapeElement = element.children[0] as ShapeNode;
            int? index = _addToCategory(element);
            categoryImageTransform.any((item) =>
                    item.offset.x == shapeElement.transform.offset.x &&
                    item.offset.y == shapeElement.transform.offset.y &&
                    item.size.x == shapeElement.transform.size.x &&
                    item.size.y == shapeElement.transform.size.y)
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
    ShapeNode shapeElement = element.children[0] is ShapeNode
        ? element.children[0]
        : element.children[0].children[0] as ShapeNode;

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
    
    // node.children.add(parseShape(json));

    return node;
  }

  PrsNode _parseCategoryGameImage(Map<String, dynamic> json) {
    CategoryGameImageNode node = CategoryGameImageNode();

    node.altText = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    node.path = slideRelationship?[relsLink];
    // node.children.add(parseBasicShape(json));

    return node;
  }

  PrsNode _parseCategoryTransform(Map<String, dynamic> json){
    var nvPr = _getNullableValue(json, ['p:nvPicPr', 'p:nvPr']) ??
        _getNullableValue(json, ['p:nvSpPr', 'p:nvPr']) ??
        _getNullableValue(json, ['p:nvCxnPr', 'p:nvPr']);
  }
}
