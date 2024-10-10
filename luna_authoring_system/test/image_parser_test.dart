import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pptx_parser/parser/presentation_parser.dart';
import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:pptx_parser/parser/image_extractor.dart';
import 'dart:io';


const String assetsFolder = 'test/test_assets';
const String outputDirName = 'test/test_output';
const String pptxName = "Images.pptx";

/* TODO: fix function
Future<PresentationNode> toPresentationNodeFromPath(String fileName) async {
  File file = File("$assetsFolder/$fileName");
  PresentationParser parser = PresentationParser(file);
  return await getPresentationNode(parser);
}
*/

PresentationParser parser_example(String fileName){
    File file = File("$assetsFolder/$fileName");
    PresentationParser parser = PresentationParser(file);
    return parser;
}

void main() {
  group('Tests for the Image Parser', () {

    setUpAll(() {
      final outputDir = Directory(outputDirName);
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: false);
      }
    });

    test('An image is extracted', () async{
      PresentationParser newParser = parser_example(pptxName);
      ImageExtractor ie =  ImageExtractor(newParser);
      await ie.extractImages(outputDirName);
      expect(File('$outputDirName/images/image1.png').existsSync(), true);

    });
    test('An image is extracted when given Windows style paths', () async{
      var outputDirWindows = "test\\test_output";
      PresentationParser newParser = parser_example(pptxName);
      ImageExtractor ie =  ImageExtractor(newParser);
      await ie.extractImages(outputDirWindows);
      expect(File("$outputDirWindows/images/image1.png").existsSync(), true);

    });
    test('An Image has image path and cropping info', () async {
      /* TODO: fix test
      var filename = "Images.pptx";
      var outputDir = "./test_output";
      PresentationNode presentationNode =
          await toPresentationNodeFromPath(filename);
      extractImagesFromPresentation(presentationNode, outputDir);
      var extractedImageFile = File("$outputDir/images/image1.png");
      expect(extractedImageFile.existsSync(), true);

      var imageContent = extractedImageFile.readAsStringSync();
      expect(imageContent.contains("Image path:"), true);
      expect(imageContent.contains("Cropping info:"), true);
      */
    });

    test('N Images have image paths and cropping info', () async {
      /* TODO: fix test
      var filename = "Images.pptx";
      var outputDir = "./test_output";
      PresentationNode presentationNode =
          await toPresentationNodeFromPath(filename);
      extractImagesFromPresentation(presentationNode, outputDir);
      var imagePaths = [
        "$outputDir/images/image1.png",
        "$outputDir/images/image2.jpeg",
        "$outputDir/images/image3.jpeg"
      ];

      for (var imagePath in imagePaths) {
        var extractedImageFile = File(imagePath);
        expect(extractedImageFile.existsSync(), true);

        var imageContent = extractedImageFile.readAsStringSync();
        expect(imageContent.contains("Image path:"), true);
        expect(imageContent.contains("Cropping info:"), true);
      }
      */
    });

    test('Ensure no duplicate images are saved', () async {
      /* TODO: fix test
      var filename = "Images.pptx";
      var outputDir = "./test_output";
      PresentationNode presentationNode =
          await toPresentationNodeFromPath(filename);
      extractImagesFromPresentation(presentationNode, outputDir);
      var imagePaths = [
        "$outputDir/images/image1.png",
        "$outputDir/images/image2.jpeg",
        "$outputDir/images/image3.jpeg"
      ];

      var savedImages = <String>{};
      for (var imagePath in imagePaths) {
        var extractedImageFile = File(imagePath);
        expect(extractedImageFile.existsSync(), true);

        var imageContent = extractedImageFile.readAsStringSync();
        expect(imageContent.contains("Image path:"), true);
        expect(imageContent.contains("Cropping info:"), true);
        expect(savedImages.contains(imagePath), false);
        savedImages.add(imagePath);
      }
      */
    });

    test('Images retain alt text', () async {
      /* TODO: fix test
      var filename = "Images.pptx";
      var outputDir = "./test_output";
      PresentationNode presentationNode =
          await toPresentationNodeFromPath(filename);
      extractImagesFromPresentation(presentationNode, outputDir);
      var imagePaths = [
        "$outputDir/images/image1.png",
        "$outputDir/images/image2.jpeg",
        "$outputDir/images/image3.jpeg"
      ];

      for (var imagePath in imagePaths) {
        var extractedImageFile = File(imagePath);
        expect(extractedImageFile.existsSync(), true);

        var imageContent = extractedImageFile.readAsStringSync();
        expect(imageContent.contains("Image path:"), true);
        expect(imageContent.contains("Alt text:"), true);
        expect(imageContent.contains("Cropping info:"), true);
      }
      */
    });

    tearDown(() async {
      // clear out all files in the test output folder
      await clearTestFiles();
    });

    tearDownAll(() {
      // remove test output folder
      final testDirectory = Directory(outputDirName);
      if (testDirectory.existsSync()) {
        testDirectory.deleteSync(recursive: false);
      }
    });

  });
}

Future<void> clearTestFiles() async {
  final folder = Directory(outputDirName);
  if (await folder.exists()) {
    final entities = await folder.list(recursive: true).toList();
    for (var entity in entities) {
      if (entity is File) {
        try {
          await entity.delete();
        } catch (e) {}
      } else if (entity is Directory) {
        await entity.delete(recursive: true);
      }
    }
  }
}

