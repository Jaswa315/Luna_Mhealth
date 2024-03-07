// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_mhealth_mobile/models/module.dart';
import 'package:luna_mhealth_mobile/enums/item_type.dart';
import 'package:luna_mhealth_mobile/models/page.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  group('Module Class Tests', () {
    // Test initialization of the Module
    test('Module is created with expected properties', () {
      final module = Module(
        id: '1',
        title: 'This is title',
        description: 'This is description',
      );

      expect(module.id, isNotNull); // ID is auto-generated if not provided
      expect(module.title, 'This is title');
      expect(module.description, 'This is description');
      expect(module.itemType, ItemType.module);
      expect(module.pages, isEmpty); // Initially, no pages should be present
    });

    // Test adding a Page to the Module
    test('Adding a Page to the Module', () {
      final module = Module(
        title: 'This is title',
        description: 'This is description',
      );
      final page = Page(index: 1);

      module.addPage(page);

      expect(module.pages.length, 1);
      expect(module.pages.first, page);
    });

    // Test removing a Page from the Module
    test('Removing a Page from the Module', () {
      final module = Module(
        title: 'This is title',
        description: 'This is description',
      );
      final page = Page(index: 1);

      module.addPage(page);
      module.removePage(page);

      expect(module.pages, isEmpty);
    });

    // Test finding a Page by index
    test('Finding a Page by index', () {
      final module = Module(
        title: 'This is title',
        description: 'This is description',
      );
      final page = Page(index: 1);
      final page2 = Page(index: 2);

      module.addPage(page);
      module.addPage(page2);

      expect(module.findPageByIndex(1), page);
      expect(module.findPageByIndex(2), page2);
      expect(module.findPageByIndex(3), isNull); // No page at index 3
    });

    // Test Serialization of Module
    test('Serialization of Module', () {
      final module = Module(
        title: 'This is title',
        description: 'This is description',
      );
      final page = Page(index: 1);

      module.addPage(page);

      final json = module.toJson();

      File("test/models/module.json").writeAsStringSync(module.toString());

      expect(json, isMap);
      expect(json['id'], module.id);
      expect(json['title'], 'This is title');
      expect(json['description'], 'This is description');
      expect(json['itemType'], 'module');
      expect(json['pages'], isList);
      expect(json['pages'].length, 1);

      final moduleFromJson = Module.fromJson(json);
      expect(moduleFromJson.id, module.id);
      expect(moduleFromJson.title, 'This is title');
      expect(moduleFromJson.description, 'This is description');
      expect(moduleFromJson.itemType, ItemType.module);
      expect(moduleFromJson.pages.first.index, 1);
    });

    test('String Deserialization - Module', () {
      String jsonModule = File("test/models/module.json").readAsStringSync();

      Module module = Module.fromJson(jsonDecode(jsonModule));

      expect('3380e95d-419c-4b5a-ac7e-22f53aecf0fc', module.id);
      expect('This is title', module.title);
      expect('This is description', module.description);
      expect(ItemType.module, module.itemType);
      expect(1, module.pages[0].index);
    });
  });
}
