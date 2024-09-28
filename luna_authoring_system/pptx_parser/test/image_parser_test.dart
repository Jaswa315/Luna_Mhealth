import 'package:flutter_test/flutter_test.dart';

const String assetsFolder = 'test/test_assets';

/* TODO: fix function
Future<PresentationNode> toPresentationNodeFromPath(String fileName) async {
  File file = File("$assetsFolder/$fileName");
  PresentationParser parser = PresentationParser(file);
  return await getPresentationNode(parser);
}
*/

void main() {
  group('Tests for the Image Parser', () {
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
  });
}
