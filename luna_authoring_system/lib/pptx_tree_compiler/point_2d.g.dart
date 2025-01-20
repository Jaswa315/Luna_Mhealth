// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_2d.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Point2D extends Point2D {
  @override
  final EMU x;
  @override
  final EMU y;

  factory _$Point2D([void Function(Point2DBuilder)? updates]) =>
      (new Point2DBuilder()..update(updates))._build();

  _$Point2D._({required this.x, required this.y}) : super._() {
    BuiltValueNullFieldError.checkNotNull(x, r'Point2D', 'x');
    BuiltValueNullFieldError.checkNotNull(y, r'Point2D', 'y');
  }

  @override
  Point2D rebuild(void Function(Point2DBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Point2DBuilder toBuilder() => new Point2DBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Point2D && x == other.x && y == other.y;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, x.hashCode);
    _$hash = $jc(_$hash, y.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Point2D')
          ..add('x', x)
          ..add('y', y))
        .toString();
  }
}

class Point2DBuilder implements Builder<Point2D, Point2DBuilder> {
  _$Point2D? _$v;

  EMUBuilder? _x;
  EMUBuilder get x => _$this._x ??= new EMUBuilder();
  set x(EMUBuilder? x) => _$this._x = x;

  EMUBuilder? _y;
  EMUBuilder get y => _$this._y ??= new EMUBuilder();
  set y(EMUBuilder? y) => _$this._y = y;

  Point2DBuilder();

  Point2DBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _x = $v.x.toBuilder();
      _y = $v.y.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Point2D other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Point2D;
  }

  @override
  void update(void Function(Point2DBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Point2D build() => _build();

  _$Point2D _build() {
    _$Point2D _$result;
    try {
      _$result = _$v ?? new _$Point2D._(x: x.build(), y: y.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'x';
        x.build();
        _$failedField = 'y';
        y.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Point2D', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
