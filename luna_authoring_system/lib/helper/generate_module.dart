// generate_module is a helper module for testing that provides functions to return a module or a pptx tree.
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:luna_authoring_system/builder/module_constructor.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree_builder.dart';
import 'package:luna_core/models/module.dart';

/// getModule takes in a file name of a pptx and returns a module
/// Intended for testing use, provide a test pptx to be converted.
/// A module version of that file is returned
@visibleForTesting
Future<Module> getModule(String fileName) async {
  final pptxFile = File(fileName);
  PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
  PptxTree pptxTree = pptxTreeBuilder.getPptxTree();
  ModuleConstructor moduleConstructor = ModuleConstructor(pptxTree);
  Module module = await moduleConstructor.constructLunaModule();

  return module;
}

/// getPptxtree takes in a file name of a pptx and returns a PptxTree
/// Intended for testing use, provide a test pptx to be converted.
/// A PptxTree version of that file is returned
@visibleForTesting
PptxTree getPptxTree(String fileName){
  final pptxFile = File(fileName);
  PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
  PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

  return pptxTree;
}
