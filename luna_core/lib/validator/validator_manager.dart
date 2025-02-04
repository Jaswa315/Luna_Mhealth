import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';

class ValidatorManager {
  final List<IValidator> _validators = [];

  void addValidator(IValidator validator) {
    _validators.add(validator);
  }

  Set<ValidatorError> validateAll() {
    Set<ValidatorError> allErrors = {};
    for (var validator in _validators) {
      allErrors.addAll(validator.validate());
    }
    
    return allErrors;
  }
}