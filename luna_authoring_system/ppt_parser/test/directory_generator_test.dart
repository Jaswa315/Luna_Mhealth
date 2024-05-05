import 'dart:io';
import 'package:ppt_parser/content_directory_generator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:luna_mhealth_mobile/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';
import '../lib/enums/language_enums.dart';

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
      'Content Directory Generator: Initializing a directory has the inputted language directory with a CSV file',
      () async {
    String testDirectory = await prepareTestDirectory('test3');
    ContentDirectoryGenerator generator = ContentDirectoryGenerator();
    String pptxName = "TextBox-HelloWorld";
    String powerpointLocation = "$assetsFolder/$pptxName.pptx";
    String language = Language.EN_US.code;
    bool success = await generator.initializeDirectory(
        powerpointLocation, language, testDirectory);
    expect(success, true);
    String csvFilePath = await path.join(testDirectory, pptxName, 'module', 'resources', language, '$language.csv');
    File CSV = await File(csvFilePath);
    bool res = await CSV.exists();
    expect(res, isTrue, reason: 'CSV file should exist at $csvFilePath');
    await Future.delayed(Duration(seconds: 2));
  });
  test('Initializes directory structure as expected', () async {
    String testDirectory = await prepareTestDirectory('test1');
    ContentDirectoryGenerator generator = ContentDirectoryGenerator();
    String powerpointLocation = "$assetsFolder/TextBox-HelloWorld.pptx";
    String language = Language.EN_US.code;
    bool success = await generator.initializeDirectory(
        powerpointLocation, language, testDirectory);
    expect(success, true);
  });

  test(
      'Initializing a directory copies given the PowerPoint to specific location',
      () async {
    String testDirectory = await prepareTestDirectory('test2');
    ContentDirectoryGenerator generator = ContentDirectoryGenerator();
    String powerpointLocation = "$assetsFolder/TextBox-HelloWorld.pptx";
    String language = Language.EN_US.code;
    bool success = await generator.initializeDirectory(
        powerpointLocation, language, testDirectory);
    expect(success, true);
    bool val = await File(path.join(testDirectory, 'TextBox-HelloWorld', 'pptx', 'TextBox-HelloWorld.pptx')).exists();
    expect(val, isTrue);
  });

}
