import 'dart:io';

import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';


Future<void> main(List<String> arguments) async {
  // Initialize AuthoringSystem singletons and load app settings
  await AuthoringInitializer.initializeAuthoring();


  /// This is to ensure that the current --dart-define method works
  /// will be folded into validateInputs once arguments work
  final pptxFile = AuthoringInitializer.processInputs(arguments);

  /// Process the pptxFile and output the Luna file
  await PptxRunner().processPptx(pptxFile, arguments[1]);
}
