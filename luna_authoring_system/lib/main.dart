import 'package:flutter/material.dart';
import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';
import 'package:luna_authoring_system/user_interface/presentation/authoring_home_screen.dart';



Future<void> main(List<String> arguments) async {

  if (arguments.isEmpty){
    // No Arguments present GUI
    runApp(MyApp());
    
    return;
  }

  // Process CMD app if applicable
  // Initialize AuthoringSystem singletons and load app settings
  await AuthoringInitializer.initializeAuthoring();
  // Process the pptxFile and output the Luna file for cmd
  await PptxRunner().processPptx(arguments[0], arguments[1]);
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
