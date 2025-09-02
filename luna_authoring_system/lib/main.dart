import 'dart:io';

import 'package:flutter/material.dart';
import 'package:luna_authoring_system/controllers/module_build_service.dart';
import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/user_interface/presentation/authoring_home_screen.dart';


Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    // No Arguments present GUI
    runApp(MyApp());
    return;
  }

await AuthoringInitializer.initializeAuthoring();
final store = ValidationIssuesStore();

// delegate to the service
await ModuleBuildService(store).buildAndSave(arguments[0], arguments[1]);
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
