// This file defines the Slide class to represent each slide in the JSON data.

import 'component_model.dart'; // Importing the Component model.

class Slide {
  final String id;
  final List<Component> components;

  // Constructor for Slide class.
  Slide({required this.id, required this.components});

  // fromJSON named constructor for creating a Slide instance from a JSON map.
  factory Slide.fromJSON(Map<String, dynamic> json) {
    // Extracting the id and title from the JSON map.
    String id = json['id'] as String;

    // Extracting the components data, assuming it's a list of JSON objects.
    var componentJsonList = json['components'] as List;
    // Mapping each JSON object in the list to a Component instance.
    List<Component> components = componentJsonList
        .map((componentJson) =>
            Component.fromJSON(componentJson as Map<String, dynamic>))
        .toList();

    // Returning a new Slide instance.
    return Slide(id: id, components: components);
  }
}
