import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/picture_shape/pptx_picture_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/textbox_shape/pptx_textbox_shape_builder.dart';
import 'package:luna_core/utils/types.dart';

/// This class is responsible for building shapes from the PPTX shape tree.
class PptxShapeBuilder {
  final PptxConnectionShapeBuilder _pptxConnectionShapeBuilder;
  final PptxPictureShapeBuilder _pptxPictureShapeBuilder;
  final PptxTextboxShapeBuilder _pptxTextboxShapeBuilder;

  PptxShapeBuilder(
    this._pptxConnectionShapeBuilder,
    this._pptxPictureShapeBuilder,
    this._pptxTextboxShapeBuilder,
  );

  /// Parses the shape tree and returns a list of shapes.
  List<Shape> getShapes(Json shapeTree, int slideIndex, PptxHierarchy hierarchy) {
    List<Shape> shapes = [];

    shapeTree.forEach((key, value) {
      switch (key) {
        case eConnectionShape:
          shapes.addAll(
            _pptxConnectionShapeBuilder.getShapes(shapeTree[key]),
          );
          break;
        case ePictureShape:
          _pptxPictureShapeBuilder.slideIndex = slideIndex;
          _pptxPictureShapeBuilder.hierarchy = hierarchy;
          shapes.addAll(
            _pptxPictureShapeBuilder.getShapes(shapeTree[key]),
          );
          break;
        case eTextboxShape:
          _pptxTextboxShapeBuilder.slideIndex = slideIndex;
          _pptxTextboxShapeBuilder.hierarchy = hierarchy;

          // Preprocess: Filter out placeholders from master/layout
          final filteredShapeTree = _filterMasterLayoutPlaceholders(
            shapeTree[key], 
            currentHierarchy: hierarchy,
          );
          shapes.addAll(
            _pptxTextboxShapeBuilder.getShapes(filteredShapeTree),
          );
          break;
      }
    });

    return shapes;
  }

  dynamic _filterMasterLayoutPlaceholders(
    dynamic shapeTree, {
    required PptxHierarchy currentHierarchy,
  }) {
    // Skip filtering entirely if we're in slide hierarchy
    if (currentHierarchy == PptxHierarchy.slide) return shapeTree;

    // Only apply filtering to slideMaster/slideLayout
    if (shapeTree is List) {
      return shapeTree.where((shape) => !_isPlaceholder(shape)).toList();
    } else if (shapeTree is Map) {
      return _isPlaceholder(shapeTree) ? null : shapeTree;
    }

    return shapeTree;
  }

  bool _isPlaceholder(dynamic shapeJson) {
    return shapeJson?[eNvSpPr]?[eNvPr]?[ePlaceholder] != null;
  }
}
