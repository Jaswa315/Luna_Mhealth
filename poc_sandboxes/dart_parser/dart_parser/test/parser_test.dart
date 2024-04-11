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

    test('Parser - Multiple Textboxes', () async {
      var filename = "TxtBox-HelloWorlds.pptx";
      File file = File("$assetsFolder/$filename");

      PresentationParser parser = PresentationParser(file);

      PrsNode prsTree = parser.parsePresentation();
      Map<String, dynamic> astJson = prsTree.toJson();

      String pptText0 = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];

      String pptText1 = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];

      String pptText2 = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];  

      expect(pptText0, "Hello, World!");
      expect(pptText1, "Hello, World!");
      expect(pptText2, "Hello, World!");
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

    test('Parser - Single Connection Shape', () async{
      var filename = "Shapes-Connection.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      
      PrsNode prsTree = parser.parsePresentation();
      Map<String, dynamic> astJson = prsTree.toJson();

      String shapeType = astJson['presentation']['slides'][0]['shapes'][0]['type'];

      expect(shapeType, "line");
    });

    test('Parser - Multiple Connection Shapes', () async{
      var filename = "Shapes-Connections.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      
      PrsNode prsTree = parser.parsePresentation();
      Map<String, dynamic> astJson = prsTree.toJson();

      String shapeType0 = astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String shapeType1 = astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String shapeType2 = astJson['presentation']['slides'][0]['shapes'][2]['type'];

      expect(shapeType0, "line");
      expect(shapeType1, "line");
      expect(shapeType2, "line");
    });

    test('Parser - Geometries', () async{
      var filename = "Shapes-Geometries.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      
      PrsNode prsTree = parser.parsePresentation();
      Map<String, dynamic> astJson = prsTree.toJson();

      String shapeType0 = astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String shapeType1 = astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String shapeType2 = astJson['presentation']['slides'][0]['shapes'][2]['type'];
      String shapeType3 = astJson['presentation']['slides'][0]['shapes'][3]['type'];

      expect(shapeType0, "line");
      expect(shapeType1, "ellipse");
      expect(shapeType2, "rectangle");
      expect(shapeType3, "ellipse");
    });

    test('Parser - Order', () async{
      var filename = "Order.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      
      PrsNode prsTree = parser.parsePresentation();
      Map<String, dynamic> astJson = prsTree.toJson();

      String shapeType0 = astJson['presentation']['slides'][0]['shapes'][2]['type'];
      String shapeType1 = astJson['presentation']['slides'][1]['shapes'][2]['type'];

      expect(shapeType0, "rectangle");
      expect(shapeType1, "ellipse");
    });

  });
}
