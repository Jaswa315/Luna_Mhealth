import 'package:flutter/material.dart';
import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';

import 'package:file_picker/file_picker.dart';
import 'package:luna_authoring_system/user_interface/authoring_home_screen.dart';



Future<void> main(List<String> arguments) async {
  // Initialize AuthoringSystem singletons and load app settings
  //await AuthoringInitializer.initializeAuthoring();

  var input_to_process = <String>[];

  if (arguments.isEmpty){
    // No Arguments present GUI
    runApp(MyApp());
    
    return;
    //final path = await FilePicker.platform.pickFiles();
    //input_to_process.add(path!.paths[0]!);
    //input_to_process.add("gui");
  }else{
    input_to_process = arguments;
  }

  final pptxFile = AuthoringInitializer.processInputs(input_to_process);
  

  /// Process the pptxFile and output the Luna file
  await PptxRunner().processPptx(pptxFile, input_to_process[1]);
  print("test");
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
