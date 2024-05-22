// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/enums/item_type.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/page.dart';
import 'dart:io';
import 'dart:convert';

const String kTestAssetsPath = 'test/storage/testassets';

void main() {
  group('Module Class Tests', () {
    // Test initialization of the Module
    test('Module is created with expected properties', () {
      final module = Module(
        title: 'This is title',
        pages: [],
        width: 100.0,
        height: 200.0,
      );

      expect(module.id, isNotNull); // ID is auto-generated if not provided
      expect(module.title, 'This is title');
      expect(module.pages, isEmpty);
      expect(module.width, 100.0);
      expect(module.height, 200.0);
      expect(module.itemType, ItemType.module);
    });

    // Test initialization of the Module with ID
    test('Module is created with provided ID', () {
      final module = Module(
        id: '1',
        title: 'This is title',
        pages: [],
        width: 100.0,
        height: 200.0,
      );

      expect(module.id, '1');
      expect(module.title, 'This is title');
      expect(module.pages, isEmpty);
      expect(module.width, 100.0);
      expect(module.height, 200.0);
      expect(module.itemType, ItemType.module);
    });

    // Test deserialization of Module from JSON
    test('Deserialization of Module from JSON', () {
      final json = {
        'module_name': 'This is title',
        'slides': [],
        'dimensions': {'width': 100, 'height': 200},
      };

      final module = Module.fromJson(json);

      expect(module.id, isNotNull); // ID is auto-generated
      expect(module.title, 'This is title');
      expect(module.pages, isEmpty);
      expect(module.width, 100.0);
      expect(module.height, 200.0);
      expect(module.itemType, ItemType.module);
    });

    // Test deserialization of Module from JSON with slides
    test('Deserialization of Module from JSON with slides', () {
      final String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();

      final module = Module.fromJson(jsonDecode(jsonModule));

      expect(module.id, isNotNull); // ID is auto-generated
      expect(module.title, 'This is title');
      expect(module.pages.length, 1);
      expect(module.pages[0].index, 1);
      expect(module.width, 100.0);
      expect(module.height, 200.0);
      expect(module.itemType, ItemType.module);
    });

    // Test deserialization of Module from JSON without slides
    test('Deserialization of Module from JSON without slides', () {
      final json = {
        'module_name': 'This is title',
        'dimensions': {'width': 100, 'height': 200},
      };

      expect(
        () => Module.fromJson(json),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          'Expected a "slides" field with an array value.',
        )),
      );
    });

    // Test serialization of Module to JSON
    test('Serialization of Module to JSON', () {
      final module = Module(
        title: 'This is title',
        pages: [
          Page(index: 1),
          Page(index: 2),
        ],
        width: 100.0,
        height: 200.0,
      );

      final json = module.toJson();

      expect(json, isMap);
      expect(json['module_name'], 'This is title');
      expect(json['slides'], isList);
      expect(json['slides'].length, 2);
      expect(json['slides'][0]['index'], 1);
      expect(json['slides'][1]['index'], 2);
      expect(json['dimensions'], isMap);
      expect(json['dimensions']['width'], 100);
      expect(json['dimensions']['height'], 200);
    });

    // Test string deserialization of Module
    test('String Deserialization - Module', () {
      final jsonString = '''
        {
          "module_name": "This is title",
          "slides": [],
          "dimensions": {"width": 100, "height": 200}
        }
      ''';

      final module = Module.fromJson(jsonDecode(jsonString));

      expect(module.id, isNotNull); // ID is auto-generated
      expect(module.title, 'This is title');
      expect(module.pages, isEmpty);
      expect(module.width, 100.0);
      expect(module.height, 200.0);
      expect(module.itemType, ItemType.module);
    });
  });
}
