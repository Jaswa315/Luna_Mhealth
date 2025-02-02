import 'package:luna_authoring_system/module_object_generator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_parser.dart';
import 'package:luna_core/models/module.dart';

void main(List<String> args) {
    if (args.length != 3) {
      // ignore: avoid_print
      print('Usage: dart main.dart <pptx_file_path> <output_dir> <module_name>');
      
      return null;
    }

    //   'Usage: dart main.dart <pptx_file_path> <output_dir> <module_name>');
    PptxParser pptxParser = PptxParser(args[0]);
    // ignore: unused_local_variable
    PptxTree pptxTree = pptxParser.getPptxTree();
    
    // ToDo: Integrate Pptx Tree Validator

    // ToDo: Create ModuleObjectGenerator 
    ModuleObjectGenerator moduleObjectGenerator = ModuleObjectGenerator(pptxTree);
    Future<Module> module = moduleObjectGenerator.generateLunaModule();

     // ToDo: Create .luna file with ModuleResourceFactory.addModuleAssets
     
}
  