import 'dart:io';

import 'package:flutter/material.dart';
import 'package:luna_authoring_system/controllers/module_build_service.dart';
import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/user_interface/presentation/authoring_home_screen.dart';

Future<void> main(List<String> arguments) async {
  // GUI mode
  if (arguments.isEmpty) {
    // Initialize once for GUI
    await AuthoringInitializer.initializeAuthoring();
    runApp(const MyApp());
    return;
  }

  // CLI mode: need 2 args
  if (arguments.length < 2) {
    stderr.writeln('Usage: app -- <pptx> <moduleName>');
    exit(64); 
  }
  final pptx = arguments[0];
  final moduleName = arguments[1];

  await AuthoringInitializer.initializeAuthoring();

  final store = ValidationIssuesStore();
  final service = ModuleBuildService(store);

  try {
    final module = await service.build(pptx, moduleName);
    await service.save(moduleName, module);
    exit(0);
  } on StateError catch (e) {
    stderr.writeln('Validation failed: ${e.message}');
    exit(2);
  } catch (e) {
    stderr.writeln('Build failed: $e');
    exit(1);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthoringHomeScreen(),
    );
  }
}
