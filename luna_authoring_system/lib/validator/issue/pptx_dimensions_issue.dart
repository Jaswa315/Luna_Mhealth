import 'package:luna_core/validator/validation_issue.dart';

abstract class PPTXDimensionsIssue extends ValidationIssue {}

class PPTXWidthAndHeightMustBothBeInitialized extends PPTXDimensionsIssue {
  @override
  String get issueCode => 'pptx_width_and_height_must_both_be_initialized';
}

class PPTXWidthMustBePositive extends PPTXDimensionsIssue {
  @override
  String get issueCode => 'pptx_width_must_be_positive';
}

class PPTXHeightMustBePositive extends PPTXDimensionsIssue {
  @override
  String get issueCode => 'pptx_height_must_be_positive';
}
