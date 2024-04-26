import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';
import 'package:ppt_parser/module_text_elements.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';

const String assetsFolder = 'test/test_assets';
const String outputFolder = 'test/output';

// flutter test widget needs to be loaded
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");

  group('ModuleTextElements and TextElements Class Tests', () {
    setUpAll(() {
      LogManager.createInstance();
    });

    ModuleTextElements getElementsFromPPTX(var pptx_name) {
      File file = File("$assetsFolder/$pptx_name");
      PresentationParser parser = PresentationParser(file);
      PrsNode prsTree = parser.parsePresentation();
      ModuleTextElements module_data = ModuleTextElements(prsTree, "en-US");
      return module_data;
    }

    test('ModuleTextElements: A PPTX with 1 Text Box results in 1 token.',
        () async {
      ModuleTextElements module_data =
          getElementsFromPPTX("TxtBox-HelloWorld.pptx");
      expect(module_data.elements.length, 1);
    });

    test(
        'TextElement: A PPTX with 1 Text box has expected strings and assigned UID',
        () async {
      ModuleTextElements module_data =
          getElementsFromPPTX("TxtBox-HelloWorld.pptx");
      TextElement? element = module_data.elements[1];
      expect(element?.uid, 1);
      expect(element?.originalText, "Hello, World!");
    });

    test(
        'ModuleTextElements generateCSV - creates a CSV file in the specified directory',
        () async {
      // Setup the localization data
      ModuleTextElements module_data =
          getElementsFromPPTX("TxtBox-HelloWorld.pptx");
      String csvFilePath = '$outputFolder/${module_data.languageLocale}.csv';
      // Call generateCSV with the test output directory path
      await module_data.generateCSV(module_data.languageLocale, outputFolder);
      // Assert that the CSV file was created in the specified directory
      final csvFile = File(csvFilePath);
      expect(await csvFile.exists(), isTrue);
    });

    test('ModuleTextElements: A PPTX with 3 Text Boxes results in 13 tokens.',
        () async {
      ModuleTextElements module_data =
          getElementsFromPPTX("TxtBox-HelloWorlds.pptx");
      expect(module_data.elements.length, 3);
    });

    test(
        'TextElement: A PPTX with 3 Text boxes has properly assigned Text Element strings and UIDs.',
        () async {
      ModuleTextElements module_data =
          getElementsFromPPTX("TxtBox-HelloWorlds.pptx");
      TextElement? element = module_data.elements[2];
      expect(element?.uid, 2);
      expect(element?.originalText, "Hello, World!");
    });
  });
}
