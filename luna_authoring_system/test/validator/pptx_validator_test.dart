import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/pptx_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';

void main() {
  test('PptxValidator.getIssuesFileBytes returns file bytes with each issue code on a new line', () {
    // Arrange: create a PPTX tree that we know will produce validation issues.
    // For example, an empty (or whitespace-only) title should trigger a title validation issue,
    // and leaving dimensions uninitialized should trigger a dimensions validation issue.
    final pptxTree = PptxTree();
    pptxTree.title = "   "; // Trigger title error.
    // Do NOT initialize width/height so that accessing them triggers a LateInitializationError
    // (and thus the dimensions error).
    
    // Act: Instantiate the real PPTX validator and obtain the file bytes.
    final validator = PptxValidator(pptxTree);
    final bytes = validator.validateAndGetIssuesAsTXTFileBytes();
    final fileContent = utf8.decode(bytes);
    
    // Because the order in a Set is not guaranteed, we split into lines, filter out empties, sort, and compare.
    final lines = fileContent.split('\n').where((line) => line.isNotEmpty).toList()..sort();
    
    // Expected issue codes (adjust these strings to match your real error codes).
    final expectedLines = [
      'pptx_title_has_no_visible_characters',
      'pptx_width_and_height_must_both_be_initialized'
    ]..sort();
    
    // Assert: The file content should list each issue code on its own line.
    expect(lines, expectedLines);
  });
}
