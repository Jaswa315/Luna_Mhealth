import 'dart:convert'; 
import 'dart:io'; 
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';  // Import for WidgetsFlutterBinding
import 'package:path_provider/path_provider.dart';

import 'presentation_tree.dart'; 
import 'presentation_parser.dart';

// Class to hold information about text that needs to be localized
class LocalizationTextElement {
  int uid;
  String original; // original text before localization
  String localized = "";
  String languageLocale; // locale this text is associated with

    LocalizationTextElement(this.uid, this.original, this.languageLocale)
    // The localized text is set to be the same as the original text to start with
      : localized = original; 
}

class Localization {
  // A map to store each LocalizationTextElement by its UID
  Map<int, LocalizationTextElement> elements = {};
  String languageLocale;

  Localization(PrsNode data, this.languageLocale) {
    _walkPrsNode(data);
  }

  // Check if a node from the data is a TextNode that needs to be localized
  bool isTextNode(PrsNode node) {
    return node is TextNode;
  }

int _uidCounter = 0;  // Counter to generate unique UIDs

// Process each node, looking for text to localize
void _walkPrsNode(PrsNode node) {

    if (node is TextNode) {
      var textNode = node;
      // If this text node doesn't have a UID or it's already used, assign a new unique one
      if (textNode.uid == null || elements.containsKey(textNode.uid)) {
        textNode.uid = ++_uidCounter;
      }
      print('TextNode found: UID=${textNode.uid}, Text="${textNode.text}"');
      // If the text is not null, add a new LocalizationTextElem
      if (textNode.text != null) {
        elements[textNode.uid!] = LocalizationTextElement(
            textNode.uid!, 
            textNode.text!, 
            this.languageLocale 
        );
      } else {
        // If there's no text, log that we're skipping this node
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

// Create a CSV file with all the localized text
Future<void> generateCSV(String languageLocale) async {
  // Get the directory where we can save files
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  // Create a file name based on the current locale, like 'en.csv' for English
  String csvFileName = "$languageLocale.csv";
  // Combine the directory and file name into a full file path
  String filePath = '${documentsDirectory.path}/$csvFileName';

  // Start building the CSV content as a list of strings.
  List<String> lines = ['text_ID,original_text,localized_text'];
    elements.forEach((uid, element) {
      lines.add('"${element.uid}","${element.original}","${element.localized}"');
    });
   

    File(filePath).writeAsStringSync(lines.join('\n'));
    // Log where the CSV file was saved
    print('CSV file generated at: $filePath');
  }
}

