import 'dart:io';

import 'package:flutter/material.dart';
import 'package:luna_authoring_system/controllers/module_build_service.dart';
import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/user_interface/presentation/authoring_home_screen.dart';

Future<void> main(List<String> arguments) async {
  // GUI mode
  if (arguments.isEmpty) {
    runApp(MyApp());
    return;
  }

  await AuthoringInitializer.initializeAuthoring();

  final store = ValidationIssuesStore();
  final service = ModuleBuildService(store);

  try {
    // Build Module
    final module = await service.build(arguments[0], arguments[1]);

    // Save
    await service.save(arguments[1], module);

    exit(0);
  } on StateError catch (e) {
    // Thrown by build() when validation issues are present
    stderr.writeln('Validation failed: ${e.message}');
    exit(2);
  } catch (e) {
    stderr.writeln('Build failed: $e');
    exit(1);
  }
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize shared authoring services on app start
    Future.microtask(() => AuthoringInitializer.initializeAuthoring());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthoringHomeScreen(),
    );
  }
}
