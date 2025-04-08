import 'dart:ui';
import 'package:luna_core/utils/dimension.dart';

/// Represents a bounding box with position and size.
/// Immutable from outside: values can only be accessed via getters.
class BoundingBox {
  final Offset _topLeftCorner;
  final Dimension _width;
  final Dimension _height;

  BoundingBox({
    required Offset topLeftCorner,
    required Dimension width,
    required Dimension height,
  })  : _topLeftCorner = topLeftCorner,
        _width = width,
        _height = height,
        assert(topLeftCorner.dx >= 0 && topLeftCorner.dy >= 0);

  /// Getter for the top-left corner.
  Offset get topLeftCorner => _topLeftCorner;

  /// Getter for width.
  Dimension get width => _width;

  /// Getter for height.
  Dimension get height => _height;

  /// Creates a BoundingBox from JSON.
  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      topLeftCorner: Offset(
        (json['topLeftCorner']['dx'] as num).toDouble(),
        (json['topLeftCorner']['dy'] as num).toDouble(),
      ),
      width: Dimension.fromJson(json['width']),
      height: Dimension.fromJson(json['height']),
    );
  }

  /// Converts BoundingBox to JSON.
  Map<String, dynamic> toJson() => {
        'topLeftCorner': {
          'dx': _topLeftCorner.dx,
          'dy': _topLeftCorner.dy,
        },
        'width': _width.toJson(),
        'height': _height.toJson(),
      };

  @override
  String toString() =>
      'BoundingBox(topLeftCorner: $_topLeftCorner, width: $_width, height: $_height)';
}
