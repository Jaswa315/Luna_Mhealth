// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:luna_core/enums/component_type.dart';
import 'package:luna_core/models/page.dart';
import 'package:luna_core/models/component.dart';
import 'package:luna_core/models/interfaces/clickable.dart';

// Updated MockComponent to add to the Page for testing purposes
/* TODO: fix class
class MockComponent extends Component implements Clickable {
  MockComponent()
      : super(
          name: 'MockComponent',
          type: ComponentType.text,
          x: 0,
          y: 0,
          width: 100,
          height: 100,
        );

  
  @override
  Future<Widget> render() async {
    // Return a placeholder widget for now.
    return Placeholder();
  }

  @override
  void onClick() {
    print('MockComponent clicked');
  }

  @override
  Map<String, dynamic> toJson() {
    // Return a simple map for testing serialization.
    return {
      'type': type.toString().split('.').last,
    };
  }

  static MockComponent fromJson(Map<String, dynamic> json) {
    return MockComponent();
  }
}
*/

void main() {
  group('Page Class Tests', () {
    // Test initialization of the Page
    test('Page is created with expected index', () {
      /*TODO: fix test
      final page = Page(index: 1);

      expect(page.index, 1);
      expect(page.components, isEmpty);
      */
    });

    // Test adding a Component to the Page
    test('Adding a Component to the Page', () {
      /* TODO: fix test
      final page = Page(index: 1);
      final component = MockComponent();

      page.addComponent(component);

      expect(page.components.length, 1);
      expect(page.components.first, component);
      */
    });

    // Test removing a Component from the Page
    test('Removing a Component from the Page', () {
      /* TODO: fix test
      final page = Page(index: 1);
      final component = MockComponent();

      page.addComponent(component);
      page.removeComponent(component);

      expect(page.components, isEmpty);
      */
    });

    // Test converting a Page to JSON
    test('Converting a Page to JSON', () {
      /* TODO: fix test
      final page = Page(index: 1);
      final component = MockComponent();

      page.addComponent(component);

      final json = page.toJson();

      expect(json['index'], 1);
      expect(json['components'].length, 1);
      expect(json['components'].first['type'], 'text');
      */
    });
  });
}
