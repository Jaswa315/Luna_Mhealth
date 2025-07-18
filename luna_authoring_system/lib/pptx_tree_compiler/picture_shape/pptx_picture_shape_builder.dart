import 'package:luna_authoring_system/pptx_data_objects/picture_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_percentage.dart';
import 'package:luna_authoring_system/pptx_data_objects/source_rectangle.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/picture_shape/pptx_picture_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_base_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_core/utils/types.dart';

/// This class is responsible for building PictureShape objects from the PowerPoint XML structure.
class PptxPictureShapeBuilder extends PptxBaseShapeBuilder<PictureShape> {
  late final PptxTransformBuilder _transformBuilder;
  late final PptxRelationshipParser _relationshipParser;
  late int _slideIndex;
  late PptxHierarchy _hierarchy;

  PptxPictureShapeBuilder(this._transformBuilder, this._relationshipParser);

  set slideIndex(int value) => _slideIndex = value;
  set hierarchy(PptxHierarchy value) => _hierarchy = value;

  /// Parses the transform map and returns a Transform object.
  Transform _getTransform(Json transformMap) {
    return _transformBuilder.getTransform(transformMap);
  }

  /// Extracts the URL from the provided map using the relationship parser.
  String _getUrl(Json urlMap) {
    return _relationshipParser.findTargetByRId(
      _slideIndex,
      _hierarchy,
      urlMap[eEmbed],
    );
  }

  /// Extracts the source rectangle from the provided map.
  SourceRectangle _getSourceRectangle(Json? sourceRectangleMap) {
    int parseOrDefault(dynamic value) {
      if (value == null) {
        return SourceRectangle.defaultValue;
      } else if (value == "") {
        return SourceRectangle.defaultValue;
      } else if (value is String && value.isNotEmpty) {
        return int.parse(value);
      } else {
        throw ArgumentError(
          "Invalid value for source rectangle: $value",
        );
      }
    }

    return SourceRectangle(
      left: SimpleTypePercentage(
        parseOrDefault(sourceRectangleMap?[eSourceRectangleLeft]),
      ),
      top: SimpleTypePercentage(
        parseOrDefault(sourceRectangleMap?[eSourceRectangleTop]),
      ),
      right: SimpleTypePercentage(
        parseOrDefault(sourceRectangleMap?[eSourceRectangleRight]),
      ),
      bottom: SimpleTypePercentage(
        parseOrDefault(sourceRectangleMap?[eSourceRectangleBottom]),
      ),
    );
  }

  /// Builds a PictureShape object from the provided picture shape map.
  @override
  PictureShape buildShape(Json pictureShapeMap) {
    Transform transform =
        _getTransform(pictureShapeMap[eShapeProperty][eTransform]);
    String url = _getUrl(pictureShapeMap[eBlipFill][eBlip]);
    SourceRectangle sourceRectangle;
    if (pictureShapeMap[eBlipFill]?[eSourceRectangle] == null ||
        pictureShapeMap[eBlipFill]?[eSourceRectangle] == "") {
      sourceRectangle = SourceRectangle();
    } else {
      sourceRectangle =
          _getSourceRectangle(pictureShapeMap[eBlipFill]?[eSourceRectangle]);
    }

    return PictureShape(
      transform: transform,
      url: url,
      sourceRectangle: sourceRectangle,
    );
  }
}
