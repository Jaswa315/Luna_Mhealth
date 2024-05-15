import 'dart:io';
import 'package:pptx_parser/utils/content_directory_generator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:luna_core/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:ui'; // Import dart:ui to access the Locale class

const String assetsFolder = 'test/test_assets';
const String targetRoot = 'test/output/directory_tests';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");

  setUpAll(() {
    LogManager.createInstance();
  });

  tearDownAll(() async {
    if (await Directory(targetRoot).exists()) {
      await Directory(targetRoot).delete(recursive: true);
    }
  });

  // Helper function to create and return the test directory path
  Future<String> prepareTestDirectory(String testId) async {
    String testDirectory = path.join(targetRoot, testId);
    if (await Directory(testDirectory).exists()) {
      await Directory(testDirectory).delete(recursive: true);
    }
    await Directory(testDirectory).create(recursive: true);
    return testDirectory;
  }

  test(
      'Content Directory Generator: Initializing a directory has the expected language directory',
      () async {
    String testDirectory = await prepareTestDirectory('test3');
    ContentDirectoryGenerator generator = ContentDirectoryGenerator();
    String pptxName = "TextBox-HelloWorld";
    String powerpointLocation = "$assetsFolder/$pptxName.pptx";
    Locale locale = Locale('en', 'US'); // Using Locale
    bool success = await generator.initializeDirectory(powerpointLocation,
        locale, testDirectory); // Convert Locale to a BCP-47 language tag
    expect(success, true);
  });
  test(
      'Initializing a directory copies given the PowerPoint to specific location',
      () async {
    String testDirectory = await prepareTestDirectory('test2');
    ContentDirectoryGenerator generator = ContentDirectoryGenerator();
    String powerpointLocation = "$assetsFolder/TextBox-HelloWorld.pptx";
    Locale locale = Locale('en', 'US');
    bool success = await generator.initializeDirectory(
        powerpointLocation, locale, testDirectory);
    expect(success, true);
    bool val = await File(path.join(testDirectory, 'TextBox-HelloWorld', 'pptx',
            'TextBox-HelloWorld.pptx'))
        .exists();
    expect(val, isTrue);
  });

  test('Initializes directory structure as expected', () async {
    String testDirectory = await prepareTestDirectory('test1');
    ContentDirectoryGenerator generator = ContentDirectoryGenerator();
    String powerpointLocation = "$assetsFolder/TextBox-HelloWorld.pptx";
    Locale locale = Locale('en', 'US');
    bool success = await generator.initializeDirectory(
        powerpointLocation, locale, testDirectory);
    expect(success, true);
  });
}
