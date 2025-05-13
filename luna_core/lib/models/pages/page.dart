/// Represents a page in the application.
/// A page can contain multiple components.

import 'dart:convert';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/utils/types.dart';
import '../components/component.dart';

/// Represents a page in the application.
///
/// A page contains a list of components that can be added or removed.
/// It can be converted to and from a JSON map.
class Page {
  /// A list of components on the slide.
  final List<Component> components;

  /// The parent sequence of pages to which this page belongs.
  late SequenceOfPages _sequenceOfPages;

  /// Constructs a new instance of [Page].
  Page({
    List<Component>? components,
  }) : components = components ?? [];

  /// Gets the list of components in the page.
  List<Component> get getPageComponents => List.unmodifiable(components);

  /// Returns the SequenceOfPages this Page belongs to.
  SequenceOfPages get sequenceOfPages => _sequenceOfPages;

  /// Sets the parent sequence, only if not set or set to the same sequence.
  void setSequenceOfPages(SequenceOfPages sequence) {
    if (_sequenceOfPages != sequence) {
      throw StateError('Parent sequence already set');
    }
    _sequenceOfPages = sequence;
  }

  /// Adds a component to the page.
  void addComponent(Component component) {
    components.add(component);
  }

  /// Removes a component from the page.
  void removeComponent(Component component) {
    components.remove(component);
  }

  /// Converts a JSON map into a Page, ensuring it only includes slides of type "slide".
  factory Page.fromJson(Json json) {
    if (json['type'] != 'page') {
      throw FormatException('Only page type components are allowed');
    }

    List<Component> components = (json['shapes'] as List<dynamic>)
        .map((shapeJson) => Component.fromJson(shapeJson))
        .toList();

    return Page(
      components: components,
    );
  }

  /// Converts a Page into a JSON map.
  Json toJson() {
    return {
      'type': 'page',
      'shapes': components.map((c) => Component.serializeComponent(c)).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
