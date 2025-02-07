import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_parser.dart';
import 'package:luna_authoring_system/module_object_generator.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/shape/line_component.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
      'Should be able to create module.dart with pptx tree with single slide that has single line',
      () async {
    // Parse the PPTX tree
    PptxTree pptxTree =
        PptxParser('test/test_assets/A line.pptx').getPptxTree();

    // Create the ModuleObjectGenerator
    ModuleObjectGenerator moduleObjectGenerator =
        ModuleObjectGenerator(pptxTree);

    // Generate the module asynchronously
    Module generatedModule = await moduleObjectGenerator.generateLunaModule();

    expect(generatedModule.pages.length, 1);
    expect(generatedModule.pages[0].components.length, 1);
    expect(generatedModule.pages[0].components[0], isA<LineComponent>());
  });
}
