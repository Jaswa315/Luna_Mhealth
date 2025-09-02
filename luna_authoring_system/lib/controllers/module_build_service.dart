import 'dart:convert';

import 'package:luna_authoring_system/builder/module_constructor.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';

class ModuleBuildService {
  final ValidationIssuesStore store;

  ModuleBuildService(this.store);

  /// Parses, validates PPTX, builds Module, saves .luna, returns Module.
  Future<Module> buildAndSave(String pptxFilePath, String moduleName) async {
    // Parse & validate (no saving here)
    final tree = await PptxRunner(store).buildTree(pptxFilePath, moduleName);

    // If validation failed, bubble up so UI can show issues
    if (store.hasIssues) {
      throw StateError('Validation issues present; not saving module.');
    }

    // Build module from tree
    final module = await ModuleConstructor(tree).constructLunaModule();

    // Save module json into .luna
    await ModuleResourceFactory.addModule(moduleName, jsonEncode(module.toJson()));

    return module;
  }
}