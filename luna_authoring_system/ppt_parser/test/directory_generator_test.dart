import 'dart:io';
import 'package:ppt_parser/content_directory_generator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:luna_mhealth_mobile/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';

const String assetsFolder = 'test/test_assets';
const String targetRoot = 'test/output/directory_tests';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");

  Future<void> cleanUpGeneratedFilesAfterTest(String directoryPath) async {
    Directory directory = Directory(directoryPath);
    // Check if the directory exists
    if (directory.existsSync()) {
      // List all contents
      var contents = directory.listSync();
      // Iterate and delete each item within
      for (var fileOrDir in contents) {
        if (fileOrDir is File) {
          fileOrDir.deleteSync();
        } else if (fileOrDir is Directory) {
          fileOrDir.deleteSync(recursive: true);
        }
      }
    }
  }

  setUp(() async {
    // Ensuring the directory exists before each test and is clean
    await Directory(targetRoot).create(recursive: true);
    await cleanUpGeneratedFilesAfterTest(targetRoot);
  });

  tearDown(() async {
    // Clean up after each test but keep the root directory
    await cleanUpGeneratedFilesAfterTest(targetRoot);
  });

  group(
      'Content Directory Generator Tests: Initial Directory Structure is as Expected',
      () {
    setUpAll(() {
      LogManager.createInstance();
    });

    test('Initializes directory structure as expected', () async {
      ContentDirectoryGenerator generator = ContentDirectoryGenerator();
      String powerpointLocation = "$assetsFolder/TextBox-HelloWorld.pptx";
      bool success = await generator.initializeDirectory(
          powerpointLocation, "en_US", targetRoot);
      expect(success, true);

      String contentDataFolder = "$targetRoot/TextBox-HelloWorld";
      expect(
          Directory(path.join(contentDataFolder, 'pptx')).existsSync(), isTrue,
          reason: 'The pptx directory should exist.');
      expect(Directory(path.join(contentDataFolder, 'module')).existsSync(),
          isTrue,
          reason: 'The module directory should exist.');
      expect(
          Directory(path.join(contentDataFolder, 'module', 'resources'))
              .existsSync(),
          isTrue,
          reason: 'The resources directory should exist.');
    });

    test(
        'Initializing a directory copies given the PowerPoint to [arbitrary_root]/module_name/pptx',
        () async {
      ContentDirectoryGenerator generator = ContentDirectoryGenerator();
      String powerpointLocation = "$assetsFolder/TextBox-HelloWorld.pptx";
      bool success = await generator.initializeDirectory(
          powerpointLocation, "en_US", targetRoot);
      expect(success, true);
      expect(
          File(path.join(targetRoot, 'TextBox-HelloWorld', 'pptx',
                  'TextBox-HelloWorld.pptx'))
              .existsSync(),
          isTrue);
    });

    test(
        'Content Directory Generator: Initializing a directory has the inputted language directory with a CSV file',
        () async {
      ContentDirectoryGenerator generator = ContentDirectoryGenerator();
      String pptxName = "TextBox-HelloWorld";
      String powerpointLocation = "$assetsFolder/$pptxName.pptx";
      String language = "en-US";
      bool success = await generator.initializeDirectory(
          powerpointLocation, language, targetRoot);
      expect(success, true);

      String csvFilePath = path.join(targetRoot, pptxName, 'module',
          'resources', language, '$language.csv');
      File csvFile = File(csvFilePath);

      bool fileExists = await csvFile.exists();
      expect(fileExists, isTrue,
          reason: 'CSV file should exist at $csvFilePath');
    });
  });
}
