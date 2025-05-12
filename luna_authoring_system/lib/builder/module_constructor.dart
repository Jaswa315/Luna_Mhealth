import 'package:luna_authoring_system/builder/module_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/models/module.dart';

/// The ModuleConstructor serves as a high-level orchestrator that constructs a Module
/// from a [PptxTree], ensuring that the module is correctly initialized before being used.

/// Why is this class needed?
/// Separation of Concerns: Instead of directly using [ModuleBuilder] throughout the codebase,
/// this class centralizes the module creation logic, making it easier to manage and modify.
/// Ensures a structured module creation process: By abstracting the construction steps
/// (setting metadata, defining dimensions, building pages), it prevents incomplete or
/// inconsistent module states.
/// This class ensures that every [Module] instance is properly structured, asynchronous,
/// and easy to modify in case of future extensions.

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
        .setSequencesFromSection(pptxTree.slides, pptxTree.section)
        .build();
  }
}
