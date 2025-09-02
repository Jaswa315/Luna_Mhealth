import 'package:flutter_test/flutter_test.dart';
import 'package:luna_mobile/custom_exception_types/renderer_exception.dart';

void main() {
  test('RendererException constructs correctly', () {
    final exception = RendererException('Test error message', 'Cause of error');

    expect(exception.message, 'Test error message');
    expect(exception.cause, 'Cause of error');
    expect(exception.toString(), 'RendererException: Test error message (Caused by: Cause of error)');
  });

  test('RendererException without cause', () {
    final exception = RendererException('Another test message');

    expect(exception.message, 'Another test message');
    expect(exception.cause, isNull);
    expect(exception.toString(), 'RendererException: Another test message');
  });
}