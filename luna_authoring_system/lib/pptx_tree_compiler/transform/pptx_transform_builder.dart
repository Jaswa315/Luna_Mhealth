import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_constants.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_core/utils/types.dart';

/// This class is responsible for building the Transform object from a JSON map.
class PptxTransformBuilder {
  Transform getTransform(Json transformMap) {
    Point offset = Point(
      EMU(int.parse(transformMap[eOffset][eX])),
      EMU(int.parse(transformMap[eOffset][eY])),
    );

    Point size = Point(
      EMU(int.parse(transformMap[eSize][eCX])),
      EMU(int.parse(transformMap[eSize][eCY])),
    );

    return Transform(
      offset,
      size,
    );
  }
}
