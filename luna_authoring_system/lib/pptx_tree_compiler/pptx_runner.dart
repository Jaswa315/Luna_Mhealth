import 'dart:convert';
import 'dart:io';
import 'package:luna_authoring_system/builder/module_constructor.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_input_handler.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree_builder.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/pptx_validator.dart';
import 'package:luna_authoring_system/validator/validator_runner.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';

/// Class to run the parsing process of a pptx into a luna file.
class PptxRunner {
  late String _moduleName;
  late PptxTree _pptxTree;
  ValidationIssuesStore store;

  PptxRunner(this.store);

  /// Parses a PPTX file, validates, and generates a .luna module.
  Future<void> processPptx(String pptxFilePath, String moduleName) async {
    // Step 1: Validate and load file
    File pptxFile = PptxInputHandler.processInputs([pptxFilePath, moduleName]);
    _moduleName = moduleName;

    // Step 2: Build PPTX Tree from the file
    PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
    _pptxTree = pptxTreeBuilder.getPptxTree();

    // Step 3: Run validators via a dedicated runner
    final validator = PptxValidator(_pptxTree);
    ValidatorRunner validatorRunner = ValidatorRunner(validator);
    validatorRunner.runValidators(store);

    // Step 4: Generate .luna module from pptx tree
    await _generateLunaModule();
  }

  /// Generates and stores the .luna file based on the parsed PPTX tree.
  Future<void> _generateLunaModule() async {
    ModuleConstructor moduleConstructor = ModuleConstructor(_pptxTree);
    Module module = await moduleConstructor.constructLunaModule();
    String moduleJson = jsonEncode(module.toJson());

    await ModuleResourceFactory.addModule(_moduleName, moduleJson);
  }
}
