import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';
import 'package:ppt_parser/localization.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';

const String assetsFolder = 'test/test_assets';
const String outputFolder = 'test/output';

// flutter test widget needs to be loaded
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");

  group('Localization and LocalizationElement Class Tests', () {
    late Localization localizationData;

    setUpAll(() {
      LogManager.createInstance();
    });

    Localization setUp(var filename) {
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      PrsNode prsTree = parser.parsePresentation();
      localizationData = Localization(prsTree, "en-US");
      return localizationData;
    }

    test(
        'Localization - 1 text token, Initialization, Size Test, and Lang Locale String Match',
        () async {
      localizationData = setUp("TxtBox-HelloWorld.pptx");
      expect(localizationData.elements.length, 1);
      expect(localizationData.elements[1]?.languageLocale, "en-US");
    });

    test('Localization Elements - Retrieve by Index 1 and check element data',
        () async {
      LocalizationTextElement? element = localizationData.elements[1];
      expect(element?.uid, 1);
      expect(element?.originalText, "Hello, World!");
    });

    test(
        'Localization generateCSV - creates a CSV file in the specified directory',
        () async {
      // Setup the localization data
      localizationData = setUp("TxtBox-HelloWorld.pptx");
      String csvFilePath =
          '$outputFolder/${localizationData.languageLocale}.csv';
      // Call generateCSV with the test output directory path
      await localizationData.generateCSV(
          localizationData.languageLocale, outputFolder);
      // Assert that the CSV file was created in the specified directory
      final csvFile = File(csvFilePath);
      expect(await csvFile.exists(), isTrue);
    });

    test(
        'Localization - 3 text tokens, Initialization, Size Test, and Lang Locale String Match',
        () async {
      localizationData = setUp("TxtBox-HelloWorlds.pptx");
      expect(localizationData.elements.length, 3);
      expect(localizationData.elements[1]?.languageLocale, "en-US");
    });

    test('Localization Elements - Retrieve Index 2 and check element data',
        () async {
      LocalizationTextElement? element = localizationData.elements[2];
      expect(element?.uid, 2);
      expect(element?.originalText, "Hello, World!");
    });
  });
}
