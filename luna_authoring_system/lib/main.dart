import 'dart:convert';
import 'dart:io';

import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/module_object_generator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_parser.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/pptx_validator.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';


Future<void> main() async {

  // Initialize AuthoringSystem singletons and load app settings
  await AuthoringInitializer.initializeAuthoring();

  const String pptxFilePath = String.fromEnvironment('pptxFilePath');
  const String moduleName = String.fromEnvironment('moduleName');

  // ignore: unnecessary_null_comparison
  if (pptxFilePath == null || moduleName == null) {
    // Files are under Documents/ by default on Macos
    // On Windows, Files are generated under C:\Users\username\Documents.
    // ignore: avoid_print
    print(
      'Usage: flutter run --dart--define=pptxFilePath=<pptx_file_path> --dart-define=moduleName=<module_name>',
    );

    // Exit with code -1 to indicate an error
    exit(-1);
  }

  // Parse the presentation
  PptxParser pptxParser = PptxParser(pptxFilePath);
  PptxTree pptxTree = pptxParser.getPptxTree();

  // Run all PPTX validations.
  Set<IValidationIssue> issueList = PptxValidator(pptxTree).validate();

  // Check for validation errors.
  if (issueList.isNotEmpty) {
    // Print all errors.
    for (var issue in issueList) {
      // TODO: Replace with Log
      // ignore: avoid_print
      print('Validation Issue Found: ${issue.toText()}');
    }
    // Exit with code -1 to indicate validation failure.
    exit(-1);
  }

  // TODO: Render or save txt file of issues for author to see
  
  ModuleObjectGenerator moduleObjectGenerator = ModuleObjectGenerator(pptxTree);
  Module module = await moduleObjectGenerator.generateLunaModule();
  String moduleJson = jsonEncode(module.toJson());

  // Create the package (ZIP file) using ModuleStorage
  // Save module JSON data into the archive
  ModuleResourceFactory.addModule(moduleName, moduleJson);
}
