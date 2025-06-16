import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/luna_constants.dart';

class DummyIssue implements IValidationIssue {
  String toText() => "issue";
  ValidationSeverity get severity => ValidationSeverity.warning;
  @override
  bool ignore;
  DummyIssue({this.ignore = false});
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

    test('updates ignore to true and notifies listeners', () {
      bool notified = false;
      store.addListener(() => notified = true);

      store.addIssue(issue1);
      store.toggleIgnore(issue1, true);

      expect(issue1.ignore, true);
      expect(notified, isTrue);
    });

    test('updates ignore to false and notifies listeners', () {
      final issue = DummyIssue(ignore: true);
      bool notified = false;
      store.addListener(() => notified = true);

      store.addIssue(issue);
      store.toggleIgnore(issue, false);

      expect(issue.ignore, false);
      expect(notified, isTrue);
    });

    test('does nothing if issue not found', () {
      bool notified = false;
      store.addListener(() => notified = true);
      store.addIssue(issue1);
      store.toggleIgnore(issue2, true);

      expect(issue1.ignore, false);
      expect(
          notified, isTrue); // Listener will be called for addIssue for issue1
    });
  });
}
