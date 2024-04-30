// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';
import 'dart:convert';

const String assetsFolder = 'test/test_assets';

Future<Map<String, dynamic>> toMapFromPath(String fileName) async {
  File file = File("$assetsFolder/$fileName");
  PresentationParser parser = PresentationParser(file);
  return parser.toMap();
}

void main() {
  group('Tests for the PPTX Parser', () {
    test('A Textbox has content', () async {
      // Arrange
      var filename = "TextBox-HelloWorld.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      // Act
      String pptText = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];

      // Assert
      expect(pptText, "Hello, World!");
    });

    test('N Textboxes have contents', () async {
      var filename = "TextBoxes.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String pptText0 = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];

      String pptText1 = astJson['presentation']['slides'][0]['shapes'][1]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];

      String pptText2 = astJson['presentation']['slides'][0]['shapes'][2]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];

      expect(pptText0, "Thing1");
      expect(pptText1, "Thing2");
      expect(pptText2, "Thing3");
    });

    test('An Image has image path', () async {
      var filename = "Image-Snorlax.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String imagePath =
          astJson['presentation']['slides'][0]['shapes'][0]['path'];

      expect(imagePath, "../media/image1.png");
    });

    test('N Images has image paths', () async {
      var filename = "Images.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String imagePath0 =
          astJson['presentation']['slides'][0]['shapes'][0]['path'];
      String imagePath1 =
          astJson['presentation']['slides'][0]['shapes'][1]['path'];
      String imagePath2 =
          astJson['presentation']['slides'][0]['shapes'][2]['path'];

      expect(imagePath0, "../media/image1.png");
      expect(imagePath1, "../media/image2.jpeg");
      expect(imagePath2, "../media/image3.jpeg");
    });

    test('A Connection Shape is parsed as line', () async {
      var filename = "Shapes-Connection.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String shapeType =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];

      expect(shapeType, "line");
    });

    test('N Geometries have its own type', () async {
      var filename = "Shapes-Geometries.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String shapeType1 =
          astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String shapeType2 =
          astJson['presentation']['slides'][0]['shapes'][2]['type'];
      String shapeType3 =
          astJson['presentation']['slides'][0]['shapes'][3]['type'];

      expect(shapeType0, "line");
      expect(shapeType1, "ellipse");
      expect(shapeType2, "rectangle");
      expect(shapeType3, "ellipse");
    });

    test('Z Order of shapes is preserved sequentially', () async {
      var filename = "Order.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][2]['type'];
      String shapeType1 =
          astJson['presentation']['slides'][1]['shapes'][2]['type'];

      expect(shapeType0, "rectangle");
      expect(shapeType1, "ellipse");
    });

    test('Section has empty section has default section', () async {
      var filename = "TextBox-HelloWorld.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      Map<String, dynamic> section = astJson['presentation']['section'];

      expect(section.keys.toList()[0], "Default Section");
    });

    test('N Sections return a list of slides and section names', () async {
      var filename = "Sections.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);
      Map<String, dynamic> section = astJson['presentation']['section'];
      var slideIdList = section.values.toList();

      // Default Section : slide 1
      // Section 2: slide 2,3,4
      // Section 3:
      // Section 4: slide 5,6,7

      expect(slideIdList[0].length, 1);
      expect(slideIdList[1].length, 3);
      expect(slideIdList[2].length, 0);
      expect(slideIdList[3].length, 3);
    });

    test('Geometries are parsed with correct types', () async {
      var filename = "Shapes-Pictures-Texts-Lines.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String shapeType1 =
          astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String shapeType2 =
          astJson['presentation']['slides'][0]['shapes'][2]['type'];
      String shapeType3 =
          astJson['presentation']['slides'][0]['shapes'][3]['type'];
      String shapeType4 =
          astJson['presentation']['slides'][0]['shapes'][4]['type'];
      String shapeType5 =
          astJson['presentation']['slides'][0]['shapes'][5]['type'];
      String shapeType6 =
          astJson['presentation']['slides'][0]['shapes'][6]['type'];

      expect(shapeType0, "rectangle");
      expect(shapeType1, "rectangle");
      expect(shapeType2, "ellipse");
      expect(shapeType3, "ellipse");
      expect(shapeType4, "textbox");
      expect(shapeType5, "image");
      expect(shapeType6, "line");
    });

    test('Empty PPTX has 0 shapes', () async {
      var filename = "Empty.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      int lenShapes = astJson['presentation']['slides'][0]['shapes'].length;

      expect(lenShapes, 0);
    });

    test('alt-text with line breaks is parsed without any error', () async {
      var filename = "Alt-txt-3Lines.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String altText =
          astJson['presentation']['slides'][0]['shapes'][0]['alttext'];

      expect(altText,
          "A group of people outside of a building\n\nDescription automatically generated");
    });

    test('Language is denoted as [language-Region]', () async {
      var filename = "A Texbox written in English in South Korea Region.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String language = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['language'];

      expect(language, "en-KR");
    });

    test('Textboxes with different language have different [language-region]',
        () async {
      var filename = "Two Textboxes in English and Korean.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String language1 = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['language'];
      String language2 = astJson['presentation']['slides'][0]['shapes'][1]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['language'];

      expect(language1.substring(0, 2), "ko");
      expect(language2.substring(0, 2), "en");
    });

    test('Same slides from the same file have the same slide id', () async {
      var filename1 = "Slide 1 and 2.pptx";
      var filename2 = "Slide 2 and 1.pptx";
      Map<String, dynamic> astJson1 = await toMapFromPath(filename1);
      Map<String, dynamic> astJson2 = await toMapFromPath(filename2);

      String pptx1slide1 = astJson1['presentation']['slides'][0]['slideId'];
      String pptx1slide2 = astJson1['presentation']['slides'][1]['slideId'];
      String pptx2slide1 = astJson2['presentation']['slides'][0]['slideId'];
      String pptx2slide2 = astJson2['presentation']['slides'][1]['slideId'];

      expect(pptx1slide1, pptx2slide2);
      expect(pptx1slide2, pptx2slide1);
    });

    test('Every slide has different slideId even if some slides are duplicated',
        () async {
      var filename = "Duplicated Slides.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);
      int slideCount = astJson['presentation']['slideCount'];
      Map<String, dynamic> section = astJson['presentation']['section'];
      
      var slideIdList = section.values.toList();
      List<dynamic> total = [];
      for (List<dynamic> subList in slideIdList){
        total.addAll(subList);
      }
      Set<dynamic> uniqueId = total.toSet();
      int uniqueCount = uniqueId.length;

      expect(uniqueCount, slideCount);
    });

    test('Position values are described as percentages', () async {
      var filename = "Image-Snorlax.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);
      File json = await parser.toJSON("./test_module.json");
      String jsonString = json.readAsStringSync();

      Map<String, dynamic> astJson = jsonDecode(jsonString);
      double offsetX = astJson['presentation']['slides'][0]['shapes'][0]
          ['shapes'][0]['offset']['x'];
      double offsetY = astJson['presentation']['slides'][0]['shapes'][0]
          ['shapes'][0]['offset']['y'];
      double sizeX = astJson['presentation']['slides'][0]['shapes'][0]['shapes']
          [0]['size']['x'];
      double sizeY = astJson['presentation']['slides'][0]['shapes'][0]['shapes']
          [0]['size']['y'];

      bool isPercentage(x) {
        if (x >= 0 && x <= 100) {
          return true;
        } else {
          return false;
        }
      }

      expect(isPercentage(offsetX), true);
      expect(isPercentage(offsetY), true);
      expect(isPercentage(sizeX), true);
      expect(isPercentage(sizeY), true);
    });

    test('toJSON returns JSON file', () async {
      var filename = "Luna_sample_module.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);

      File json = await parser.toJSON("./test_module.json");
      bool fileExists = json.existsSync();

      expect(fileExists, true);
    });
  });

  group('TODO', () {
    test(
        'The slide size should be the size of the content-module, not the game editor',
        () async {
      var filename1 = "content and game editor.pptx";
      var filename2 = "game editor and content.pptx";
      Map<String, dynamic> astJson1 = await toMapFromPath(filename1);
      Map<String, dynamic> astJson2 = await toMapFromPath(filename2);

      String x1 = astJson1['presentation'];
      String x2 = astJson2['presentation'];

      expect(x1, 1);
      expect(x2, 1);
    });
    test('Hyperlink that goes to next slide uses jump=nextslide', () async {
      var filename = "Two slides with next slide hyperlink text.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      // presentationMap > p:presentation > p:sldIdLst > p;sldId > List

      // https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oi29500/a65b76db-6abc-4989-8cd1-baa9a3500f6f

      // in text,
      // json["a:rPr"]["a:hlinkClick"]["_action"] is "ppaction://hlinkshowjump?jump=nextslide";

      // String language1 = astJson['presentation']['slides'][0]['shapes'][0]
      //     ['children'][1]['paragraphs'][0]['textgroups'][0]['language'];

      // expect(language1.substring(0, 2), "ko");
    });

    test('Hyperlink that goes to specific slide uses rId', () async {
      var filename = "Two slides with designated hyperlink text.pptx";
      var filename2 = "mixed.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);
      Map<String, dynamic> astJson2 = await toMapFromPath(filename2);

      // We need mapping

      // presentationMap > p:presentation > p:sldIdLst > p;sldId > List
      // in text,
      // json["a:rPr"]["a:hlinkClick"]["_action"] is "ppaction://hlinksldjump";
      // json["a:rPr"]["a:hlinkClick"][]"_r:id"] is "rId2"

      // in the slide1.xml.rels, >> parse at [parseSlide]
      // where the hypertext lies,
      // "ppt/slides/_rels/slide1.xml.rels"
      // ["Relationships"]["Relationship"] is List, (or just Map) I assume.
      // we have to check "_Target" where "_Id" is rId2
      // In this case, hyperlink goes to slide 2,
      // So, "_Target" is "slide2.xml"

      // 1. So, for each text, we need to know which slide it is in.
      // 2. we go to "ppt/slides/_rels/slide1.xml.rels", and check the "_Target".

      // String language1 = astJson['presentation']['slides'][0]['shapes'][0]
      //     ['children'][1]['paragraphs'][0]['textgroups'][0]['language'];

      // expect(language1.substring(0, 2), "ko");
    });
    test('Hyperlink that goes to specific slide uses rId', () async {
      var filename = "Luna content module + template.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      // We need mapping

      // presentationMap > p:presentation > p:sldIdLst > p;sldId > List
      // in text,
      // json["a:rPr"]["a:hlinkClick"]["_action"] is "ppaction://hlinksldjump";
      // json["a:rPr"]["a:hlinkClick"][]"_r:id"] is "rId2"

      // in the slide1.xml.rels, >> parse at [parseSlide]
      // where the hypertext lies,
      // "ppt/slides/_rels/slide1.xml.rels"
      // ["Relationships"]["Relationship"] is List, (or just Map) I assume.
      // we have to check "_Target" where "_Id" is rId2
      // In this case, hyperlink goes to slide 2,
      // So, "_Target" is "slide2.xml"

      // 1. So, for each text, we need to know which slide it is in.
      // 2. we go to "ppt/slides/_rels/slide1.xml.rels", and check the "_Target".

      // String language1 = astJson['presentation']['slides'][0]['shapes'][0]
      //     ['children'][1]['paragraphs'][0]['textgroups'][0]['language'];

      // expect(language1.substring(0, 2), "ko");
    });
  });

  group('Non MVP', () {
    //TODO: Title and body text parser
    test('Title and body are in the textbox', () async {
      var filename = "Title and body.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String shapeType1 =
          astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String shapeType2 =
          astJson['presentation']['slides'][0]['shapes'][2]['type'];

      expect(shapeType0, "line");
      expect(shapeType1, "ellipse");
      expect(shapeType2, "image");
    });

    //TODO: Shape txBody parsing
    test('Texts in the shape are parsed into its property', () async {
      var filename = "Title and body.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);
    });

    //TODO: Shape txBody parsing: empty text

    test('N Connection Shapes are parsed as line', () async {
      var filename = "Shapes-Connections.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String shapeType1 =
          astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String shapeType2 =
          astJson['presentation']['slides'][0]['shapes'][2]['type'];

      expect(shapeType0, "line");
      expect(shapeType1, "curvedConnector3");
      expect(shapeType2, "bentConnector3");
    });

    test('Vanilla shapes with texts have text content', () async {
      var filename = "Ellipse and rectangle shapes with textbox.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String text0 = astJson['presentation']['slides'][0]['shapes'][0]
          ['textbox']['paragraphs'][0]['textgroups'][0]['text'];
      String shapeType1 =
          astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String text1 = astJson['presentation']['slides'][0]['shapes'][1]
          ['textbox']['paragraphs'][0]['textgroups'][0]['text'];

      expect(shapeType0, "ellipse");
      expect(shapeType1, "rectangle");
      expect(text0, "text1");
      expect(text1, "text2");
    });

    test('connection shape and shape are parsed as a different object',
        () async {
      var filename =
          "A Shape with Textbox - A vanilla shape - a connection shape.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String shapeType1 =
          astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String shapeType2 =
          astJson['presentation']['slides'][0]['shapes'][2]['type'];

      expect(shapeType0, "line");
      expect(shapeType1, "ellipse");
      expect(shapeType2, "rectangle");
    });
  });
}
