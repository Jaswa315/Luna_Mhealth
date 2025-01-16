import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_loader.dart';
import 'package:luna_core/utils/types.dart';

void main() {
  group('Tests for PptxLoader', () {
    test('Argument error is thrown when input is not .pptx file.', () async {
      expect(() => PptxLoader('a.txt'), throwsA(isArgumentError));
    });
  });
}
