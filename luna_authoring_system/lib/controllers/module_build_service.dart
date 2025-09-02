import 'dart:convert';

import 'package:luna_authoring_system/builder/module_constructor.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';

class ModuleBuildService {
  final ValidationIssuesStore store;
  ModuleBuildService(this.store);

  /// Parse, validate PPTX, then build a Module
  Future<Module> build(String pptxFilePath, String moduleName) async {
    final tree = await PptxRunner(store).buildTree(pptxFilePath, moduleName);

    if (store.hasIssues) {
      throw StateError('Validation issues present; not building module.');
    }

    return ModuleConstructor(tree).constructLunaModule();
  }

  /// Save a built Module as a .luna file.
  Future<void> save(String moduleName, Module module) async {
    await ModuleResourceFactory.addModule(
      moduleName,
      jsonEncode(module.toJson()),
    );
  }
}
