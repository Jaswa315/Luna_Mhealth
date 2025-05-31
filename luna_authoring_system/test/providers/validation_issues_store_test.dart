import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';

class DummyIssue implements IValidationIssue {
  String toText() => "issue";
  int get severity => 0;
}

void main() {
  group('ValidationIssuesStore', () {
    late ValidationIssuesStore store;
    late DummyIssue issue1;
    late DummyIssue issue2;

    setUp(() {
      store = ValidationIssuesStore();
      issue1 = DummyIssue();
      issue2 = DummyIssue();
    });

    test('initial store is empty', () {
      bool notified = false;
      store.addListener(() {
        notified = true;
      });

      expect(store.issues, isEmpty);
      expect(store.hasIssues, isFalse);
      expect(notified, isFalse);
    });

    test('addIssue adds an issue and notifies listeners', () {
      bool notified = false;
      store.addListener(() {
        notified = true;
      });

      store.addIssue(issue1);

      expect(store.issues.length, 1);
      expect(store.issues.first, issue1);
      expect(store.hasIssues, isTrue);
      expect(notified, isTrue);
    });

    test('clear removes all issues and notifies listeners', () {
      store.addIssue(issue1);
      store.addIssue(issue2);

      bool notified = false;
      store.addListener(() {
        notified = true;
      });

      store.clear();

      expect(store.issues, isEmpty);
      expect(store.hasIssues, isFalse);
      expect(notified, isTrue);
    });
  });
}
