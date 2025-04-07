import 'package:luna_core/enums/unit_type.dart';

/// Defines a `Dimension` class to represent a size or length with a value and a unit type.
/// Supports EMU (English Metric Units), display pixels, and percentage-based dimensions.

class Dimension {
  final double _value;
  final UnitType _unit;

  /// Private named constructor used internally by static creation methods.
  const Dimension._(this._value, this._unit);

  /// Creates a Dimension instance with EMU units.
  static Dimension emu(double value) {
    return Dimension._(value, UnitType.emu);
  }

  /// Creates a Dimension instance with display pixel units.
  static Dimension pixels(double value) {
    return Dimension._(value, UnitType.displayPixels);
  }

  /// Creates a Dimension instance with percent units.
  static Dimension percent(double value) {
    return Dimension._(value, UnitType.percent);
  }

  // Public getters The numeric value of the dimension.
  double get value => _value;

  /// The unit type of the dimension (EMU, display pixels, or percent).
  UnitType get unit => _unit;

  /// Creates a Dimension from a JSON map.
  factory Dimension.fromJson(Map<String, dynamic> json) {
    final value = (json['value'] as num).toDouble();
    final unitStr = json['unit'] as String;

    final unit = UnitType.values.firstWhere(
      (e) => e.name == unitStr,
      orElse: () => throw ArgumentError('Invalid unit type: $unitStr'),
    );

    return Dimension._(value, unit);
  }

  /// Converts this Dimension into a JSON map.
  Map<String, dynamic> toJson() => {
        'value': _value,
        'unit': _unit.name,
      };

  @override
  String toString() => '$value ${unit.name}';
}
