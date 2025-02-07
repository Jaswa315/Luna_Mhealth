import 'package:luna_core/validator/validation_issue.dart';

abstract class Point2DIssue extends ValidationIssue {}

class Point2DXLessThanZero extends Point2DIssue {
  @override
  String get issueCode => 'point2DXPercentageLessThanZero';
}

class Point2DXGreaterThanOne extends Point2DIssue {
  @override
  String get issueCode => 'point2DXPercentageGreaterThanOne';
}

class Point2DYLessThanZero extends Point2DIssue {
  @override
  String get issueCode => 'point2DYPercentageLessThanZero';
}

class Point2DYGreaterThanOne extends Point2DIssue {
  @override
  String get issueCode => 'point2DYPercentageGreaterThanOne';
}
