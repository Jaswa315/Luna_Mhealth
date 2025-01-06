// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pptx_tree.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PptxTree extends PptxTree {
  @override
  final EMU? width;
  @override
  final EMU? height;

  factory _$PptxTree([void Function(PptxTreeBuilder)? updates]) =>
      (new PptxTreeBuilder()..update(updates))._build();

  _$PptxTree._({this.width, this.height}) : super._();

  @override
  PptxTree rebuild(void Function(PptxTreeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PptxTreeBuilder toBuilder() => new PptxTreeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PptxTree && width == other.width && height == other.height;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PptxTree')
          ..add('width', width)
          ..add('height', height))
        .toString();
  }
}

class PptxTreeBuilder implements Builder<PptxTree, PptxTreeBuilder> {
  _$PptxTree? _$v;

  EMUBuilder? _width;
  EMUBuilder get width => _$this._width ??= new EMUBuilder();
  set width(EMUBuilder? width) => _$this._width = width;

  EMUBuilder? _height;
  EMUBuilder get height => _$this._height ??= new EMUBuilder();
  set height(EMUBuilder? height) => _$this._height = height;

  PptxTreeBuilder();

  PptxTreeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _width = $v.width?.toBuilder();
      _height = $v.height?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PptxTree other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PptxTree;
  }

  @override
  void update(void Function(PptxTreeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PptxTree build() => _build();

  _$PptxTree _build() {
    _$PptxTree _$result;
    try {
      _$result = _$v ??
          new _$PptxTree._(width: _width?.build(), height: _height?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'width';
        _width?.build();
        _$failedField = 'height';
        _height?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PptxTree', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
