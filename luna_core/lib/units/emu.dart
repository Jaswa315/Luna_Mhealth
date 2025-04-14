import 'package:luna_core/units/i_dimension.dart';

/// EMU(English Metric Units) is a measurement in computer typography.
/// These units are used to translate on-screen layouts to printed layouts for specified printer hardware.
/// EMU units are non-negative integers as described in the c-rex documentation.
/// More information about EMU:
/// https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_sldSz_topic_ID0EULOGB.html
/// https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-odraw/40cd0cf9-f038-4603-b790-252d93e3e8fd
class EMU extends IDimension {
  final int value;

  EMU(this.value) {
    if (value < 0) {
      throw ArgumentError(
        'The EMU value must not be negative.: $value',
        'value',
      );
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'value': value,
        'unit': 'emu',
      };

  @override
  String toString() => '$value';
}
