/// Represents a component in the Luna mHealth Mobile application.
///
/// A component is an abstract class that defines the common properties and methods
/// for all UI components in the application. It provides information about the type,
/// position, size, and rendering of a component.
///
/// Subclasses of [Component] should implement the [load] method to load any required
/// assets and the [render] method to render the UI for the component.
// ignore_for_file: public_member_api_docs, comment_references

import 'package:flutter/widgets.dart';
import '../enums/component_type.dart';

abstract class Component {
  /// The type of the component.
  ComponentType type;

  /// The x-coordinate of the component.
  double x;

  /// The y-coordinate of the component.
  double y;

  /// The width of the component.
  double width;

  /// The height of the component.
  double height;

  /// Creates a new Component instance.
  ///
  /// The [type] parameter specifies the type of the component.
  /// The [x] parameter specifies the x-coordinate of the component.
  /// The [y] parameter specifies the y-coordinate of the component.
  /// The [width] parameter specifies the width of the component.
  /// The [height] parameter specifies the height of the component.
  Component({
    required this.type,
    this.x = 0.0,
    this.y = 0.0,
    this.width = 0.0,
    this.height = 0.0,
  });

  /// Abstract method for loading assets.
  ///
  /// This method should be implemented by subclasses to load any required assets
  /// for the component.
  void load();

  /// Abstract method for rendering the UI.
  ///
  /// This method should be implemented by subclasses to render the UI for the component.
  ///
  /// Returns a [Widget] that represents the rendered UI for the component.
  Widget render();
}
