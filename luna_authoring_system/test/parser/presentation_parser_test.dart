// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'package:luna_authoring_system/parser/presentation_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/types.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';

const String assetsFolder = 'test/test_assets';

Future<Json> toMapFromPath(String fileName) async {
  File file = File("$assetsFolder/$fileName");
  PresentationParser parser = PresentationParser(file);
  return parser.toMap();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await GlobalConfiguration().loadFromAsset("app_settings");
    await LogManager.createInstance();
  });

  group('Tests for the PPTX Parser', () {
    test('A Textbox has content', () async {
      // Arrange
      var filename = "TextBox-HelloWorld.pptx";
      Json astJson = await toMapFromPath(filename);

      // Act
      String pptText = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['text'];

      // Assert
      expect(pptText, "Hello, World!");
    });

    test('N Textboxes have contents', () async {
      var filename = "TextBoxes.pptx";
      Json astJson = await toMapFromPath(filename);
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
      Json astJson = await toMapFromPath(filename);

      String imagePath =
          astJson['presentation']['slides'][0]['shapes'][0]['path'];

      expect(imagePath, "../media/image1.png");
    });

    test('N Images has image paths', () async {
      var filename = "Images.pptx";
      Json astJson = await toMapFromPath(filename);

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
      Json astJson = await toMapFromPath(filename);

      String shapeType =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];

      expect(shapeType, "line");
    });

    test('N Geometries have its own type', () async {
      var filename = "Shapes-Geometries.pptx";
      Json astJson = await toMapFromPath(filename);

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
      Json astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][2]['type'];
      String shapeType1 =
          astJson['presentation']['slides'][1]['shapes'][2]['type'];

      expect(shapeType0, "rectangle");
      expect(shapeType1, "ellipse");
    });

    test('Section has default section if the pptx file has no section',
        () async {
      var filename = "TextBox-HelloWorld.pptx";
      Json astJson = await toMapFromPath(filename);

      Json section = astJson['presentation']['section'];

      expect(section.keys.toList()[0], "Default Section");
    });

    test('N Sections return a list of slides and section names', () async {
      var filename = "Sections.pptx";
      Json astJson = await toMapFromPath(filename);
      Json section = astJson['presentation']['section'];
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
      Json astJson = await toMapFromPath(filename);

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
      Json astJson = await toMapFromPath(filename);

      int lenShapes = astJson['presentation']['slides'][0]['shapes'].length;

      expect(lenShapes, 0);
    });

    test('alt-text with line breaks is parsed without any error', () async {
      var filename = "Alt-txt-3Lines.pptx";
      Json astJson = await toMapFromPath(filename);

      String altText =
          astJson['presentation']['slides'][0]['shapes'][0]['alttext'];

      expect(altText,
          "A group of people outside of a building\n\nDescription automatically generated");
    });

    test('Same slides from the same file have the same slide id', () async {
      var filename1 = "Slide 1 and 2.pptx";
      var filename2 = "Slide 2 and 1.pptx";
      Json astJson1 = await toMapFromPath(filename1);
      Json astJson2 = await toMapFromPath(filename2);

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
      Json astJson = await toMapFromPath(filename);
      int slideCount = astJson['presentation']['slideCount'];
      Json section = astJson['presentation']['section'];

      var slideIdList = section.values.toList();
      List<dynamic> total = [];
      for (List<dynamic> subList in slideIdList) {
        total.addAll(subList);
      }
      Set<dynamic> uniqueId = total.toSet();
      int uniqueCount = uniqueId.length;

      expect(uniqueCount, slideCount);
    });

    test('Audio is parsed for each shapes', () async {
      var filename = "Audios in Shapes.pptx";
      Json astJson = await toMapFromPath(filename);

      String audioPath0 =
          astJson['presentation']['slides'][0]['shapes'][0]['audiopath'];
      String audioPath1 =
          astJson['presentation']['slides'][0]['shapes'][1]['audiopath'];
      String audioPath2 =
          astJson['presentation']['slides'][0]['shapes'][2]['audiopath'];
      String audioPath3 =
          astJson['presentation']['slides'][0]['shapes'][3]['audiopath'];

      // mp3 is media
      expect(audioPath0.contains('media'), true);
      // wav is audio
      expect(audioPath1.contains('audio'), true);
      expect(audioPath2.contains('audio'), true);
      expect(audioPath3.contains('audio'), true);
    });

    test('5 types of hyperlinks in Vanilla Shape are in hyperlink property',
        () async {
      var filename = "Hyperlinks-Shape.pptx";
      Json astJson = await toMapFromPath(filename);

      int hyperlink0 =
          astJson['presentation']['slides'][1]['shapes'][0]['hyperlink'];
      int hyperlink1 =
          astJson['presentation']['slides'][1]['shapes'][1]['hyperlink'];
      int hyperlink2 =
          astJson['presentation']['slides'][1]['shapes'][2]['hyperlink'];
      int hyperlink3 =
          astJson['presentation']['slides'][1]['shapes'][3]['hyperlink'];
      int hyperlink4 =
          astJson['presentation']['slides'][1]['shapes'][4]['hyperlink'];
      int hyperlink5 =
          astJson['presentation']['slides'][1]['shapes'][5]['hyperlink'];

      expect(hyperlink0, 1);
      expect(hyperlink1, 4);
      expect(hyperlink2, 1);
      expect(hyperlink3, 4);
      expect(hyperlink4, 3);
      expect(hyperlink5, 3);
    });

    test('5 types of hyperlinks in Text are in hyperlink property', () async {
      var filename = "Hyperlinks-Text.pptx";
      Json astJson = await toMapFromPath(filename);

      int hyperlink0 = astJson['presentation']['slides'][1]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][1]['hyperlink'];
      int hyperlink1 = astJson['presentation']['slides'][1]['shapes'][1]
          ['children'][1]['paragraphs'][0]['textgroups'][1]['hyperlink'];
      int hyperlink2 = astJson['presentation']['slides'][1]['shapes'][2]
          ['children'][1]['paragraphs'][0]['textgroups'][1]['hyperlink'];
      int hyperlink3 = astJson['presentation']['slides'][1]['shapes'][3]
          ['children'][1]['paragraphs'][0]['textgroups'][1]['hyperlink'];
      int hyperlink4 = astJson['presentation']['slides'][1]['shapes'][4]
          ['children'][1]['paragraphs'][0]['textgroups'][1]['hyperlink'];

      expect(hyperlink0, 3);
      expect(hyperlink1, 1);
      expect(hyperlink2, 1);
      expect(hyperlink3, 1);
      expect(hyperlink4, 7);
    });

    test('5 types of hyperlinks in TextBox are in hyperlink property',
        () async {
      var filename = "Hyperlinks-TextBox.pptx";
      Json astJson = await toMapFromPath(filename);

      int hyperlink0 =
          astJson['presentation']['slides'][1]['shapes'][0]['hyperlink'];
      int hyperlink1 =
          astJson['presentation']['slides'][1]['shapes'][1]['hyperlink'];
      int hyperlink2 =
          astJson['presentation']['slides'][1]['shapes'][2]['hyperlink'];
      int hyperlink3 =
          astJson['presentation']['slides'][1]['shapes'][3]['hyperlink'];
      int hyperlink4 =
          astJson['presentation']['slides'][1]['shapes'][4]['hyperlink'];

      expect(hyperlink0, 4);
      expect(hyperlink1, 1);
      expect(hyperlink2, 3);
      expect(hyperlink3, 1);
      expect(hyperlink4, 4);
    });

    test('5 types of hyperlinks in Image are in hyperlink property', () async {
      var filename = "Hyperlinks-Image.pptx";
      Json astJson = await toMapFromPath(filename);

      int hyperlink0 =
          astJson['presentation']['slides'][1]['shapes'][0]['hyperlink'];
      int hyperlink1 =
          astJson['presentation']['slides'][1]['shapes'][1]['hyperlink'];
      int hyperlink2 =
          astJson['presentation']['slides'][1]['shapes'][2]['hyperlink'];
      int hyperlink3 =
          astJson['presentation']['slides'][1]['shapes'][3]['hyperlink'];
      int hyperlink4 =
          astJson['presentation']['slides'][1]['shapes'][4]['hyperlink'];

      expect(hyperlink0, 1);
      expect(hyperlink1, 4);
      expect(hyperlink2, 3);
      expect(hyperlink3, 1);
      expect(hyperlink4, 3);
    });

    test('Edgecases of hyperlinks are not parsed', () async {
      var filename = "Hyperlinks-Edgecases.pptx";
      Json astJson = await toMapFromPath(filename);

      int? hyperlink0 = astJson['presentation']['slides'][0]['hyperlink'];
      int? hyperlink1 = astJson['presentation']['slides'][1]['hyperlink'];

      expect(hyperlink0, null);
      expect(hyperlink1, null);
    });

    test('Basic shapes with texts have text content', () async {
      var filename = "Ellipse and rectangle shapes with textbox.pptx";
      Json astJson = await toMapFromPath(filename);

      String shapeType0 =
          astJson['presentation']['slides'][0]['shapes'][0]['type'];
      String text0 = astJson['presentation']['slides'][0]['shapes'][0]
          ['textBody']['paragraphs'][0]['textgroups'][0]['text'];
      String shapeType1 =
          astJson['presentation']['slides'][0]['shapes'][1]['type'];
      String text1 = astJson['presentation']['slides'][0]['shapes'][1]
          ['textBody']['paragraphs'][0]['textgroups'][0]['text'];

      expect(shapeType0, "ellipse");
      expect(shapeType1, "rectangle");
      expect(text0, "text1");
      expect(text1, "text2");
    });

    test('A Textbox has UID of 1', () async {
      // Arrange
      var filename = "TextBox-HelloWorld.pptx";
      Json astJson = await toMapFromPath(filename);

      // Act
      int pptUID = astJson['presentation']['slides'][0]['shapes'][0]['children']
          [1]['paragraphs'][0]['textgroups'][0]['uid'];

      // Assert
      expect(pptUID, 1);
    });

    test('N Textboxes have assigned UIDs', () async {
      var filename = "TextBoxes.pptx";
      Json astJson = await toMapFromPath(filename);
      int pptUID0 = astJson['presentation']['slides'][0]['shapes'][0]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['uid'];

      int pptUID1 = astJson['presentation']['slides'][0]['shapes'][1]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['uid'];

      int pptUID2 = astJson['presentation']['slides'][0]['shapes'][2]
          ['children'][1]['paragraphs'][0]['textgroups'][0]['uid'];

      expect(pptUID0, 1);
      expect(pptUID1, 2);
      expect(pptUID2, 3);
    });
  });
}
