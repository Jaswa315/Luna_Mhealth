// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emu.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EMU extends EMU {
  @override
  final int value;

  factory _$EMU([void Function(EMUBuilder)? updates]) =>
      (new EMUBuilder()..update(updates))._build();

  _$EMU._({required this.value}) : super._() {
    BuiltValueNullFieldError.checkNotNull(value, r'EMU', 'value');
  }

  @override
  EMU rebuild(void Function(EMUBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EMUBuilder toBuilder() => new EMUBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EMU && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EMU')..add('value', value))
        .toString();
  }
}

class EMUBuilder implements Builder<EMU, EMUBuilder> {
  _$EMU? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  EMUBuilder();

  EMUBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EMU other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EMU;
  }

  @override
  void update(void Function(EMUBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EMU build() => _build();

  _$EMU _build() {
    final _$result = _$v ??
        new _$EMU._(
            value:
                BuiltValueNullFieldError.checkNotNull(value, r'EMU', 'value'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
