import 'dart:convert';
import 'dart:typed_data';
// import 'package:luna_core/utils/logging.dart';

// Utility class that extracts data from JSON data strings

// ToDo:  This should be a static class / static methods
class JSONDataExtractor {
  JSONDataExtractor();

  Future<Uint8List?> extractTextDataFromJSONAsCSVBytes(String jsonData) async {
    var textData = _extractTextUIDandStringsFromJSON(jsonData);

    List<String> csvData = [];

    String headerRow = 'textID,originalText,translatedText';
    csvData.add(headerRow);

    for (var element in textData) {
      String line =
          '"${element['textID']}","${element['text']}","${element['text']}"';
      csvData.add(line);
    }

    String csvContent = csvData.join('\n');

    return Uint8List.fromList(utf8.encode(csvContent));
  }

  List<Map<String, dynamic>> _extractTextUIDandStringsFromJSON(
      String jsonString) {
    JSONDataExtractor extractorTool = JSONDataExtractor();
    return extractorTool.getTextDataFromJSON(jsonString);
  }

  // Function to extract text nodes from the JSON structure
  List<Map<String, dynamic>> getTextDataFromJSON(String jsonData) {
    Map<String, dynamic> dataAsMap = jsonDecode(jsonData);
    List<Map<String, dynamic>> collectedTextNodes = [];

    // Recursive function to traverse the JSON
    void recursiveSearch(dynamic element) {
      if (element is Map<String, dynamic>) {
        if (element.containsKey('textID') &&
            element.containsKey('text')) {
          collectedTextNodes
              .add({'textID': element['textID'], 'text': element['text']});
        }
        element.forEach((key, value) {
          recursiveSearch(value);
        });
      } else if (element is List) {
        element.forEach(recursiveSearch);
      }
    }

    // Start the recursive search
    recursiveSearch(dataAsMap);
    return collectedTextNodes;
  }

  String extractLanguageFromJSON(String jsonData) {
    Map<String, dynamic> moduleData = jsonDecode(jsonData);
    // if (!dataAsMap.containsKey('module')) {
    //   //TODO: Log json data given doesn't have presentation key, which means given json Data is an outdated IR, probably from module storage
    //   // since the tests there have old IR module.json
    //   return "en-US";
    // }
    // // Directly access the 'presentation' object
    // Map<String, dynamic> presentation =
    //     dataAsMap['module'] as Map<String, dynamic>;
    // // Retrieve the 'language' string
    // String language = presentation['language'] as String;

    // return language;
    return moduleData['module']?['language'] ?? 'en-us';
  }
}


