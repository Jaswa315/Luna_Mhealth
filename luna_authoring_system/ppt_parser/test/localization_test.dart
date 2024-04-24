import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';
import 'package:ppt_parser/localization.dart';

void main() {
  final String assetsFolder = 'test/test_assets';
  group('Localization and LocalizationElement Class Tests', () {
    Localization setUp(var filename) {
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      PrsNode prsTree = parser.parsePresentation();
      Localization localization_data = Localization(prsTree, "en-US");
      return localization_data;
    }

    setUpAll(() {
      // we will do a test directory for CSV in the future
      // ** TO DO ** //
      // final testDirectory = Directory(kApplicationDocumentsPath);
      // USE SHAUN'S TESTS FOR REFERENCE!
    });

    late Localization localization_data;

    test(
        'Localization - Size 1, Initialization, Size Test, and Lang Locale String Match',
        () async {
      localization_data = setUp("TxtBox-HelloWorld.pptx");
      expect(localization_data.elements.length, 1);
      expect(localization_data.elements[1]?.languageLocale, "en-US");
    });

    test('Localization Elements - Retrieve by Index 1 and check element data', () async {
      LocalizationTextElement? element = localization_data.elements[1];
      expect(element?.uid, 1);
      expect(element?.originalText, "Hello, World!");
    });

    //   test(
    //       'Localization CSV was generated',
    //       () async {
    //     localization_data.generateCSV('/test_assets/res.csv');
    //     // Path to the file we expect to exist
    //     var expectedFilePath = 'test_assets/res.csv';

    //     // Use File class to check for existence
    //     var file = File(expectedFilePath);
    //     expect(await file.exists(), isTrue);
    //   });

    test('Localization - Size 3, Initialization, Size Test, and Lang Locale String Match', () async {
      localization_data = setUp("TxtBox-HelloWorlds.pptx");
      expect(localization_data.elements.length, 3);
      expect(localization_data.elements[1]?.languageLocale, "en-US");
    });

    test(
        'Localization Elements - Retrieve Index 2 and check element data',
        () async {
      LocalizationTextElement? element = localization_data.elements[2];
      expect(element?.uid, 2);
      expect(element?.originalText, "Hello, World!");
    });
  });
}
