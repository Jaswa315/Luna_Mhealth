// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transform.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Transform extends Transform {
  @override
  final Point2D offset;
  @override
  final Point2D size;

  factory _$Transform([void Function(TransformBuilder)? updates]) =>
      (new TransformBuilder()..update(updates))._build();

  _$Transform._({required this.offset, required this.size}) : super._() {
    BuiltValueNullFieldError.checkNotNull(offset, r'Transform', 'offset');
    BuiltValueNullFieldError.checkNotNull(size, r'Transform', 'size');
  }

  @override
  Transform rebuild(void Function(TransformBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransformBuilder toBuilder() => new TransformBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Transform && offset == other.offset && size == other.size;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, offset.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Transform')
          ..add('offset', offset)
          ..add('size', size))
        .toString();
  }
}

class TransformBuilder implements Builder<Transform, TransformBuilder> {
  _$Transform? _$v;

  Point2DBuilder? _offset;
  Point2DBuilder get offset => _$this._offset ??= new Point2DBuilder();
  set offset(Point2DBuilder? offset) => _$this._offset = offset;

  Point2DBuilder? _size;
  Point2DBuilder get size => _$this._size ??= new Point2DBuilder();
  set size(Point2DBuilder? size) => _$this._size = size;

  TransformBuilder();

  TransformBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _offset = $v.offset.toBuilder();
      _size = $v.size.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Transform other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Transform;
  }

  @override
  void update(void Function(TransformBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Transform build() => _build();

  _$Transform _build() {
    _$Transform _$result;
    try {
      _$result =
          _$v ?? new _$Transform._(offset: offset.build(), size: size.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'offset';
        offset.build();
        _$failedField = 'size';
        size.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Transform', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
