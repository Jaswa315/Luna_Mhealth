import 'package:flutter_test/flutter_test.dart';
import 'package:luna_mhealth_mobile/services/json_parser_service.dart';
import 'package:luna_mhealth_mobile/models/slide_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('JsonParserService Tests', () {
    final JsonParserService jsonParserService = JsonParserService();

    test('Read and parse JSON file', () async {
      // 'test_slide_data.json' is a mock JSON file in assets for testing
      String jsonString = await jsonParserService
          .readJsonFile('../../assets/test_data/test_slide_data.json');
      expect(jsonString.isNotEmpty, true); // Check if JSON string is not empty

      List<Slide> slides =
          await jsonParserService.parseJsonToSlides(jsonString);
      expect(slides.isNotEmpty, true); // Check if slides list is not empty
      expect(
          slides[0], isA<Slide>()); // Check if the first item is a Slide object
      // Add more assertions as needed to validate the structure of Slide objects
    });

    // Additional tests can be written to cover edge cases and error handling
  });
}
