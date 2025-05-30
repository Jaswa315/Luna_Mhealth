import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';

class ValidatorRunner {
  final IValidator validator;

  /// Accepts an [IValidator] via dependency injection.
  ValidatorRunner(this.validator);

  void runValidators(ValidationIssuesStore store) {
    final Set<IValidationIssue> issues = validator.validate();

    for (final issue in issues) {
      // Add each validation issue to the store.
      store.addIssue(issue);
    }
  }
}
