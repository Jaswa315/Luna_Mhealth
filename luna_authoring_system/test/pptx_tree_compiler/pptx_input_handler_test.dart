import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_input_handler.dart';

void main() {
  group('PptxInputHandler Tests', () {
    test('Valid PPTX input returns File object', () {
      final file = File('test/test_assets/A line.pptx');
      expect(file.existsSync(), true);

      final result = PptxInputHandler.processInputs(
          ['test/test_assets/A line.pptx', 'test_module']);
      expect(result, isA<File>());
    });

    test('Missing arguments throws ArgumentError', () {
      expect(() => PptxInputHandler.processInputs(['only_one_argument']),
          throwsA(isA<ArgumentError>()));
    });

    test('Invalid file extension throws ArgumentError', () {
      final badFile = File('test/test_assets/sample.txt');
      badFile.createSync(recursive: true);

      expect(
          () => PptxInputHandler.processInputs(
              ['test/test_assets/sample.txt', 'test_module']),
          throwsA(isA<ArgumentError>()));

      badFile.deleteSync();
    });

    test('Non-existent file path throws ArgumentError', () {
      expect(
          () => PptxInputHandler.processInputs(
              ['test/test_assets/not_found.pptx', 'test_module']),
          throwsA(isA<ArgumentError>()));
    });
  });
}
