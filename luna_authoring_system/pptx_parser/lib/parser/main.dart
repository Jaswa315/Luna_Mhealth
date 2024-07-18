import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'presentation_parser.dart';
import 'presentation_tree.dart';
import 'image_extractor.dart';
import 'package:luna_core/localization/localized_text.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_core/utils/logging.dart';
import 'dart:typed_data';
import 'module_object_generator.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  await LogManager.createInstance();

  if (arguments.length < 4) {
    print(
        'Usage: dart main.dart <pptx_file_path> <localization_file_path> <output_dir> <module_name>');

    // Helper code for debugging purposes.
    // ToDo: Remove when more polished
    final String samplePPTName = 'Pregnancy-sample.pptx';
    arguments = [
      // You'll need to change this or add the sample module to autoload the module.
      // Files are under /Users/username/Library/Containers/com.example.pptParser/Data by default on Macos
      // data/sample for temp assets data/documents for the module.luna file
      samplePPTName,
      'sample/localization',
      'sample/output',
      'PregnancySample'
    ];

    ByteData pptAsset = await rootBundle.load('assets/$samplePPTName');
    File file = File(samplePPTName);
    await file.writeAsBytes(pptAsset.buffer.asUint8List());

    //return;
  }

  // Initialize paths and files from arguments
  String pptxFilePath = arguments[0];
  String localizationFilePath = arguments[1];
  String outputDir = arguments[2];
  String moduleName = arguments[3];

  // Parse the presentation
  File pptxFile = File(pptxFilePath);
  PresentationParser presentationParser = PresentationParser(pptxFile);

  // Extract images
  ImageExtractor imgExtractor = ImageExtractor(presentationParser);
  imgExtractor.extractImages(outputDir);

  // Process localization texts
  //  File localizationFile = File(localizationFilePath);
  //  Uint8List localizationBytes = await localizationFile.readAsBytes();
  //  LocalizedText localizedText = LocalizedText(localizationBytes);

  // ToDo: Extract localization csv file and place into temp dir for author usage.

  ModuleObjectGenerator moduleObjectGenerator =
      ModuleObjectGenerator(presentationParser);
  Module module = await moduleObjectGenerator.generateLunaModule();

  String moduleJson = jsonEncode(module.toJson());
  File moduleSchema = File(p.join(outputDir, '$moduleName.json'));
  moduleSchema.writeAsString(moduleJson);

  // Create the package (ZIP file) using ModuleStorage
  ModuleStorage moduleStorage = ModuleStorage();
  // Save module JSON data into the archive
  await moduleStorage.createNewModuleFile(moduleName, moduleJson);

  // Add extracted images and localization to the module archive
  Directory imagesDir = Directory(p.join(outputDir, 'images'));
  List<FileSystemEntity> imageFiles = imagesDir.listSync();
  for (var imageFile in imageFiles) {
    if (imageFile is File) {
      String fileName = p.basename(imageFile.path);
      Uint8List imageBytes = await imageFile.readAsBytes();
      await moduleStorage.addModuleAsset(
          moduleName, "resources/images/$fileName", imageBytes);
    }
  }

  // ToDo: Add localization files to module correctly from temp dir

  // Add localization CSV file to the module archive
  // String localizationFileName = 'localization.csv';
  // await moduleStorage.addModuleAsset(moduleName,
  //    "resources/localization/$localizationFileName", localizationBytes);

  print('Package created successfully at $outputDir');
}

// Helper function to get PresentationNode from PresentationParser
Future<PresentationNode> getPresentationNode(PresentationParser parser) async {
  PrsNode prsNode = await parser.toPrsNode();
  if (prsNode is PresentationNode) {
    return prsNode;
  } else {
    throw Exception('Parsed node is not a PresentationNode');
  }
}
