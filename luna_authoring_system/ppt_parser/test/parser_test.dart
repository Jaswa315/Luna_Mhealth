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
      expect(shapeType1, "line");
      expect(shapeType2, "line");
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

    test('Section has empty list for single section', () async {
      var filename = "TextBox-HelloWorld.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      Map<String, dynamic> section = astJson['presentation']['section'];

      expect(section, {
        "Default Section": [0]
      });
    });

    test('N Sections return a list of slides and section names', () async {
      var filename = "Sections.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      Map<String, dynamic> section = astJson['presentation']['section'];

      // Default Section : slide 1
      // Section 2: slide 2,3,4
      // Section 3:
      // Section 4: slide 5,6,7

      expect(section, {
        "Default Section": [0],
        "Section 2": [1, 2, 3],
        "Section 3": [],
        "Section 4": [4, 5, 6]
      });
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

    test('toJSON returns JSON file', () async {
      var filename = "Luna_sample_module.pptx";
      File file = File("$assetsFolder/$filename");
      PresentationParser parser = PresentationParser(file);

      File json = await parser.toJSON("./test_module.json");
      bool fileExists = json.existsSync();

      expect(fileExists, true);
    });

    test('Language is denoted as [language-Region]', () async {
      var filename = "A Texbox written in English in South Korea Region.pptx";
      Map<String, dynamic> astJson = await toMapFromPath(filename);

      String language = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['language'];

      expect(language, "en-KR");
    });

    test('Textboxes with different language have different languages',
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
  });

  group('Future Developments', () {
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
