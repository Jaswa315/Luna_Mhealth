import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';
import 'package:ppt_parser/main.dart';

void main() {
  
  final String assetsFolder = 'test/test_assets';
  group('Localization Class Tests: One textbox', () {
// Initial Set up
    var filename = "TxtBox-HelloWorld.pptx";
    File file = File("$assetsFolder/$filename");
    PresentationParser parser = PresentationParser(file);
    PrsNode prsTree = parser.parsePresentation();

    late Localization localization_data;

    test('Build Localization class: Short slide', () async {
      //hard coded en-US for testing purposes (UPDATE LATER)
      localization_data = Localization(prsTree, "en-US");
      expect(localization_data.elements.length, 1);
      expect(localization_data.elements[1]?.languageLocale, "en-US");
    });

    test(
        'LocalizationText Element made from Localization: First Element of short slide',
        () async {
      LocalizationTextElement? element = localization_data.elements[1];
      expect(element?.uid, 1);
      expect(element?.original, "Hello, World!");
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
  });

  group('Localization Class Tests: Three textbox', () {
// Initial Set up
    var filename = "TxtBox-HelloWorlds.pptx";
    File file = File("$assetsFolder/$filename");
    PresentationParser parser2 = PresentationParser(file);
    PrsNode prsTree = parser2.parsePresentation();

    late Localization localization_data;

    test('Build Localization class: Three textbox', () async {
      localization_data = Localization(prsTree, "en-US");
      expect(localization_data.elements.length, 3);
      expect(localization_data.elements[1]?.languageLocale, "en-US");
    });

    test(
        'LocalizationText Element made from Localization: Third Element of short slide',
        () async {
      LocalizationTextElement? element = localization_data.elements[2];
      expect(element?.uid, 2);
      expect(element?.original, "Hello, World!");
    });
  });
}
