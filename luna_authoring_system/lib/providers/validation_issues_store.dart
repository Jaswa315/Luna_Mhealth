import 'package:flutter/foundation.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// Responsible for managing the state of validation issues, allows adding issues, clearing them, and notifying listeners about changes.
class ValidationIssuesStore extends ChangeNotifier {
  final List<IValidationIssue> _issues = [];

  List<IValidationIssue> get issues => List.unmodifiable(_issues);

  void addIssue(IValidationIssue issue) {
    _issues.add(issue);
    notifyListeners();
  }

  void clear() {
    _issues.clear();
    notifyListeners();
  }

  /// Toggles the ignore state of a specific validation issue
  void toggleIgnore(IValidationIssue target, bool value) {
    final index = _issues.indexWhere((issue) => identical(issue, target));
    if (index != -1) {
      _issues[index].ignore = value;
      notifyListeners();
    }
  }

  bool get hasIssues => _issues.isNotEmpty;
}
