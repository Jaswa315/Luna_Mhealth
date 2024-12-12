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

  EMU? _width;
  EMU? get width => _$this._width;
  set width(EMU? width) => _$this._width = width;

  EMU? _height;
  EMU? get height => _$this._height;
  set height(EMU? height) => _$this._height = height;

  PptxTreeBuilder();

  PptxTreeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _width = $v.width;
      _height = $v.height;
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
    final _$result = _$v ?? new _$PptxTree._(width: width, height: height);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
