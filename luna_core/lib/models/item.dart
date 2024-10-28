// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert';

import 'package:luna_core/utils/types.dart';
import 'package:uuid/uuid.dart';

import '../enums/item_type.dart';

/// Represents an item in the application.
/// An item has an [id], [name], and [itemType].

class Item {
  /// The unique identifier of the item.
  final String id;

  /// The name of the item.
  final String name;

  /// The type of the item.
  final ItemType itemType;

  /// Creates an [Item] with the given [id], [name], and [itemType].
  Item({String? id, this.name = "", required this.itemType})
      : id = id ?? Uuid().v4(); // Generates a new UUID if none is provided

  /// Converts an [Item] into a JSON map.
  Json toJson() {
    return {
      'id': id,
      'name': name,
      'itemType': itemType.toString().split('.').last, // Enum to string
    };
  }

  /// Creates an [Item] from a JSON map.
  factory Item.fromJson(Json json) {
    return Item(
      id: json['id'] as String?,
      name: json['name'] as String,
      itemType: ItemType.values.firstWhere(
          (e) => e.toString().split('.').last == json['itemType'],
          orElse: () => throw ArgumentError('Invalid content type')),
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
