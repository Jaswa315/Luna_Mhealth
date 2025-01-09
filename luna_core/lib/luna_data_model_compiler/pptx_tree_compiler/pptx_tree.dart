import 'package:built_value/built_value.dart';
import 'package:luna_core/utils/emu.dart';

part 'pptx_tree.g.dart';

/// The PptxTree represents the PowerPoint data as a tree.
/// It stores every data we need to build a luna module,
/// containing pptx meta data, slide master, slide layout, slide, and section data.
/// For more information, check the domain diagram at this url.
/// https://app.diagrams.net/#G1oO_dalj6fEq2QAfdHzyQPQiMiSi9CpXE#%7B%22pageId%22%3A%22JfLex2GAHqd8IyoLERXG%22%7D
abstract class PptxTree implements Built<PptxTree, PptxTreeBuilder> {
  EMU? get width;
  EMU? get height;

  PptxTree._();

  factory PptxTree([updates(PptxTreeBuilder b)]) = _$PptxTree;
}
