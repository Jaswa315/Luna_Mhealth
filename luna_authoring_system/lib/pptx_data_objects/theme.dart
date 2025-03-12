import 'package:luna_core/utils/emu.dart';

class Theme {
  final int themeId;
  late final Map<int, EMU> thicknessMap;

  Theme(this.themeId) {
    thicknessMap = {};
  }

  void addThickness(int key, EMU value) {
    thicknessMap[key] = value;
  }

  EMU getThickness(int key) {
    return thicknessMap[key] ?? EMU(0);
  }
}
