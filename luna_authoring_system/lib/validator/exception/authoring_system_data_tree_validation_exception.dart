/// An AuthoringSystemDataTreeValidationException is thrown if an error input is found during a validation check 
/// on the authoring system side when the input PPTX is being validated.
class AuthoringSystemDataTreeValidationException implements Exception {
  final String message;

  AuthoringSystemDataTreeValidationException(this.message);

  @override
  String toString() => "AuthoringSystemDataTreeValidationException: $message";
}
