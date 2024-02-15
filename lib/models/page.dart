/// Represents a page in the application.
/// A page can contain multiple components.
// ignore_for_file: public_member_api_docs

import 'component.dart';

class Page {
  int index;
  List<Component> components = [];

  /// Constructs a new instance of [Page] with the given [index].
  Page({required this.index});

  /// Adds a [component] to the page.
  void addComponent(Component component) {
    components.add(component);
  }

  /// Removes a [component] from the page.
  void removeComponent(Component component) {
    components.remove(component);
  }
}
