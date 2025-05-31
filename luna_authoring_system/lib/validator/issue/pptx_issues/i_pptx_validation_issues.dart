import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

abstract class IPptxValidationIssues extends IValidationIssue {
  Slide get slide;
  Shape? get shape;
}
