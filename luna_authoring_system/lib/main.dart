import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator, rootBundle;
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_core/storage/module_storage.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:path/path.dart' as p;
import 'parser/image_extractor.dart';
import 'parser/module_object_generator.dart';
import 'parser/presentation_parser.dart';
import 'parser/presentation_tree.dart';


Future<void> main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  await LogManager.createInstance();

  const int batchSize = 10;

  if (arguments.length < 4) {
    //print(
    //   'Usage: dart main.dart <pptx_file_path> <localization_file_path> <output_dir> <module_name>');

    // Helper code for debugging purposes.
    // ToDo: Remove when more polished
    const String samplePPTName = 'Pregnancy-sample.pptx';
    arguments = [
      // You'll need to change this or add the sample module to autoload the module.
      // Files are under /Users/username/Library/Containers/com.example.pptParser/Data by default on Macos
      // On Windows, Files are generated under C:\Users\username\Documents.
      // data/sample for temp assets data/documents for the module.luna file
      samplePPTName,
      'sample/localization',
      'sample/output',
      'PregnancySample'
    ];

    ByteData pptAsset = await rootBundle.load('assets/$samplePPTName');
    File file = File(samplePPTName);
    await file.writeAsBytes(pptAsset.buffer.asUint8List(), mode:FileMode.write);

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
  Module module = await moduleObjectGenerator.generateLunaModule(moduleName);

  String moduleJson = jsonEncode(module.toJson());
  File moduleSchema = File(p.join(outputDir, '$moduleName.json'));
  moduleSchema.writeAsString(moduleJson);

  // Create the package (ZIP file) using ModuleStorage
  // Save module JSON data into the archive
  ModuleResourceFactory.addModule(moduleName, moduleJson);

  // Create initial CSV localization file
  Uint8List? csvFileBytes =
      await ModuleResourceFactory.createInitialNewLanguageCSV(moduleJson);
  String csvFilePath = ModuleResourceFactory.getInitialCSVFilePath(moduleJson);
  File csvFile = File(p.join(localizationFilePath, csvFilePath));
  csvFile.parent.createSync(recursive: true);
  csvFile.writeAsBytes(csvFileBytes!);

  // Add extracted images and localization to the module archive
  ModuleStorage moduleStorage = ModuleStorage();
  Directory imagesDir = Directory(p.join(outputDir, 'images'));
  List<FileSystemEntity> imageFiles = imagesDir.listSync();
  int counter = 0;
  Map<String, Uint8List?> imageMap = {};
  for (var imageFile in imageFiles) {
    if (imageFile is File) {
      String fileName = p.basename(imageFile.path);
      Uint8List imageBytes = await imageFile.readAsBytes();
      imageMap["resources/images/$fileName"] = imageBytes;
      counter++;

      if (counter > batchSize) {
        await moduleStorage.addModuleAssets(moduleName, imageMap);
        counter = 0;
        imageMap.clear();
      }
    }
  }

  // Process any remaining batch files
  if (imageMap.isNotEmpty) {
    await moduleStorage.addModuleAssets(moduleName, imageMap);
  }

  // ToDo: Add localization files to module correctly from temp dir

  // Add localization CSV file to the module archive
  // String localizationFileName = 'localization.csv';
  // await moduleStorage.addModuleAsset(moduleName,
  //    "resources/localization/$localizationFileName", localizationBytes);

  // print('Package created successfully at $outputDir');
  SystemNavigator.pop();
}

/// Helper function to get PresentationNode from PresentationParser
Future<PresentationNode> getPresentationNode(PresentationParser parser) async {
  PrsNode prsNode = await parser.toPrsNode();
  if (prsNode is PresentationNode) {
    return prsNode;
  } else {
    throw Exception('Parsed node is not a PresentationNode');
  }
}
