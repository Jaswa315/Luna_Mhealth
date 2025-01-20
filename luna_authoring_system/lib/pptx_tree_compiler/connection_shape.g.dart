// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_shape.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectionShape extends ConnectionShape {
  @override
  final EMU? weight;
  @override
  final ShapeType type;
  @override
  final Transform? transform;

  factory _$ConnectionShape([void Function(ConnectionShapeBuilder)? updates]) =>
      (new ConnectionShapeBuilder()..update(updates))._build();

  _$ConnectionShape._({this.weight, required this.type, this.transform})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(type, r'ConnectionShape', 'type');
  }

  @override
  ConnectionShape rebuild(void Function(ConnectionShapeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectionShapeBuilder toBuilder() =>
      new ConnectionShapeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectionShape &&
        weight == other.weight &&
        type == other.type &&
        transform == other.transform;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weight.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, transform.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConnectionShape')
          ..add('weight', weight)
          ..add('type', type)
          ..add('transform', transform))
        .toString();
  }
}

class ConnectionShapeBuilder
    implements Builder<ConnectionShape, ConnectionShapeBuilder> {
  _$ConnectionShape? _$v;

  EMUBuilder? _weight;
  EMUBuilder get weight => _$this._weight ??= new EMUBuilder();
  set weight(EMUBuilder? weight) => _$this._weight = weight;

  ShapeType? _type;
  ShapeType? get type => _$this._type;
  set type(ShapeType? type) => _$this._type = type;

  TransformBuilder? _transform;
  TransformBuilder get transform =>
      _$this._transform ??= new TransformBuilder();
  set transform(TransformBuilder? transform) => _$this._transform = transform;

  ConnectionShapeBuilder();

  ConnectionShapeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weight = $v.weight?.toBuilder();
      _type = $v.type;
      _transform = $v.transform?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectionShape other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ConnectionShape;
  }

  @override
  void update(void Function(ConnectionShapeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectionShape build() => _build();

  _$ConnectionShape _build() {
    ConnectionShape._setShapeType(this);
    _$ConnectionShape _$result;
    try {
      _$result = _$v ??
          new _$ConnectionShape._(
              weight: _weight?.build(),
              type: BuiltValueNullFieldError.checkNotNull(
                  type, r'ConnectionShape', 'type'),
              transform: _transform?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weight';
        _weight?.build();

        _$failedField = 'transform';
        _transform?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ConnectionShape', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
