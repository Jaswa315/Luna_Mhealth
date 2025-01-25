import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_core/utils/emu.dart';

/// The PptxTree represents the PowerPoint data as a tree.
/// It stores every data we need to build a luna module,
/// containing pptx meta data, slide master, slide layout, slide, and section data.
/// For more information, check the domain diagram at this url.
/// https://app.diagrams.net/#G1oO_dalj6fEq2QAfdHzyQPQiMiSi9CpXE#%7B%22pageId%22%3A%22JfLex2GAHqd8IyoLERXG%22%7D
class PptxTree {
  late String title;
  late String author;

  late EMU width;
  late EMU height;

  late List<Slide> slides;

  PptxTree();
}
