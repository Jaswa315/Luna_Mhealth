import 'dart:io';

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_input_handler.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree_builder.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/pptx_validators/pptx_validator.dart';
import 'package:luna_authoring_system/validator/validator_runner.dart';

/// Runs the PPTX parsing pipeline and validation.
class PptxRunner {
  final ValidationIssuesStore store;

  PptxRunner(this.store);

  /// Parse + validate PPTX, returning a PptxTree.
  Future<PptxTree> buildTree(String pptxFilePath, String moduleName) async {
    // Validate inputs and get a real File
    final File pptxFile =
        PptxInputHandler.processInputs([pptxFilePath, moduleName]);

    // Parse PPTX -> PptxTree
    final PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
    final PptxTree tree = pptxTreeBuilder.getPptxTree();

    // Run validators and store any issues (UI can read them from `store`)
    final validator = PptxValidator(tree);
    final validatorRunner = ValidatorRunner(validator);
    validatorRunner.runValidators(store);

    return tree;
  }
}
