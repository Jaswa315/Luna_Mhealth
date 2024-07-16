import 'dart:io';
import 'presentation_parser.dart';
import 'presentation_tree.dart';
import 'image_extractor.dart';
import 'package:luna_core/localization/localized_text.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_storage.dart';
import 'dart:typed_data';
import 'module_object_generator.dart';

import 'package:path/path.dart' as p;

Future<void> main(List<String> arguments) async {
  if (arguments.length < 4) {
    print(
        'Usage: dart main.dart <pptx_file_path> <localization_file_path> <output_dir> <module_name>');
    arguments = [
      'Pregnancy-sample.pptx',
      'sample/localization',
      'sample/output',
      'Pregnancy Sample'
    ];
    print(Directory.current.absolute.path);
    Directory currentDirectory = Directory.current;

    // List all files in the current directory
    List<FileSystemEntity> entities = currentDirectory.listSync();

    // Filter and print only the files
    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        print(entity.path);
      }
    }
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

  ModuleObjectGenerator moduleObjectGenerator =
      ModuleObjectGenerator(presentationParser);
  Module module = await moduleObjectGenerator.generateLunaModule();

  // Create the package (ZIP file) using ModuleStorage
  ModuleStorage moduleStorage = ModuleStorage();
  // Save module JSON data into the archive
  await moduleStorage.createNewModuleFile(
      moduleName, module.toJson().toString());

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
