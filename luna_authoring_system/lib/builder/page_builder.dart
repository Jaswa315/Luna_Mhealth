import 'package:luna_authoring_system/builder/component_builder.dart';
import 'package:luna_authoring_system/builder/i_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/page.dart';

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
