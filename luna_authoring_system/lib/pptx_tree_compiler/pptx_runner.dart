import 'dart:convert';
import 'dart:io';

import 'package:luna_authoring_system/builder/module_constructor.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_input_handler.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree_builder.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/pptx_validator.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';

/// Class to run the parsing process of a pptx into a luna file.
class PptxRunner {
  late String _moduleName;
  late PptxTree _pptxTree;

  /// Takes in a filepath to a pptx file and output directory (currently users home directory)
  /// Outputs the luna file for the pptx if no validation issues
  /// Outputs validations issue text file otherwise

  Future<void> processPptx(String pptxFilePath, String moduleName) async {
    // Delegate input handling
    File pptxFile = PptxInputHandler.processInputs([pptxFilePath, moduleName]);
    _moduleName = moduleName;

    // Parse the presentation
    PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
    _pptxTree = pptxTreeBuilder.getPptxTree();

    // Run validations
    _runValidations();

    // Generate the Luna Module
    await _generateLunaModule();
  }

  /// Checks the pptx tree for validation issues
  void _runValidations() {
    // Run all PPTX validations.
    Set<IValidationIssue> issueList = PptxValidator(_pptxTree).validate();

    // Check for validation errors.
    if (issueList.isNotEmpty) {
      // Print all errors.
      for (var issue in issueList) {
        // TODO: Replace with Log
        // ignore: avoid_print
        print('Validation Issue Found: ${issue.toText()}');
      }
      throw ArgumentError(
          'Validation failed with ${issueList.length} issue(s).');
    }

    // TODO: Render or save txt file of issues for author to see
  }

  /// Generates a luna module from a pptx tree
  Future _generateLunaModule() async {
    ModuleConstructor moduleObjectGenerator = ModuleConstructor(_pptxTree);
    Module module = await moduleObjectGenerator.constructLunaModule();
    String moduleJson = jsonEncode(module.toJson());

    // Create the package (ZIP file) using ModuleStorage
    // Save module JSON data into the archive
    await ModuleResourceFactory.addModule(_moduleName, moduleJson);
  }
}
