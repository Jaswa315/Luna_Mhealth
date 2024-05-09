import 'dart:io';
import 'dart:ui';
import 'presentation_tree.dart';
import 'package:path/path.dart' as path;

/// The CSVGenerator class allows creation of CSV Files from a Presentation Data Tree as input
/// 
/// CSVGenerator simply walks a Presentation Tree, and for every text node will create a CSV
/// column with UID, Original Text, and Translated Text fields. This is so we can generate translation CSVs
/// to send out to translators. The CSV name is the language locale as string provided in parameters of the 
/// createCSVFromPrsDataTextNodes method.
class CSVGenerator {
  CSVGenerator();

  /// Given a Presentation tree, return a CSV file of all unique IDs, text nodes, and a 3rd column for translations.
  /// [data] is the Presentation tree. The tree is not validated for Unique ID assignment, for separation of responsibilities.
  /// [language] is the selecteed language locale, which will be the name of the generated CSV file.
  /// The format of the first row is 'textID,originalText,translatedText'
  /// The rest of the rows will be unique ID, text, and text again
  /// 
  /// This method should only be used by Luna, not outside users
  Future<File> createCSVFromPrsDataTextNodes(
      PrsNode data, Locale language) async {
    // await LogManager().logFunction('ModuleTextElements.generateCSV', () async {
    List<TextNode> _elements = [];
    _walkPrsTreeRecursively(_elements, data);
    String csvFileName = "${language.toLanguageTag()}.csv";
    

    // TODO: File creation on disk is slow , reconsider
    String tempDirPath = Directory.systemTemp.path;
    String filePath = path.join(tempDirPath, csvFileName);
    List<String> lines = ['textID,originalText,translatedText'];

    _elements.forEach((element) {
      lines.add(
          '"${element.uid}","${element.text}","${element.text}"');
    });

    File file = File(filePath);
    try {
      await file.writeAsString(lines.join('\n'));
      return file;
    } catch (error, stacktrace) {
      // LogManager().logError(error, stacktrace, false);
      // rethrow; // Rethrow the error to handle it further up the call stack or in tests
    }
    // });
    throw Exception(
        'Failed to generate CSV'); // Shouldn't reach here, but satisfy the IDE to not be red
  }

  /// Recursive function to walk a presentation tree and retrieve all text node references. 
  void _walkPrsTreeRecursively(List<TextNode> textNodes, PrsNode node) {
    if (node is TextNode) {
      var textNode = node;
      // We found an assigned UID. This means the whole PrsNode tree is invalid,
      // because we only want to work with unassigned clean PrsNode trees that have no assigned UID
      // textnodes.
      // Return false and empty the text nodes.
      textNodes.add(textNode);
    }
    for (PrsNode child in node.children) {
      _walkPrsTreeRecursively(textNodes, child);
    }
  }
}
