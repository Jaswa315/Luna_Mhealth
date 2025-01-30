import 'package:luna_core/validator/validator_error.dart';

abstract class IValidator {
  Set<ValidatorError> validate();
}
