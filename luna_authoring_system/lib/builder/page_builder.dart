import 'package:luna_authoring_system/builder/component_builder.dart';
import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/page.dart';

/// PageBuilder is responsible for constructing a `Page` object.
/// It converts a list of `Shape` objects into corresponding `Component` objects
/// and aggregates them into a `Page`.
///
/// This builder provides:
/// - `addComponent()`: Converts a shape into a component and adds it to the list.
/// - `buildPage()`: Clears the components and processes all shapes in one go.
/// - `build()`: Finalizes the `Page` instance.
///
/// The `buildPage()` method ensures that new pages are created with
/// fresh components and prevents stale data from previous builds.

class PageBuilder implements IBuilder<Page> {
  List<Component> _components = [];
  int _moduleWidth;
  int _moduleHeight;

  PageBuilder(this._moduleWidth, this._moduleHeight);

  PageBuilder addComponent(Shape shape) {
    _components.add(
      ComponentBuilder(_moduleWidth, _moduleHeight, shape).build(),
    );

    return this;
  }

  PageBuilder buildPage(List<Shape> shapes) {
    // Clear the components list before adding new components
    _components.clear();
    for (Shape shape in shapes) {
      addComponent(shape);
    }

    return this;
  }

  @override
  Page build() {
    return Page(components: _components);
  }
}
