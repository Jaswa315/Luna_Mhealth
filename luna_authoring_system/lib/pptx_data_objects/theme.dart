import 'package:luna_core/utils/emu.dart';

class Theme {
  final int _themeId;
  final Map<int, EMU> _thicknessMap;

  Theme(this._themeId) : _thicknessMap = {};

  int get themeId => _themeId;

  void setThickness(int key, EMU thickness) {
    if (thickness.value <= 0) {
      throw ArgumentError('Thickness value must be greater than 0');
    }
    _thicknessMap[key] = thickness;
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
