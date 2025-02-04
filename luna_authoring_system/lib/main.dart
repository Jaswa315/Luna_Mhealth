import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_authoring_system/module_object_generator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_parser.dart';
import 'package:luna_authoring_system/validator/pptx_validations.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_manager.dart';

Future<void> main() async {
  // initialize log manager
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  await LogManager.createInstance();

  const String pptxFilePath = String.fromEnvironment('pptxFilePath');
  const String outputDir = String.fromEnvironment('outputDir');
  const String moduleName = String.fromEnvironment('moduleName');

  // ignore: unnecessary_null_comparison
  if (pptxFilePath == null || outputDir == null || moduleName == null) {
    // Files are under Documents/ by default on Macos
    // On Windows, Files are generated under C:\Users\username\Documents.
    print(
      'Usage: flutter run --dart--define=pptxFilePath=<pptx_file_path> --dart-define=outputDir=<output_dir> --dart-define=moduleName=<module_name>',
    );

    // Exit with code -1 to indicate an error
    exit(-1);
  }

  // Parse the presentation
  PptxParser pptxParser = PptxParser(pptxFilePath);
  PptxTree pptxTree = pptxParser.getPptxTree();

  // Get List of all PPTX Validations to Run using Validator Manager
  ValidatorManager validatorManager =
      PptxValidations.getPptxValidationsToRun(pptxTree);

  // Run Validation
  Set<ValidatorError> errorList = validatorManager.validateAll();

  // Check for validation errors
  if (errorList.isNotEmpty) {
    // Print all errors
    for (var error in errorList) {
      // TODO: Later change to Log Statement
      // ignore: avoid_print
      print('Validation Error: ${error.errorType}');
    }
    // Exit with code -1 to indicate validation failure
    exit(-1);
  }

  ModuleObjectGenerator moduleObjectGenerator = ModuleObjectGenerator(pptxTree);
  Module module = await moduleObjectGenerator.generateLunaModule();
  String moduleJson = jsonEncode(module.toJson());
  
  // Create the package (ZIP file) using ModuleStorage
  // Save module JSON data into the archive
  ModuleResourceFactory.addModule(moduleName, moduleJson);
}
