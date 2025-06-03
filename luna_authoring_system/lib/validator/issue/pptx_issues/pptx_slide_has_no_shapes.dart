import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/validator/issue/pptx_issues/i_pptx_validation_issues.dart';

class PptxSlideHasNoShapes extends IPptxValidationIssues {
  String toText() {
    return 'pptx_slide_has_no_shapes';
  }

  final Slide slide;
  PptxSlideHasNoShapes(this.slide);

  @override
  Shape? get shape => null;

  @override
  Severity get severity => Severity.warning;
}
