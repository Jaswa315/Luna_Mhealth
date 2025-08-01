import 'package:flutter/widgets.dart' hide Transform;
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbody.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbox_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_base_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout/pptx_slide_layout_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/textbox_shape/pptx_textbox_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_core/utils/types.dart';

/// This class builds TextboxShape objects
/// that represent text boxes in a PowerPoint file.
class PptxTextboxShapeBuilder extends PptxBaseShapeBuilder<TextboxShape> {
  final PptxTransformBuilder _pptxTransformBuilder;
  final PptxRelationshipParser _relationshipParser;
  final PptxSlideLayoutParser _pptxSlideLayoutParser;

  late int _slideIndex;
  late PptxHierarchy _hierarchy;

  PptxTextboxShapeBuilder(this._pptxTransformBuilder, this._relationshipParser, this._pptxSlideLayoutParser);

  set slideIndex(int value) => _slideIndex = value;
  set hierarchy(PptxHierarchy value) => _hierarchy = value;

  Transform _getTransform(Json transformMap) {
    return _pptxTransformBuilder.getTransform(transformMap);
  }

  /// Gets the font size from the parent slide layout placeholder shape
  SimpleTypeTextFontSize _getFontSizeFromSlideLayout(int placeholderIndex) {
    int parentIndex = _relationshipParser.getParentIndex(_slideIndex, _hierarchy);
    Json placeholderShape = _pptxSlideLayoutParser.getPlaceholderShape(
      parentIndex, placeholderIndex, eTextboxShape,
    );

    return SimpleTypeTextFontSize(int.parse(placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr][eSz]));
  }

  bool _getBoldFromSlideLayout(int placeholderIndex) {
    int parentIndex = _relationshipParser.getParentIndex(_slideIndex, _hierarchy);
    Json placeholderShape = _pptxSlideLayoutParser.getPlaceholderShape(
      parentIndex, placeholderIndex, eTextboxShape,
    );

    return placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr][eB]?.toString() == "1";
  }

  /// Builds a Run object from the provided run map.
  Run _getRun(Json runMap, int placeholderIndex) {
    String text = runMap[eT];
    String lang = runMap[eRPr][eLang] ?? '';
    List<String> codes = lang.split('-');
    Locale languageID = Locale(codes[0], codes[1]);
    SimpleTypeTextFontSize fontSize;
    if (runMap[eRPr][eSz] == null) { // if font size is not specified in slide xml, need to parse slide layout
      fontSize = _getFontSizeFromSlideLayout(placeholderIndex);
    } else {
      fontSize = SimpleTypeTextFontSize(int.parse(runMap[eRPr][eSz]));
    }
    bool isBold;
    if(placeholderIndex != -1) {
      isBold = _getBoldFromSlideLayout(placeholderIndex);
    } else {
      isBold = runMap[eRPr][eB]?.toString() == "1";
    }

    return Run(
      languageID: languageID,
      text: text,
      fontSize: fontSize,
      bold: isBold,
    );
  }

  /// Extracts runs from the provided run map and returns a list of Run objects.
  List<Run> _getRuns(dynamic runMap, int placeholderIndex) {
    List<Run> runs = [];

    if (runMap is List) {
      for (Json run in runMap) {
        runs.add(_getRun(run, placeholderIndex));
      }
    } else if (runMap is Map) {
      runs.add(_getRun(runMap as Json, placeholderIndex));
    }

    return runs;
  }

  /// Builds a Paragraph object from the provided paragraph map.
  Paragraph _getParagraph(Map<dynamic, dynamic> paragraphMap, int placeholderIndex) {
    // If the paragraph map does not contain the 'eR' key, return an empty Paragraph.
    if (paragraphMap[eR] == null) {
      return Paragraph(runs: []);
    }
    List<Run> runs = _getRuns(paragraphMap[eR], placeholderIndex);

    return Paragraph(
      runs: runs,
    );
  }

  /// Extracts paragraphs from the provided paragraph map and returns a list of Paragraph objects.
  List<Paragraph> _getParagraphs(dynamic paragraphMap, int placeholderIndex) {
    List<Paragraph> paragraphs = [];
    if (paragraphMap is List) {
      for (var paragraph in paragraphMap) {
        if (paragraph is Map) {
          paragraphs.add(_getParagraph(paragraph, placeholderIndex));
        }
      }
    } else if (paragraphMap is Map) {
      paragraphs.add(_getParagraph(paragraphMap as Json, placeholderIndex));
    }

    return paragraphs;
  }

  /// Gets transform from corresponding parent slide layout placeholder
  Transform _getTransformFromSlideLayout(Json shapeMap) {
    int parentIndex = _relationshipParser.getParentIndex(_slideIndex, _hierarchy);
    int placeholderIndex = int.parse(shapeMap[eNvSpPr][eNvPr][ePlaceholder][eIdx]);
    Json placeholderShape = _pptxSlideLayoutParser.getPlaceholderShape(
      parentIndex, placeholderIndex, eTextboxShape,);

    return _getTransform(placeholderShape[eShapeProperty][eTransform]);
  }

  /// Builds a TextboxShape object from the provided textbox shape map.
  @override
  TextboxShape buildShape(Json textboxShapeMap) {
    late Transform transform;
    if (textboxShapeMap[eShapeProperty].isNotEmpty) {
      transform = _getTransform(textboxShapeMap[eShapeProperty][eTransform]);
    } else { // get transform from its corresponding placeholder shape from corresponding parent
      if (_hierarchy.parent?.xmlKey == eSlideLayout) {
        transform = _getTransformFromSlideLayout(textboxShapeMap);
      } else {
        /// TODO: handle this case properly, need to get transform from slide master placeholder shape
        throw UnimplementedError("Getting transform from slide master placeholder shape is not implemented yet.");
      }
    }

    int placeholderIndex = -1;
    if (textboxShapeMap[eNvSpPr][eNvPr][ePlaceholder] != null) {
      placeholderIndex = int.parse(textboxShapeMap[eNvSpPr][eNvPr][ePlaceholder][eIdx]);
    }

    List<Paragraph> paragraphs = _getParagraphs(textboxShapeMap[eTextBody][eP], placeholderIndex);

    Textbody textbody = Textbody(
      paragraphs: paragraphs,
    );

    return TextboxShape(
      transform: transform,
      textbody: textbody,
    );
  }
}