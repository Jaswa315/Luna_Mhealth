import 'package:luna_core/validator/validation_issue.dart';

abstract class IValidator {
  Set<ValidationIssue> validate();
}
