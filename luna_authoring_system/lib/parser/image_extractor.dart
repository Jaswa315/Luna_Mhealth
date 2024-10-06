import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'presentation_parser.dart';
import 'presentation_tree.dart';

/// A class to retrieve images from a presentation
class ImageExtractor {
  final PresentationParser _parser;

  /// Constructs a new instance of [ImageExtractor].
  ImageExtractor(this._parser);

  /// Extracts images from a a presentation and saves them to [outputDir]
  Future<void> extractImages(String outputDir) async {
    PresentationNode root = await _getPresentationNode();
    _extractImagesFromPresentation(root, outputDir);
  }

  /// Retrieves the PresentationNode from the given PresentationParser.
  ///
  /// The function calls the `toPrsNode` method of the parser to get the
  /// parsed node, and checks if it's an instance of `PresentationNode`.
  /// If it is, the node is returned, otherwise an exception is thrown.
  ///
  /// Parameters:
  /// - `parser`: An instance of `PresentationParser` that parses the presentation file.
  ///
  /// Returns:
  /// - A  `PresentationNode` instance.
  Future<PresentationNode> _getPresentationNode() async {
    PrsNode prsNode = await _parser.toPrsNode();
    if (prsNode is PresentationNode) {
      return prsNode;
    } else {
      throw Exception('Parsed node is not a PresentationNode');
    }
  }

  /// Extracts images from the given PresentationNode and saves them to the specified output directory.
  ///
  /// The function creates an `images` directory inside the specified `outputDir` if it doesn't exist.
  /// It then traverses the presentation tree, extracting image references and saving them to the `images` directory.
  ///
  /// Parameters:
  /// - `presentationNode`: The root node of the presentation tree.
  /// - `outputDir`: The directory where the images should be saved.
  void _extractImagesFromPresentation(
      PresentationNode presentationNode, String outputDir) {
    Directory imagesDir = Directory(p.join(outputDir, 'images'));
    if (!imagesDir.existsSync()) {
      imagesDir.createSync(recursive: true);
    }
    // Walk through the presentation tree and extract image references
    _walkTreeAndSaveImages(presentationNode, imagesDir.path, <String>{});
  }

  /// Recursively walks through the presentation tree and saves images found in the nodes.
  ///
  /// The function checks if the node is an instance of `ImageNode` and saves it if it hasn't been saved already.
  /// It then recursively processes the children of the node.
  ///
  /// Parameters:
  /// - `node`: The current node in the presentation tree.
  /// - `imagesDir`: The directory where the images should be saved.
  /// - `savedImages`: A set to keep track of already saved images to avoid duplicates.
  void _walkTreeAndSaveImages(
      PrsNode node, String imagesDir, Set<String> savedImages) {
    if (node is ImageNode) {
      _saveImageNode(node, imagesDir, savedImages);
    }

    for (var child in node.children) {
      _walkTreeAndSaveImages(child, imagesDir, savedImages);
    }
  }

  /// Saves the image node to the specified directory and ensures no duplicate images are saved.
  ///
  /// The function saves the image file along with its cropping information and alt text if provided.
  /// It updates the `savedImages` set to keep track of saved images.
  ///
  /// Parameters:
  /// - `node`: The image node to be saved.
  /// - `imagesDir`: The directory where the image should be saved.
  /// - `savedImages`: A set to keep track of already saved images to avoid duplicates.
  Future<void> _saveImageNode(
      ImageNode node, String imagesDir, Set<String> savedImages) async {
    if (!savedImages.contains(node.path)) {
      String imagePath = node.path;
      savedImages.add(imagePath);
      File imageFile = File(p.join(imagesDir, p.basename(imagePath)));

      String archiveFilePath = p.join('ppt/media', p.basename(imagePath));      

      ArchiveFile image = _parser.extractFileFromZip(archiveFilePath);
      imageFile.writeAsBytes(image.content as List<int>);
    }
  }
}
