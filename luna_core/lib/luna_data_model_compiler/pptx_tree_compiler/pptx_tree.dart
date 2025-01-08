import 'package:built_value/built_value.dart';
import 'package:luna_core/utils/emu.dart';

part 'pptx_tree.g.dart';

abstract class PptxTree implements Built<PptxTree, PptxTreeBuilder> {
  EMU? get width;
  EMU? get height;

  PptxTree._();

  factory PptxTree([updates(PptxTreeBuilder b)]) = _$PptxTree;
}
