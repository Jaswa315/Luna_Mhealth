import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/user_interface/presentation/authoring_home_screen.dart';
import 'package:luna_core/storage/module_resource_factory.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    // No Arguments present GUI
    runApp(MyApp());
    return;
  }

  // Process CMD app if applicable
  await AuthoringInitializer.initializeAuthoring();
  ValidationIssuesStore store = ValidationIssuesStore();

  // Build the pptxFile into a Module (no saving inside runner)
  final module = await PptxRunner(store).buildModule(arguments[0], arguments[1]);

  // Save explicitly via ModuleResourceFactory
  await ModuleResourceFactory.addModule(arguments[1], jsonEncode(module.toJson()));

  exit(0);
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.microtask(() => AuthoringInitializer.initializeAuthoring());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthoringHomeScreen(),
    );
  }
}
