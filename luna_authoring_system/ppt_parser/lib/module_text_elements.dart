// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import 'dart:io';
import 'presentation_tree.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart';

/// The Text Element class is created for every text node from presentations. The node's data and translation can be stored in here.
class TextElement {
  /// Unique identifier for the text element.
  int uid;

  /// The original text to be localized.
  String originalText;

  /// The language locale of the original text element.
  String originalLanguageLocale;

  /// The translated text. Initially the same as [originalText].
  String translatedText;

  /// Creates a [TextElement] with a unique identifier [uid],
  /// the original text [originalText]
  TextElement(this.uid, this.originalText, this.originalLanguageLocale): 
      translatedText = originalText; // Sets localizedText to start with originalText
}

/// ModuleTextElements stores all the text nodes of a module. A CSV of all text nodes can be generated
class ModuleTextElements {
  /// A private map to store each [TextElement] by its UID.
  final Map<int, TextElement> _elements = {};

  /// [_targetLanguageLocale] is the target translation language, also the name of the generated CSV file.
  final String _targetLanguageLocale;

  /// Counter to generate unique UIDs for text elements.
  int _uidCounter = 0;

  /// Constructs a [ModuleTextElements] object and processes the [PrsNode] data
  /// to identify text nodes for localization.
  ModuleTextElements(PrsNode data, this._targetLanguageLocale) {
    _walkPrsNode(data);
  }

  /// Public getter to provide a copy of the [_elements] map.
  Map<int, TextElement> get elements => Map.from(_elements);

  /// Public getter for [_targetLanguageLocale].
  String get languageLocale => _targetLanguageLocale;

  /// Recursively processes each node in the presentation data structure,
  /// identifying text nodes to localize. It assigns new UIDs and
  /// adds the text node to the [_elements] map with its UID as the key.
  void _walkPrsNode(PrsNode node) {
    LogManager().logFunction('ModuleTextElements._walkPrsNode', () async {
      if (node is TextNode) {
        var textNode = node;
        if (textNode.uid == null || _elements.containsKey(textNode.uid)) {
          textNode.uid = ++_uidCounter;
          LogManager().logTrace('Assigned new UID=${textNode.uid} to TextNode',
              LunaSeverityLevel.Information);
        }

        LogManager().logTrace(
            'TextNode found: UID=${textNode.uid}, Text="${textNode.text}"',
            LunaSeverityLevel.Information);

        if (textNode.text != null) {
          _elements[textNode.uid!] = TextElement(
              textNode.uid!, textNode.text!, textNode.language!);
        } else {
          LogManager().logTrace(
              'Skipping TextNode due to null Text', LunaSeverityLevel.Warning);
        }
      }
      // Recursively process all children of the current node
      node.children.forEach(_walkPrsNode);
    });
  }

  /// Validates that every text element has a unique ID.
  bool validatePrsTree() {
    return _elements.values.every((element) => element.uid != null);
  }

  /// Generates a CSV file containing all the module text elements with their
  /// respective UIDs, original text, and translated text.
  /// The generated CSV file is named according to the given language locale.
  ///
  /// [languageLocale] is a [String] representing the targeteted translation language locale of the text elements
  /// being processed, which is also used as part of the CSV filename.
  ///
  /// [directoryPath] is a [String] representing the destination file path that
  /// the CSV file be generated into
  /// 
  /// Returns a [Future] that completes when the CSV file has been written to
  /// the file system.
  Future<void> generateCSV(String languageLocale, String directoryPath) async {
    await LogManager().logFunction('ModuleTextElements.generateCSV', () async {
      try {
        String csvFileName = "$languageLocale.csv";
        String filePath = '$directoryPath/$csvFileName';
        List<String> lines = ['text_ID,originalText,localizedText'];

        _elements.forEach((uid, element) {
          lines.add(
              '"${element.uid}","${element.originalText}","${element.translatedText}"');
        });

        await File(filePath).writeAsString(lines.join('\n'));
        LogManager().logTrace(
            'CSV file generated at: $filePath', LunaSeverityLevel.Information);
      } catch (error, stacktrace) {
        // Log the error if CSV generation fails
        LogManager().logError(error, stacktrace, false);
      }
    });
  }
}
