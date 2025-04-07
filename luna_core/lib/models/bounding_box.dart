import 'dart:ui';
import 'package:luna_core/utils/dimension.dart';

/// Represents a bounding box with position and size.
/// Immutable from outside: values can only be accessed via getters.
class BoundingBox {
  final Offset _start;
  final Dimension _width;
  final Dimension _height;

  BoundingBox({
    required Offset start,
    required Dimension width,
    required Dimension height,
  })  : _start = start,
        _width = width,
        _height = height;

  /// Getter for the top-left position.
  Offset get start => _start;

  /// Getter for width.
  Dimension get width => _width;

  /// Getter for height.
  Dimension get height => _height;

  /// Creates a BoundingBox from JSON.
  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      start: Offset(
        (json['start']['dx'] as num).toDouble(),
        (json['start']['dy'] as num).toDouble(),
      ),
      width: Dimension.fromJson(json['width']),
      height: Dimension.fromJson(json['height']),
    );
  }

  /// Converts BoundingBox to JSON.
  Map<String, dynamic> toJson() => {
        'start': {'dx': _start.dx, 'dy': _start.dy},
        'width': _width.toJson(),
        'height': _height.toJson(),
      };

  @override
  String toString() =>
      'BoundingBox(start: $_start, width: $_width, height: $_height)';
}
