import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'presentation_tree.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart'; // Adjust the path based on actual location

/// The LocalizationText Element class is created for every text node from presentations. The node's data and translation can be stored in here.
class LocalizationTextElement {
  /// Unique identifier for the text element.
  int uid;

  /// The original text to be localized.
  String originalText;

  /// The localized text. Initially the same as [originalText].
  String localizedText;

  /// The original language associated with this Localization file. (?)
  String languageLocale;

  /// Creates a [LocalizationTextElement] with a unique identifier [uid],
  /// the original text [originalText], and the associated locale [languageLocale].
  LocalizationTextElement(this.uid, this.originalText, this.languageLocale)
      : localizedText =
            originalText; // Sets localizedText to start with originalText
}

/// Manages the localization of node elements retrieved from a presentation.
class Localization {
  /// A private map to store each [LocalizationTextElement] by its UID.
  final Map<int, LocalizationTextElement> _elements = {};

  /// The language locale for the localization.
  final String _languageLocale;

  /// Counter to generate unique UIDs for text elements.
  int _uidCounter = 0;

  /// Constructs a [Localization] object and processes the [PrsNode] data
  /// to identify text nodes for localization.
  Localization(PrsNode data, this._languageLocale) {
    _walkPrsNode(data);
  }

  /// Public getter to provide a copy of the [_elements] map.
  Map<int, LocalizationTextElement> get elements => Map.from(_elements);

  /// Public getter for [_languageLocale].
  String get languageLocale => _languageLocale;

  /// Recursively processes each node in the presentation data structure,
  /// identifying text nodes to localize. It assigns new UIDs and
  /// adds the text node to the [_elements] map with its UID as the key.
  void _walkPrsNode(PrsNode node) {
    LogManager().logFunction('Localization._walkPrsNode', () async {
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
          _elements[textNode.uid!] = LocalizationTextElement(
              textNode.uid!, textNode.text!, this._languageLocale);
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

  /// Generates a CSV file containing all the localization text elements with their
  /// respective UIDs, original text, and localized text.
  /// The generated CSV file is named according to the given language locale.
  ///
  /// TODO!: The CSV file is saved in the application's documents directory.
  ///
  /// [languageLocale] is a [String] representing the locale of the text elements
  /// being processed, which is also used as part of the CSV filename.
  ///
  /// [directoryPath] is a [String] representing the destination file path that
  /// the CSV file be generated into
  /// 
  /// Returns a [Future] that completes when the CSV file has been written to
  /// the file system.
  Future<void> generateCSV(String languageLocale, String directoryPath) async {
    await LogManager().logFunction('Localization.generateCSV', () async {
      try {
        String csvFileName = "$languageLocale.csv";
        String filePath = '$directoryPath/$csvFileName';
        List<String> lines = ['text_ID,originalText,localizedText'];

        _elements.forEach((uid, element) {
          lines.add(
              '"${element.uid}","${element.originalText}","${element.localizedText}"');
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
