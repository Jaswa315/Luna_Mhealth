import 'dart:convert';
import 'dart:io';

import 'package:luna_authoring_system/module_object_generator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_parser.dart';
import 'package:luna_authoring_system/validator/pptx_validations.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_manager.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  if (args.length != 3) {
    // ignore: avoid_print
    print('Usage: dart main.dart <pptx_file_path> <output_dir> <module_name>');

    // Exit with code -1 to indicate an error
    exit(-1);
  }

  String pptxFilePath = args[0];
  String outputDir = args[1];
  String moduleName = args[2];

  // Parse the presentation
  PptxParser pptxParser = PptxParser(pptxFilePath);
  PptxTree pptxTree = pptxParser.getPptxTree();

  // Get List of all PPTX Validations to Run using Validator Manager
  ValidatorManager validatorManager = PptxValidations.getPptxValidationsToRun(pptxTree);

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
  File moduleSchema = File(p.join(outputDir, '$moduleName.json'));
  moduleSchema.writeAsString(moduleJson);

  // Create the package (ZIP file) using ModuleStorage
  // Save module JSON data into the archive
  ModuleResourceFactory.addModule(moduleName, moduleJson);
}
