import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_parser/presentation_parser.dart';
import 'package:dart_parser/presentation_tree.dart';

void main() {
  final String assetsFolder = 'test/test_assets';

  group('Parser Tests', () {
    test('Parser - Single Textbox', () async {
      var filename = "TxtBox-HelloWorld.pptx";
      File file = File("$assetsFolder/$filename");

      PresentationParser parser = PresentationParser(file);

      PrsNode prsTree = parser.parsePresentation();
      Map<String, dynamic> astJson = prsTree.toJson();

      String pptText = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];

      expect(pptText, "Hello, World!");
    });

    test('Parser - Single Picture', () async{
      var filename = "Image-Snorlax.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      
      PrsNode prsTree = parser.parsePresentation();
      Map<String, dynamic> astJson = prsTree.toJson();

      String imagePath = astJson['presentation']['slides'][0]['shapes'][0]['path'];

      expect(imagePath, "../media/image1.png");
    });

    test('Parser - Multiple Pictures', () async{
      var filename = "Image-Snorlaxes.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      
      PrsNode prsTree = parser.parsePresentation();
      Map<String, dynamic> astJson = prsTree.toJson();

      String imagePath0 = astJson['presentation']['slides'][0]['shapes'][0]['path'];
      String imagePath1 = astJson['presentation']['slides'][0]['shapes'][1]['path'];
      String imagePath2 = astJson['presentation']['slides'][0]['shapes'][2]['path'];

      expect(imagePath0, "../media/image1.png");
      expect(imagePath1, "../media/image1.png");
      expect(imagePath2, "../media/image1.png");
    });



  });
}
