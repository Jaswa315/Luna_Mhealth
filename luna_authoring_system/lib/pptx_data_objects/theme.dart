import 'package:luna_core/utils/emu.dart';

class Theme {
  final int themeId;
  final Map<int, EMU> _thicknessMap;

  Theme(this.themeId) : _thicknessMap = {};

  void setThickness(int key, EMU value) {
    if (value.value <= 0) {
      throw ArgumentError('Thickness value must be greater than 0');
    }
    _thicknessMap[key] = value;
  }

  EMU getThickness(int key) {
    return _thicknessMap[key] ?? EMU(0);
  }

  bool hasThickness(int key) {
    return _thicknessMap.containsKey(key);
  }

  void removeThickness(int key) {
    _thicknessMap.remove(key);
  }
}
