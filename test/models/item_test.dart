// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_mhealth_mobile/enums/item_type.dart';
import 'package:luna_mhealth_mobile/models/item.dart';

void main() {
  group('Item', () {
    test('should create an Item with a UUID if none is provided', () {
      final item = Item(name: 'Test Item', itemType: ItemType.page);
      expect(item.id, isNotNull);
      expect(item.id, isA<String>());
    });

    test('should convert an Item to JSON and back', () {
      final item = Item(name: 'Test Item', itemType: ItemType.page);
      final json = item.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['name'], equals('Test Item'));
      expect(json['itemType'], equals('page'));

      final newItem = Item.fromJson(json);
      expect(newItem.id, equals(item.id));
      expect(newItem.name, equals('Test Item'));
      expect(newItem.itemType, equals(ItemType.page));
    });

    test('should throw an error if invalid itemType is provided', () {
      expect(
        () => Item.fromJson(
            {'id': '123', 'name': 'Invalid', 'itemType': 'invalidType'}),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
