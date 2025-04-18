import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/point.dart';

void main() {
  group('Tests for Transform', () {
    test('An error is thrown when offset and size are not initialzed at CTOR.',
        () {
      expect(
        () => Function.apply(Transform.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
    test('An error is thrown when only one argument is given at CTOR.', () {
      expect(
        () => Function.apply(Transform.new, [
          1,
        ]),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
    test('Transform can be initialzed with Point values at CTOR.', () {
      Transform transform =
          Transform(Point(EMU(10), EMU(20)), Point(EMU(30), EMU(40)));

      expect((transform.offset.x as EMU).value, 10);
      expect((transform.offset.y as EMU).value, 20);
      expect((transform.size.x as EMU).value, 30);
      expect((transform.size.y as EMU).value, 40);
    });
  });
}
