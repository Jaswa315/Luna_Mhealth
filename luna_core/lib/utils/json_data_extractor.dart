import 'dart:convert';
import 'dart:typed_data';
import 'package:luna_core/utils/types.dart';
// import 'package:luna_core/utils/logging.dart';

/// Utility class that extracts data from JSON data strings
// ToDo:  This should be a static class / static methods
class JSONDataExtractor {
  /// default constructor
  JSONDataExtractor();

  /// get textual data from json string as CSV
  Future<Uint8List?> extractTextDataFromJSONAsCSVBytes(String jsonData) async {
    var textData = _extractTextUIDandStringsFromJSON(jsonData);

    List<String> _csvData = [];

    String headerRow = 'textID,originalText,translatedText';
    _csvData.add(headerRow);

    for (var element in textData) {
      String line =
          '"${element['textID']}","${element['text']}","${element['text']}"';
      _csvData.add(line);
    }

    String _csvContent = _csvData.join('\n');

    return Uint8List.fromList(utf8.encode(_csvContent));
  }

  List<Json> _extractTextUIDandStringsFromJSON(String jsonString) {
    JSONDataExtractor extractorTool = JSONDataExtractor();
    return extractorTool.getTextDataFromJSON(jsonString);
  }

  /// Function to extract text nodes from the JSON structure
  List<Json> getTextDataFromJSON(String jsonData) {
    Json dataAsMap = jsonDecode(jsonData);
    List<Json> collectedTextNodes = [];

    // Recursive function to traverse the JSON
    void recursiveSearch(dynamic element) {
      if (element is Json) {
        if (element.containsKey('textID') && element.containsKey('text')) {
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

  /// function to extract language encoding string from json data
  String extractLanguageFromJSON(String jsonData) {
    Json moduleData = jsonDecode(jsonData);
    // if (!dataAsMap.containsKey('module')) {
    //   //TODO: Log json data given doesn't have presentation key, which means given json Data is an outdated IR, probably from module storage
    //   // since the tests there have old IR module.json
    //   return "en-US";
    // }
    // // Directly access the 'presentation' object
    // Json presentation =
    //     dataAsMap['module'] as Json;
    // // Retrieve the 'language' string
    // String language = presentation['language'] as String;

    // return language;
    return moduleData['module']?['language'] ?? 'en-us';
  }
}
