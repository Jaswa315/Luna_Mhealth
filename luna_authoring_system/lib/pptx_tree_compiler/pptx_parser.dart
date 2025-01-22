import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_loader.dart';
import 'package:luna_core/utils/emu.dart';
import 'package:luna_core/utils/types.dart';

class PptxParser {
  late PptxLoader _pptxLoader;

  PptxParser(String pptxFilePath) {
    _pptxLoader = PptxLoader(pptxFilePath);
  }

  PptxTree _updateTitleAndAuthor(PptxTree pptxTree) {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    pptxTree.title = coreMap['cp:coreProperties']['dc:title'];
    pptxTree.author = coreMap['cp:coreProperties']['dc:creator'];

    return pptxTree;
  }

  PptxTree _updateWidthAndHeight(PptxTree pptxTree) {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");
    pptxTree.width =
        EMU(int.parse(presentationMap['p:presentation']['p:sldSz']['_cx']));
    pptxTree.height =
        EMU(int.parse(presentationMap['p:presentation']['p:sldSz']['_cy']));

    return pptxTree;
  }

  PptxTree getPptxTree() {
    PptxTree pptxTree = PptxTree();

    pptxTree = _updateTitleAndAuthor(pptxTree);
    pptxTree = _updateWidthAndHeight(pptxTree);

    return pptxTree;
  }
}
