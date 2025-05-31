import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';

/// The [ValidatorRunner] class is responsible for executing the validation logic
/// and adding any issues found to the [ValidationIssuesStore].
class ValidatorRunner {
  final IValidator _validator;

  /// Accepts an [IValidator] via dependency injection.
  ValidatorRunner(this._validator);

  void runValidators(ValidationIssuesStore store) {
    final Set<IValidationIssue> issues = _validator.validate();

    for (final issue in issues) {
      // Add each validation issue to the store.
      store.addIssue(issue);
    }
  }
}
