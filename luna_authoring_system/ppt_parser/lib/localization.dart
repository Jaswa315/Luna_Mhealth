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
  final Map<int, LocalizationTextElement> elements = {};
  final String languageLocale;
  int _uidCounter = 0;  // Counter to generate unique UIDs

  Localization(PrsNode data, this.languageLocale) {
    _walkPrsNode(data);
  }

  // Public getter to provide a copy of the elements map
  Map<int, LocalizationTextElement> get element => Map.from(elements);

   // Public getter for languageLocale
  String get languageLoc => languageLocale;

  // Recursively processes each node in the presentation data structure, 
  // identifying text nodes to localize. Each text node is checked for a unique
  // identifier (UID). If it does not have one or the UID is already used, 
  // it is assigned a new UID. The function then either adds the text node 
  // to the elements map with its UID as the key if the text is non-null,
  // or logs that the text node is being skipped if the text is null.
  //
  // The function has no return output but has the side effect of populating
  // the elements map with instances of LocalizationTextElement. This map
  // will be later used for localization tasks, such as generating CSV files
  // with localizedText text elements.
  void _walkPrsNode(PrsNode node) {
    if (node is TextNode) {
      var textNode = node;
      if (textNode.uid == null || elements.containsKey(textNode.uid)) {
        textNode.uid = ++_uidCounter;
      }
      print('TextNode found: UID=${textNode.uid}, Text="${textNode.text}"');
      if (textNode.text != null) {
        elements[textNode.uid!] = LocalizationTextElement(
            textNode.uid!, 
            textNode.text!, 
            this.languageLocale 
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
    return elements.values.every((element) => element.uid != null);
  }

  // Generates a CSV file containing all the localization text elements with their
  // respective UIDs, originalText text, and localizedText text.
  // The generated CSV file is named according to the given `languageLocale` and is
  // saved in the application's documents directory.
  //
  // Each line of the CSV represents a text element, with the UID, originalText text,
  // and localizedText text separated by commas. 
  //
  // @param languageLocale A `String` representing the locale of the text elements
  // being processed, which is also used as part of the CSV filename.
  // @return A `Future<void>` that completes when the CSV file has been written to
  // the file system.
  Future<void> generateCSV(String languageLocale) async {
    // Get the directory where we can save files
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // Create a file name based on the current locale, like 'en.csv' for English
    String csvFileName = "$languageLocale.csv";
    // Combine the directory and file name into a full file path
    String filePath = '${documentsDirectory.path}/$csvFileName';

    List<String> lines = ['text_ID,originalText_text,localizedText_text'];
      elements.forEach((uid, element) {
        lines.add('"${element.uid}","${element.originalText}","${element.localizedText}"');
      });
      await File(filePath).writeAsString(lines.join('\n'));
      print('CSV file generated at: $filePath');
  }

}
