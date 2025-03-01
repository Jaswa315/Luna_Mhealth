import 'dart:convert';
import 'dart:io';
import 'package:luna_authoring_system/module_object_generator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_parser.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/pptx_validator.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:path/path.dart' as p;

/// Class to run the parsing process of a pptx into a luna file.
class PptxRunner {

  late String _moduleName;
  late PptxTree _pptxTree;
  static const int _numberOfArguments = 2;




  /// Takes in a filepath to a pptx file and output directory (currently users home directory)
  /// Outputs the luna file for the pptx if no validation issues 
  /// Outputs validations issue text file otherwise
  Future processPptx(String pptxFilePath, String moduleName) async{


    // process the input to esnure they are good
    // gets a pptxFile if the passed in filepath is good.
    File pptxFile = _processInputs([pptxFilePath,moduleName]);
    _moduleName = moduleName;

    // Parse the presentation
    PptxParser pptxParser = PptxParser(pptxFile);
    _pptxTree = pptxParser.getPptxTree();

    // Run validations
    _runValidations();

    // Generate the Luna Module
    await _generateLunaModule();

  }


  /// Checks the pptx tree for validation issues
  void _runValidations(){

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
      // Exit with code -1 to indicate validation failure.
      exit(-1);
    }

    // TODO: Render or save txt file of issues for author to see
  }

  /// Generates a luna module from a pptx tree
  Future _generateLunaModule() async{

    ModuleObjectGenerator moduleObjectGenerator = ModuleObjectGenerator(_pptxTree);
    Module module = await moduleObjectGenerator.generateLunaModule();
    String moduleJson = jsonEncode(module.toJson());

    // Create the package (ZIP file) using ModuleStorage
    // Save module JSON data into the archive
    await ModuleResourceFactory.addModule(_moduleName, moduleJson);
    
  }

  /// [arguments] 
  /// [arguments] 0 is pptx filepath
  /// [arguments] 1 is module file name
  static _processInputs(List<String> arguments) {

    if (arguments.length != _numberOfArguments) {
      // Files are under Documents/ by default on Macos
      // On Windows, Files are generated under C:\Users\username\Documents.
      // ignore: avoid_print
      print(
        'Usage: flutter run ./lib/main.dart -a <pptx_file_path> -a <module_name>',
      );

      // Exit with code -1 to indicate an error
      exit(-1);
      
    }

    return _getPptxFile(arguments[0]);
  }

  static File _getPptxFile(String pptxFilePath){

    // validate file extension.
    final fileExtension = p.extension(pptxFilePath);
    final pptxFile = File(pptxFilePath);

    if (fileExtension.toLowerCase() != '.pptx') {
      throw ArgumentError(
        'Invalid file extension: $fileExtension. Only .pptx files are allowed.',
      );
    }

    if (!pptxFile.existsSync()){
      throw ArgumentError(
        'PPTX file at $pptxFilePath does not exists.',
      );
    }

    return pptxFile;
  }


}