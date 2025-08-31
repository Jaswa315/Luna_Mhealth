import 'dart:io';

import 'package:luna_authoring_system/builder/module_constructor.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_input_handler.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree_builder.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/pptx_validators/pptx_validator.dart';
import 'package:luna_authoring_system/validator/validator_runner.dart';
import 'package:luna_core/models/module.dart';

/// Class to run the parsing process of a pptx into a Module.
class PptxRunner {           
  late PptxTree _pptxTree;
  final ValidationIssuesStore store;

  PptxRunner(this.store);

  /// Parses a PPTX file, validates, and builds a Module (no saving).
  Future<Module> buildModule(pptxFilePath, String moduleName) async {
    // Step 1: Validate and load file
    final File pptxFile =
        PptxInputHandler.processInputs([pptxFilePath, moduleName]);

    // Step 2: Build PPTX Tree from the file
    final PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
    _pptxTree = pptxTreeBuilder.getPptxTree();

    // Step 3: Run validators via a dedicated runner
    final validator = PptxValidator(_pptxTree);
    final validatorRunner = ValidatorRunner(validator);
    validatorRunner.runValidators(store);

    // Step 4: Construct Module (return it; no persistence here)
    final moduleConstructor = ModuleConstructor(_pptxTree);
    return moduleConstructor.constructLunaModule();
  }
}
