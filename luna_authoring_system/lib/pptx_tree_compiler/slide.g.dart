// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slide.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Slide extends Slide {
  @override
  final int? slideNumber;
  @override
  final BuiltList<Shape>? shapes;

  factory _$Slide([void Function(SlideBuilder)? updates]) =>
      (new SlideBuilder()..update(updates))._build();

  _$Slide._({this.slideNumber, this.shapes}) : super._();

  @override
  Slide rebuild(void Function(SlideBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SlideBuilder toBuilder() => new SlideBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Slide &&
        slideNumber == other.slideNumber &&
        shapes == other.shapes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slideNumber.hashCode);
    _$hash = $jc(_$hash, shapes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Slide')
          ..add('slideNumber', slideNumber)
          ..add('shapes', shapes))
        .toString();
  }
}

class SlideBuilder implements Builder<Slide, SlideBuilder> {
  _$Slide? _$v;

  int? _slideNumber;
  int? get slideNumber => _$this._slideNumber;
  set slideNumber(int? slideNumber) => _$this._slideNumber = slideNumber;

  ListBuilder<Shape>? _shapes;
  ListBuilder<Shape> get shapes => _$this._shapes ??= new ListBuilder<Shape>();
  set shapes(ListBuilder<Shape>? shapes) => _$this._shapes = shapes;

  SlideBuilder();

  SlideBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slideNumber = $v.slideNumber;
      _shapes = $v.shapes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Slide other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Slide;
  }

  @override
  void update(void Function(SlideBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Slide build() => _build();

  _$Slide _build() {
    _$Slide _$result;
    try {
      _$result = _$v ??
          new _$Slide._(slideNumber: slideNumber, shapes: _shapes?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'shapes';
        _shapes?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Slide', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
