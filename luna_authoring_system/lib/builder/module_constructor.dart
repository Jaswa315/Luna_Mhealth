import 'package:luna_authoring_system/builder/module_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/models/module.dart';

/// ModuleConstructor orchestrates the creation of a `Module` from a `PptxTree`.
///
/// This class utilizes `ModuleBuilder` to set up and construct a module based on
/// parsed PowerPoint data. It ensures:
/// - Extracting module dimensions.
/// - Setting the title and author.
/// - Building pages from the PowerPoint structure.
///
/// The `constructLunaModule()` method performs the entire construction process
/// asynchronously and returns a `Module` instance.

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
