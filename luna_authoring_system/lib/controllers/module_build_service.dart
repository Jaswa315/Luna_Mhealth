import 'dart:convert';

import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';

/// Service to build and save a Module from a PPTX file.
class ModuleBuildService {
  final ValidationIssuesStore store;
  final PptxRunner _runner;

  ModuleBuildService(this.store) : _runner = PptxRunner(store);

  /// Builds a Module and saves it. Returns the Module.
  Future<Module> buildAndSave(String pptxPath, String moduleName) async {
    final module = await _runner.buildModule(pptxPath, moduleName); // build
    if (!store.hasIssues) {
      await ModuleResourceFactory.addModule(                    // save
        moduleName,
        jsonEncode(module.toJson()),
      );
    }
    return module;
  }
}
