// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

/// CategoryGameEditorParser parses specific slides that follows Luna Category Game Editor Slide.
const String keyPicture = 'p:pic';
const String keyShape = 'p:sp';
const String keyLunaCategoryContainer = '{luna_category_container}';
const String keyLunaCategoryTitleAndImage =
    '{luna_category_container_title_and_image}';

class CategoryGameEditorParser {
  static const String keyLunaCategoryTheme = "category_game";

  List<Map<String, dynamic>> categoryContainerTransform = [];
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

    /// Clean transform data made from previous parsing
    categoryContainerTransform = [];

    _parseTransformFromSlideLayout(slideLayoutMap);

    CategoryGameEditorNode node = CategoryGameEditorNode();
    var shapeTree = slideMap['p:sld']['p:cSld']['p:spTree'];
    node.slideId = slideIdList[slideIndex - 1];

    // anything that is not in the category is stored in the additional CategoryNode
    for (int i = 0; i < categoryContainerTransform.length + 1; i++) {
      node.children.add(CategoryNode());
    }

    shapeTree.forEach((key, value) {
      switch (key) {
        case keyPicture:
          var picObj = shapeTree[key];
          if (picObj is List) {
            for (var obj in picObj) {
              var element = _parseCategoryGameImage(obj);
              _addImageToCategoryContainer(node, element);
            }
          } else if (picObj is Map<String, dynamic>) {
            var element = _parseCategoryGameImage(picObj);
            _addImageToCategoryContainer(node, element);
          }
          break;
        case keyShape:
          var shapeObj = shapeTree[key];
          if (shapeObj is List) {
            for (var obj in shapeObj) {
              var element = _parseCategoryGameTextBox(obj);
              _addTextToCategoryContainer(node, element);
            }
          } else if (shapeObj is Map<String, dynamic>) {
            var element = _parseCategoryGameTextBox(shapeObj);
            _addTextToCategoryContainer(node, element);
          }
          break;
      }
    });
    return node;
  }

  void _addImageToCategoryContainer(CategoryGameEditorNode node, var element) {
    CategoryGameImageNode imageNode = element as CategoryGameImageNode;
    Transform imageTransform = imageNode.transform as Transform;
    int categories = categoryContainerTransform.length;
    int i;

    for (i = 0; i < categories; i++) {
      Transform categoryContainer =
          categoryContainerTransform[i][keyLunaCategoryContainer];
      Transform categoryTitleAndImageContainer =
          categoryContainerTransform[i][keyLunaCategoryTitleAndImage];

      if (_isInTheBoundary(categoryTitleAndImageContainer, imageTransform)) {
        (node.children[i] as CategoryNode).categoryImage = imageNode;
        break;
      } else if (_isInTheBoundary(categoryContainer, imageTransform)) {
        node.children[i].children.add(imageNode);
        break;
      }
    }

    // anything that is not in the category is stored in the additional CategoryNode
    if (i == categories) {
      node.children[categories].children.add(imageNode);
    }
  }

  void _addTextToCategoryContainer(CategoryGameEditorNode node, var element) {
    CategoryGameTextNode textNode = element as CategoryGameTextNode;
    Transform textTransform = textNode.transform as Transform;
    int categories = categoryContainerTransform.length;
    int i;

    for (i = 0; i < categories; i++) {
      Transform categoryTitleAndImageContainer =
          categoryContainerTransform[i][keyLunaCategoryTitleAndImage];

      if (_isInTheBoundary(categoryTitleAndImageContainer, textTransform)) {
        (node.children[i] as CategoryNode).categoryName = textNode;
        break;
      }
    }

    // anything that is not in the category is stored in the additional CategoryNode
    if (i == categories) {
      node.children[categories].children.add(textNode);
    }
  }

  bool _isInTheBoundary(Transform container, Transform element) {
    var x = element.offset.x + (0.5) * element.size.x;
    var y = element.offset.y + (0.5) * element.size.y;
    var lowerX = container.offset.x;
    var lowerY = container.offset.y;
    var upperX = container.offset.x + container.size.x;
    var upperY = container.offset.y + container.size.y;

    if (lowerX <= x && x <= upperX && lowerY <= y && y <= upperY) {
      return true;
    }
    return false;
  }

  /// Parse Slide Layout to get transform information in the slide layout.
  /// These data are used later to dertermine which element is in which category.
  /// Store transform for each Container, Image, and Text placeholder.
  void _parseTransformFromSlideLayout(Map<String, dynamic> json) {
    var slideLayoutShapeTree =
        json['p:sldLayout']['p:cSld']['p:spTree'][keyShape];
    int currentCategory = 0;

    for (var element in slideLayoutShapeTree) {
      // Store Category box transform
      var descr = element['p:nvSpPr']?['p:cNvPr']?['_descr'];
      switch (descr) {
        case keyLunaCategoryContainer:
          categoryContainerTransform.add(
              {keyLunaCategoryContainer: _parseCategoryTransform(element)});
          break;
        case keyLunaCategoryTitleAndImage:
          categoryContainerTransform[currentCategory]
              [keyLunaCategoryTitleAndImage] = _parseCategoryTransform(element);
          currentCategory += 1;
          break;
      }

      // Store placeholder transform
      Map<String, dynamic> result = {};
      var ph = element['p:nvSpPr']?['p:nvPr']?['p:ph'];
      var spPr = element['p:spPr'];

      if (ph?['_idx'] != null &&
          spPr.containsKey('a:xfrm') &&
          (ph?['_type'] == null ||
              ['body', 'title', 'subTitle', 'pic'].contains(ph['_type']))) {
        result[ph['_idx']] = _parseCategoryTransform(element);
      }
      placeholderToTransform.addAll(result);
    }
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
    node.transform = _parseCategoryTransform(json);

    return node;
  }

  PrsNode _parseCategoryGameImage(Map<String, dynamic> json) {
    CategoryGameImageNode node = CategoryGameImageNode();

    node.altText = json['p:nvPicPr']['p:cNvPr']['_descr'];
    String relsLink = json['p:blipFill']['a:blip']['_r:embed'];
    node.path = slideRelationship?[relsLink];
    node.transform = _parseCategoryTransform(json);

    return node;
  }

  PrsNode _parseCategoryTransform(Map<String, dynamic> json) {
    var nvPr = json['p:nvPicPr']?['p:nvPr'] ??
        json['p:nvSpPr']?['p:nvPr'] ??
        json['p:nvCxnPr']?['p:nvPr'];

    if (nvPr.isNotEmpty) {
      String? phIdx = nvPr['p:ph']?['_idx'];
      if (phIdx != null && placeholderToTransform.containsKey(phIdx)) {
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
}
