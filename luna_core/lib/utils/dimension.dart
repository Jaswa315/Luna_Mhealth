/// Abstract base class representing a dimension or measurement unit.
///
/// This class serves as a blueprint for unit types like EMU, Percent, and DisplayPixel.
/// Implementations must define how they are serialized to JSON and represented as a string.
abstract class Dimension {
  const Dimension();

  /// Converts the dimension object into a JSON-compatible map.
  Map<String, dynamic> toJson();

  /// Returns a human-readable string representation of the dimension.
  @override
  String toString();
}
