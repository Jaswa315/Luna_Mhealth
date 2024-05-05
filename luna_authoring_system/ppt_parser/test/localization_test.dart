import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';
import 'package:ppt_parser/module_text_elements.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';
import '../lib/enums/language_enums.dart';

const String assetsFolder = 'test/test_assets';
const String outputFolder = 'test/output';

// flutter test widget needs to be loaded
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");

  group('ModuleTextElements and TextElements Class Tests', () {
    setUpAll(() async {
      LogManager.createInstance();
      // Ensure the output directory exists
      await Directory(outputFolder).create(recursive: true);
    });

    tearDownAll(() async {
      // Clean up and remove the output directory after tests are done
      if (await Directory(outputFolder).exists()) {
        await Directory(outputFolder).delete(recursive: true);
      }
    });

    Future<ModuleTextElements> getElementsFromPPTX(var pptx_name) async {
      File file = File("$assetsFolder/$pptx_name");
      PresentationParser parser = PresentationParser(file);
      PrsNode prsTree = await parser.toPrsNode();
      String defaultLanguageWeUseForTests = Language.EN_US.code;
      ModuleTextElements moduleData = ModuleTextElements(prsTree, defaultLanguageWeUseForTests);
      return moduleData;
    }

    test('ModuleTextElements: A PPTX with 1 Text Box results in 1 token.',
        () async {
      ModuleTextElements moduleData =
          await getElementsFromPPTX("TextBox-HelloWorld.pptx");
      expect(moduleData.elements.length, 1);
    });

    test(
        'TextElement: A PPTX with 1 Text box has expected strings and assigned UID',
        () async {
      ModuleTextElements moduleData =
          await getElementsFromPPTX("TextBox-HelloWorld.pptx");
      TextElement? element = moduleData.elements[1];
      expect(element?.uid, 1);
      expect(element?.originalText, "Hello, World!");
    });

    test(
        'ModuleTextElements generateCSV - creates a CSV file in the specified directory',
        () async {
      // Setup the localization data
      ModuleTextElements moduleData =
          await getElementsFromPPTX("TextBox-HelloWorld.pptx");
      String csvFilePath = '$outputFolder/${moduleData.languageLocale}.csv';
      // Call generateCSV with the test output directory path
      await moduleData.generateCSV(moduleData.languageLocale, outputFolder);
      // Assert that the CSV file was created in the specified directory
      final csvFile = File(csvFilePath);
      expect(await csvFile.exists(), isTrue);
    });

    test('ModuleTextElements: A PPTX with 3 Text Boxes results in 13 tokens.',
        () async {
      ModuleTextElements moduleData =
          await getElementsFromPPTX("Textboxes.pptx");
      expect(moduleData.elements.length, 3);
    });

    test(
        'TextElement: A PPTX with 3 Text boxes has properly assigned Text Element strings, language, and UIDs.',
        () async {
      ModuleTextElements moduleData =
          await getElementsFromPPTX("Textboxes.pptx");
      TextElement? element = moduleData.elements[2];
      expect(element?.uid, 2);
      expect(element?.originalText, "Thing2");
      expect(element?.originalLanguageLocale, Language.EN_US.code);
    });
  });
}
