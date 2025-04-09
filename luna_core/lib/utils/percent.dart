/// Represents a percentage value between 0 and 100.
class Percent {
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
}
