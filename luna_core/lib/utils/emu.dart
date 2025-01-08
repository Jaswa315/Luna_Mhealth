import 'package:built_value/built_value.dart';

part 'emu.g.dart';

/// EMU(English Metric Units) is a measurement in computer typography.
/// These units are used to translate on-screen layouts to printed layouts for specified printer hardware.
/// EMU units are always positive as descrived in the c-rex documentation.
/// More information about EMU
/// https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_sldSz_topic_ID0EULOGB.html
/// https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-odraw/40cd0cf9-f038-4603-b790-252d93e3e8fd

abstract class EMU implements Built<EMU, EMUBuilder> {
  int get value;

  EMU._() {
    if (value < 0) {
      throw ArgumentError('The EMU value must not be negative.: $value', 'value');
    }
  }

  factory EMU([updates(EMUBuilder b)]) = _$EMU;
}
