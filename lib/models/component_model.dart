// This file defines the Component class for each element on a slide.

class Component {
  final String type;
  final String? text;
  final String? imageUrl;
  final double width;
  final double height;
  final double left;
  final double top;

  // Constructor for Component class.
  Component({
    required this.type,
    this.text,
    this.imageUrl,
    required this.width,
    required this.height,
    required this.left,
    required this.top,
  });

  // fromJSON named constructor for creating a Component instance from a JSON map.
  factory Component.fromJSON(Map<String, dynamic> json) {
    // Extracting attributes from the JSON map.
    String type = json['type'] as String;
    String? text = json['text'] as String?;
    String? imageUrl = json['imageUrl'] as String?;
    double width = (json['width'] as num?)?.toDouble() ?? 0.0;
    double height = (json['height'] as num?)?.toDouble() ?? 0.0;
    double left = (json['left'] as num?)?.toDouble() ?? 0.0;
    double top = (json['top'] as num?)?.toDouble() ?? 0.0;

    // Returning a new Component instance.
    return Component(
      type: type,
      text: text,
      imageUrl: imageUrl,
      width: width,
      height: height,
      left: left,
      top: top,
    );
  }
}
