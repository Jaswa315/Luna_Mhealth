import 'package:flutter/foundation.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// This class [ValidationIssuesStore] is responsible for managing the state of validation issues.
/// Allows adding issues, clearing them, and notifying listeners about changes.
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

  bool get hasIssues => _issues.isNotEmpty;
}
