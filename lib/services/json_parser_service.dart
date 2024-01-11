import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/slide_model.dart';

// Service class for parsing JSON data into Slide and Component objects.
class JsonParserService {
  // Reads a JSON file and returns its content as a String.
  // This method can read from local assets or remote files.
  Future<String> readJsonFile(String fileName) async {
    try {
      // Reading a local asset file. For remote files, use HTTP requests.
      return await rootBundle.loadString(fileName);
    } catch (e) {
      // Handle exceptions like file not found or read errors.
      print('Error reading JSON file: $e');
      rethrow; // Re-throwing the error for higher level handling.
    }
  }

  // Parses the JSON string and converts it into a list of Slide objects.
  Future<List<Slide>> parseJsonToSlides(String jsonString) async {
    try {
      // Decoding the JSON string.
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      // Creating a list of Slide objects from the JSON data.
      List<Slide> slides = jsonData.entries
          .map((entry) => Slide.fromJSON({'id': entry.key, ...entry.value}))
          .toList();

      // Debug: Print the number of slides parsed
      print('Number of slides parsed: ${slides.length}');
      return slides;
    } catch (e) {
      // Handle parsing errors.
      print('Error parsing JSON data: $e');
      rethrow; // Re-throwing for higher level handling.
    }
  }
}
