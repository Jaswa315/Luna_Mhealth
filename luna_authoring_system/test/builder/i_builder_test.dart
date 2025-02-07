import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/builder/i_builder.dart';

/// Mock implementation of `IBuilder` for testing
class MockBuilder implements IBuilder<String> {
  String _value = "Default";

  MockBuilder setValue(String value) {
    _value = value;
    return this;
  }

  @override
  String build() {
    return _value;
  }
}

void main() {
  group('IBuilder Tests', () {
    test('MockBuilder should correctly implement IBuilder and build()', () {
      expect(
          MockBuilder().setValue("Test Value").build(), equals("Test Value"));
    });

    test('MockBuilder should return default value if not set', () {
      expect(MockBuilder().build(), equals("Default"));
    });

    test('MockBuilder should allow method chaining', () {
      final builder = MockBuilder().setValue("Chain Test").build();
      expect(builder, equals("Chain Test"));
    });
  });
}
