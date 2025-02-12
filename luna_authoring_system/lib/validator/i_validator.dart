import 'package:luna_authoring_system/validator/validation_issue.dart';

abstract class IValidator {
  Set<ValidationIssue> validate();
}
