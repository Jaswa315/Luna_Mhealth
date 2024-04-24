import 'dart:convert'; 
import 'dart:io'; 
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';  // Import for WidgetsFlutterBinding

import 'presentation_tree.dart'; 
import 'presentation_parser.dart';

// Class to hold information about text that needs to be localizedText
class LocalizationTextElement {
  int uid;
  String originalText; 
  String localizedText = "";
  String languageLocale; // locale this text is associated with
  

    LocalizationTextElement(this.uid, this.originalText, this.languageLocale)
    // The localizedText text is set to be the same as the originalText text to start with
      : localizedText = originalText; 
}

class Localization {
  // A map to store each LocalizationTextElement by its UID
  final Map<int, LocalizationTextElement> _elements = {}; // private and final map
  final String _languageLocale; // private and final lang locale
  int _uidCounter = 0;  // Counter to generate unique UIDs

  Localization(PrsNode data, this._languageLocale) {
    _walkPrsNode(data);
  }

  // Public getter to provide a copy of the _elements map
  Map<int, LocalizationTextElement> get elements => Map.from(_elements);

   // Public getter for _languageLocale
  String get languageLocale => _languageLocale;

  // Recursively processes each node in the presentation data structure, 
  // identifying text nodes to localize. Each text node is checked for a unique
  // identifier (UID). If it does not have one or the UID is already used, 
  // it is assigned a new UID. The function then either adds the text node 
  // to the _elements map with its UID as the key if the text is non-null,
  // or logs that the text node is being skipped if the text is null.
  //
  // The function has no return output but has the side effect of populating
  // the _elements map with instances of LocalizationTextElement. This map
  // will be later used for localization tasks, such as generating CSV files
  // with localizedText text _elements.
  void _walkPrsNode(PrsNode node) {
    if (node is TextNode) {
      var textNode = node;
      if (textNode.uid == null || _elements.containsKey(textNode.uid)) {
        textNode.uid = ++_uidCounter;
      }
      print('TextNode found: UID=${textNode.uid}, Text="${textNode.text}"');
      if (textNode.text != null) {
        _elements[textNode.uid!] = LocalizationTextElement(
            textNode.uid!, 
            textNode.text!, 
            this._languageLocale 
        );
      } else {
        print('Skipping TextNode due to null Text');
      }
    }
    // Recursively process all children of the current node
    node.children.forEach(_walkPrsNode);
  }

  // Check if every text element has a unique ID
  bool validatePrsTree() {
    return _elements.values.every((element) => element.uid != null);
  }

  // Generates a CSV file containing all the localization text _elements with their
  // respective UIDs, originalText text, and localizedText text.
  // The generated CSV file is named according to the given `_languageLocale` and is
  // saved in the application's documents directory.
  //
  // Each line of the CSV represents a text element, with the UID, originalText text,
  // and localizedText text separated by commas. 
  //
  // @param _languageLocale A `String` representing the locale of the text _elements
  // being processed, which is also used as part of the CSV filename.
  // @return A `Future<void>` that completes when the CSV file has been written to
  // the file system.
  Future<void> generateCSV(String _languageLocale) async {
    // Get the directory where we can save files
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // Create a file name based on the current locale, like 'en.csv' for English
    String csvFileName = "$_languageLocale.csv";
    // Combine the directory and file name into a full file path
    String filePath = '${documentsDirectory.path}/$csvFileName';

    List<String> lines = ['text_ID,originalText,localizedText'];
      _elements.forEach((uid, element) {
        lines.add('"${element.uid}","${element.originalText}","${element.localizedText}"');
      });
      await File(filePath).writeAsString(lines.join('\n'));
      print('CSV file generated at: $filePath');
  }

}
