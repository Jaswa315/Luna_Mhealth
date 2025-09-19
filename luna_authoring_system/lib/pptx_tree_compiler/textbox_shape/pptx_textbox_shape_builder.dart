import 'package:flutter/widgets.dart' hide Transform;
import 'package:luna_authoring_system/helper/color_conversions.dart';
import 'package:luna_authoring_system/pptx_data_objects/alpha.dart';
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/srgb_color.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbody.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbox_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_base_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout/pptx_slide_layout_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_master/pptx_slide_master_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/textbox_shape/pptx_textbox_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_core/utils/types.dart';

/// This class builds TextboxShape objects
/// that represent text boxes in a PowerPoint file.
class PptxTextboxShapeBuilder extends PptxBaseShapeBuilder<TextboxShape> {
  final PptxTransformBuilder _pptxTransformBuilder;
  final PptxRelationshipParser _relationshipParser;
  final PptxSlideLayoutParser _pptxSlideLayoutParser;
  final PptxSlideMasterParser _pptxSlideMasterParser;

  late int _slideIndex;
  late PptxHierarchy _hierarchy;
  late int _placeholderIndex;
  late String _textStyle;

  PptxTextboxShapeBuilder(this._pptxTransformBuilder, this._relationshipParser, this._pptxSlideLayoutParser, this._pptxSlideMasterParser);

  set slideIndex(int value) => _slideIndex = value;
  set hierarchy(PptxHierarchy value) => _hierarchy = value;

  /// Builds a TextboxShape object from the provided textbox shape map.
  @override
  TextboxShape buildShape(Json textboxShapeMap) {
    _setPlaceholderIndex(textboxShapeMap);
    _setTextStyle(textboxShapeMap);

    late Transform transform;
    if (textboxShapeMap[eShapeProperty].isNotEmpty) {
      transform = _getTransform(textboxShapeMap[eShapeProperty][eTransform]);
    } else { // get transform from its corresponding placeholder shape from corresponding parent
      if (_hierarchy.parent?.xmlKey == eSlideLayout) {
        transform = _getTransformFromSlideLayout(textboxShapeMap);
      }
    }

    List<Paragraph> paragraphs = _getParagraphs(textboxShapeMap[eTextBody][eP]);

    Textbody textbody = Textbody(
      paragraphs: paragraphs,
    );

    return TextboxShape(
      transform: transform,
      textbody: textbody,
    );
  }

  Transform _getTransform(Json transformMap) {
    return _pptxTransformBuilder.getTransform(transformMap);
  }

  Json _getPlaceholderShape() {
    int parentIndex = _relationshipParser.getParentIndex(_slideIndex, _hierarchy);

    return _pptxSlideLayoutParser.getPlaceholderShape(parentIndex, _placeholderIndex, eTextboxShape);
  }

  int _getSlideMasterIndex() {
    if (_hierarchy.xmlKey == eSlideMaster) {
      return _slideIndex;
    } else if (_hierarchy.xmlKey == eSlideLayout) {
      return _relationshipParser.getParentIndex(_slideIndex, _hierarchy);
    }
    int parentSlideLayoutIndex = _relationshipParser.getParentIndex(_slideIndex, _hierarchy);
    int slideMasterIndex = _relationshipParser.getParentIndex(parentSlideLayoutIndex, _hierarchy.parent!);
    return slideMasterIndex;
  }

  PptxSimpleTypeTextFontSize _getFontSizeFromSlideMaster(String textStyle) {
    int slideMasterIndex = _getSlideMasterIndex();
    return PptxSimpleTypeTextFontSize(_pptxSlideMasterParser.getFontSizeFromSlideMaster(slideMasterIndex, textStyle));
  }

  /// Gets the font size from the parent slide layout placeholder shape
  PptxSimpleTypeTextFontSize _getFontSizeFromSlideLayout() {
    Json placeholderShape = _getPlaceholderShape();
    if (placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr].isEmpty) {
      return _getFontSizeFromSlideMaster(_textStyle);
    }

