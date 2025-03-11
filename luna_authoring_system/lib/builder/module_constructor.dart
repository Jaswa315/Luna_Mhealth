import 'package:luna_authoring_system/builder/module_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/models/module.dart';

class ModuleConstructor {
  final PptxTree pptxTree;

  ModuleConstructor(this.pptxTree);

  Future<Module> constructLunaModule() async {
    final moduleWidth = pptxTree.width.value;
    final moduleHeight = pptxTree.height.value;

    return ModuleBuilder()
        .setTitle(pptxTree.title)
        .setAuthor(pptxTree.author)
        .setDimensions(moduleWidth, moduleHeight)
        .setPages(pptxTree)
        .build();
  }
}
