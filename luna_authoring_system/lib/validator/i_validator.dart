/// An abstract base class for all validators.
/// Validators return a set of Validation Issues.
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

abstract class IValidator {
  Set<IValidationIssue> validate();
}
