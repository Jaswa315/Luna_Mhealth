/// Represents a page in the application.
/// A page can contain multiple components.

import 'dart:convert';

import 'package:luna_core/models/components/component_serializer.dart';
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

  /// The slide number of this page
  final int slideNumber;

  /// The parent sequence of pages to which this page belongs.
  late SequenceOfPages _sequenceOfPages;

  /// Constructs a new instance of [Page].
  Page({
    List<Component>? components,
    required this.slideNumber,
  }) : components = components ?? [] {
    if (slideNumber < 1) {
      throw ArgumentError('slideNumber must be greater than 0');
    }
  }

  /// Gets the list of components in the page.
  List<Component> get getPageComponents => List.unmodifiable(components);

  /// Returns the SequenceOfPages this Page belongs to.
  SequenceOfPages getsequenceOfPages() => _sequenceOfPages;

  /// Sets the parent sequence, only if not set or set to the same sequence.

  /// Adds a component to the page.
  void addComponent(Component component) {
    components.add(component);
  }

  List<Component> get pageComponents => List.unmodifiable(components);

  void setSequenceOfPages(SequenceOfPages sequence) {
    _sequenceOfPages = sequence;
  }

  /// Removes a component from the page.
  void removeComponent(Component component) {
    components.remove(component);
  }

  /// Factory constructor that creates a [Page] from JSON.
  ///
  /// It validates that the object is of type 'page', deserializes the shapes into
  /// [Component] objects, and assigns the given [SequenceOfPages] reference to
  /// establish ownership. This supports reconstructing full navigation context.
  factory Page.fromJson(Json json, SequenceOfPages sequence) {
    if (json['type'] != 'page') {
      throw FormatException('Only page type components are allowed');
    }

    List<Component> components = (json['shapes'] as List<dynamic>)
        .map((shapeJson) => ComponentSerializer.fromJson(shapeJson))
        .toList();

    int slideNumber = json['slideNumber'] as int;

    final page = Page(components: components, slideNumber: slideNumber);
    page._sequenceOfPages = sequence;

    return page;
  }

  /// Converts the [Page] object to a JSON-friendly format.
  ///
  /// This includes serializing all component shapes and referencing its parent
  /// [SequenceOfPages] by a unique ID from [objectIdMap]. The full serialized
  /// data is stored in [serializedDefinitions] to avoid inline duplication.
  Json toJson(
    Map<Object, String> objectIdMap,
    Map<String, Json> serializedDefinitions,
  ) {
    final sequenceId = objectIdMap.putIfAbsent(
      _sequenceOfPages,
      () => 'seq_${objectIdMap.length}',
    );

    return {
      'type': 'page',
      'sequence': sequenceId,
      'shapes': components
          .map((c) => ComponentSerializer.serializeComponent(c))
          .toList(),
      'slideNumber': slideNumber,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson({}, {}));
  }
}
