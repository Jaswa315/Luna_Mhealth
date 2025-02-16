import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';


Future<void> main() async {

  // Initialize AuthoringSystem singletons and load app settings
  await AuthoringInitializer.initializeAuthoring();

  /// This is to ensure that the current --dart-define method works
  /// will be folded into validateInputs once arguments work
  const String pptxFilePath = String.fromEnvironment('pptxFilePath');
  const String moduleName = String.fromEnvironment('moduleName');
  final pptxFile = AuthoringInitializer.processInputs([pptxFilePath,moduleName]);

  /// Process the pptxFile and output the Luna file
  await PptxRunner().processPptx(pptxFile, moduleName);

}