    return PptxSimpleTypeTextFontSize(int.parse(placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr][eSz]));
  }

  /// Gets the bold property from the parent slide layout placeholder shape
  bool _getBoldFromSlideLayout() {
    Json placeholderShape = _getPlaceholderShape();
    if (placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr].isEmpty) {
      return false;
    }

    return placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr][eB]?.toString() == "1";
  }

  /// Gets the italics property from the parent slide layout placeholder shape
  bool _getItalicsFromSlideLayout() {
    Json placeholderShape = _getPlaceholderShape();
    if (placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr].isEmpty) {
      return false;
    }

    return placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr][eI]?.toString() == "1";
  }

  SimpleTypeTextUnderlineType _getTextUnderlineTypeFromSlideLayout() {
    Json placeholderShape = _getPlaceholderShape();
    if (placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr].isEmpty) {
      return SimpleTypeTextUnderlineType.none;
    }
    String underlineValue = placeholderShape[eTextBody][eLstStyle][eLvl1pPr][eDefRPr][eU]?.toString() ?? 'none';

    return SimpleTypeTextUnderlineType.fromXml(underlineValue);
  }

  /// Builds a Run object from the provided run map.
  Run _getRun(Json runMap) {
    String lang = runMap[eRPr][eLang] ?? '';
    List<String> codes = lang.split('-');
    Locale languageID = Locale(codes[0], codes[1]);

    return Run(
      languageID: languageID,
      text: runMap[eT] == '' ? ' ' : runMap[eT],
      fontSize: _getFontSize(runMap),
      bold: _getBold(runMap),
      italics: _getItalic(runMap),
      underlineType: _getUnderlineType(runMap),
      color: _getFontColor(runMap)
    );
  }

  Color _getFontColor(Json runMap) {
    SrgbColor color = SrgbColor(runMap[eRPr][eSolidFill]?[eSrgbColor]
            ?[eValue] ??
        SrgbColor.defaultColor);
    Alpha alpha =
        Alpha(int.parse(runMap[eRPr][eSolidFill]?[eSrgbColor][eAlpha] ?? "${Alpha.maxAlpha}"));
    Color fontColor =
        ColorConversions.updateSrgbColorAndAlphaToFlutterColor(color, alpha);

    return fontColor;
  }

  SimpleTypeTextUnderlineType _getUnderlineType(Json runMap) {
    SimpleTypeTextUnderlineType underlineType;
    if(_placeholderIndex != initialPLaceholderIndex && runMap[eRPr][eU] == null) {
      underlineType = _getTextUnderlineTypeFromSlideLayout();
    } else {
      String underlineValue = runMap[eRPr][eU]?.toString() ?? 'none';
      underlineType = SimpleTypeTextUnderlineType.fromXml(underlineValue);
    }
    return underlineType;
  }

  bool _getItalic(Json runMap) {
    bool isItalic;
    if(_placeholderIndex != initialPLaceholderIndex && runMap[eRPr][eI] == null) {
      isItalic = _getItalicsFromSlideLayout();
    } else {
      isItalic = runMap[eRPr][eI]?.toString() == "1";
    }
    return isItalic;
  }

  PptxSimpleTypeTextFontSize _getFontSize(Json runMap) {
    if (_placeholderIndex != initialPLaceholderIndex && runMap[eRPr][eSz] == null) {
      return _getFontSizeFromSlideLayout();
    } else {
      if (runMap[eRPr][eSz] == null) {
        return _getFontSizeFromSlideMaster(_textStyle);
      } else {
        return PptxSimpleTypeTextFontSize(int.parse(runMap[eRPr][eSz]));
      }
    }
  }

  bool _getBold(Json runMap) {
    bool isBold;
    if(_placeholderIndex != initialPLaceholderIndex && runMap[eRPr][eB] == null) {
      isBold = _getBoldFromSlideLayout();
    } else {
      isBold = runMap[eRPr][eB]?.toString() == "1";
    }
    return isBold;
  }

  /// Extracts runs from the provided run map and returns a list of Run objects.
  List<Run> _getRuns(dynamic runMap) {
    List<Run> runs = [];

    if (runMap is List) {
      for (Json run in runMap) {
        runs.add(_getRun(run));
      }
    } else if (runMap is Map) {
      runs.add(_getRun(runMap as Json));
    }

    return runs;
  }

  /// Builds a Paragraph object from the provided paragraph map.
  Paragraph _getParagraph(Map<dynamic, dynamic> paragraphMap) {
    // If the paragraph map does not contain the 'eR' key, return an empty Paragraph.
    if (paragraphMap[eR] == null) {
      return Paragraph(runs: []);
    }
    List<Run> runs = _getRuns(paragraphMap[eR]);

    return Paragraph(
      runs: runs,
    );
  }

  /// Extracts paragraphs from the provided paragraph map and returns a list of Paragraph objects.
  List<Paragraph> _getParagraphs(dynamic paragraphMap) {
    List<Paragraph> paragraphs = [];
    if (paragraphMap is List) {
      for (var paragraph in paragraphMap) {
        if (paragraph is Map) {
          paragraphs.add(_getParagraph(paragraph));
        }
      }
    } else if (paragraphMap is Map) {
      paragraphs.add(_getParagraph(paragraphMap as Json));
    }

    return paragraphs;
  }

  /// Gets transform from corresponding parent slide layout placeholder
  Transform _getTransformFromSlideLayout(Json shapeMap) {
    Json placeholderShape = _getPlaceholderShape();

    return _getTransform(placeholderShape[eShapeProperty][eTransform]);
  }

  void _setPlaceholderIndex(Json shapeMap) {
    if (shapeMap[eNvSpPr][eNvPr].isNotEmpty) {
      if (shapeMap[eNvSpPr][eNvPr][ePlaceholder] != null) {
        _placeholderIndex = int.parse(shapeMap[eNvSpPr][eNvPr][ePlaceholder][eIdx] ?? initialPLaceholderIndex.toString());
      } else {
        _placeholderIndex = initialPLaceholderIndex;
      }
    } else {
      _placeholderIndex = initialPLaceholderIndex;
    }
  }

  void _setTextStyle(Json shapeMap) {
    if (shapeMap[eNvSpPr][eCNvPr][eName].contains(placeholder)) {
      _textStyle = body;
    } else {
      _textStyle = other;
    }
  }
}