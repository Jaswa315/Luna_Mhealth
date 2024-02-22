// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:luna_mhealth_mobile/models/page.dart';
import 'package:luna_mhealth_mobile/models/component.dart';
import 'package:luna_mhealth_mobile/enums/component_type.dart';

// Updated MockComponent to add to the Page for testing purposes
class MockComponent extends Component {
  MockComponent()
      : super(id: null, name: 'MockComponent', type: ComponentType.text);

  @override
  Widget render() {
    // Return a minimal widget for testing.
    return Placeholder();
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

void main() {
  group('Page Class Tests', () {
    // Test initialization of the Page
    test('Page is created with expected index', () {
      final page = Page(index: 1);

      expect(page.index, 1);
      expect(page.components, isEmpty);
    });

    // Test adding a Component to the Page
    test('Adding a Component to the Page', () {
      final page = Page(index: 1);
      final component = MockComponent();

      page.addComponent(component);

      expect(page.components.length, 1);
      expect(page.components.first, component);
    });

    // Test removing a Component from the Page
    test('Removing a Component from the Page', () {
      final page = Page(index: 1);
      final component = MockComponent();

      page.addComponent(component);
      page.removeComponent(component);

      expect(page.components, isEmpty);
    });

    // Test Serialization of Page
    test('Serialization of Page', () {
      final page = Page(index: 1);
      final component = MockComponent();

      page.addComponent(component);

      final json = page.toJson();

      expect(json, isMap);
      expect(json['index'], 1);
      expect(json['components'], isList);
      expect(json['components'].length, 1);

      final pageFromJson = Page.fromJson(json);
      expect(pageFromJson.index, 1);
      expect(pageFromJson.components.length, 1);
      // Further assertions would depend on the actual implementation of Component.fromJson
    });
  });
}
