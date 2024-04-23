import 'dart:convert'; 
import 'dart:io'; 
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';  // Import for WidgetsFlutterBinding
import 'dart:developer' as developer;

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
  final Map<int, LocalizationTextElement> elements = {};
  final String languageLocale;
  int _uidCounter = 0;  // Counter to generate unique UIDs

  Localization(PrsNode data, this.languageLocale) {
    _walkPrsNode(data);
  }

  // Public getter to provide a copy of the elements map
  Map<int, LocalizationTextElement> get element => Map.from(elements);

  // Public getter for languageLocale
  String get languageLoca => languageLocale;

  // Process each node, looking for text to localize
  void _walkPrsNode(PrsNode node) {
    if (node is TextNode) {
      var textNode = node;
      // If this text node doesn't have a UID or it's already used, assign a new unique one
      if (textNode.uid == null || elements.containsKey(textNode.uid)) {
        textNode.uid = ++_uidCounter;
      }
      // Info level logging
      developer.log('TextNode found: UID=${textNode.uid}, Text="${textNode.text}"', level: 500); 
      // If the text is not null, add a new LocalizationTextElement
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
    node.children.forEach(_walkPrsNode);
}

  // Check if every text element has a unique ID
  bool validatePrsTree() {
    return elements.values.every((element) => element.uid != null);
  }

  // Generates a CSV file containing all localized text elements.
  // The CSV is named according to the provided `languageLocale` and saved
  // in the application's document directory.
  Future<void> generateCSV(String languageLocale) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String csvFileName = "$languageLocale.csv";
    String filePath = '${documentsDirectory.path}/$csvFileName';

    List<String> lines = ['text_ID,original_text,localized_text'];
      elements.forEach((uid, element) {
        lines.add('"${element.uid}","${element.original}","${element.localized}"');
      });

      await File(filePath).writeAsString(lines.join('\n'));
      print('CSV file generated at: $filePath');
  }
}

