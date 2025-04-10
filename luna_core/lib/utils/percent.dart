import 'package:luna_core/utils/i_dimension.dart';

/// Represents a percentage value between 0 and 100.
class Percent extends IDimension {
  final double value;

  Percent(this.value) {
    if (value < 0 || value > 100) {
      throw ArgumentError(
        'Percent value must be between 0 and 100: $value',
        'value',
      );
    }
  }

  @override
  String toString() => '$value%';

  @override
  Map<String, dynamic> toJson() => {
        'value': value,
        'unit': 'percent',
      };
}
