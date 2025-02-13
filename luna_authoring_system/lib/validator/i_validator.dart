import 'package:luna_authoring_system/validator/i_validation_issue.dart';

abstract class IValidator {
  Set<IValidationIssue> validate();
}
