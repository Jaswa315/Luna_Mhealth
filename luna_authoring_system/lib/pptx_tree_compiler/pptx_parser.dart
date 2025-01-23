import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_loader.dart';
import 'package:luna_core/utils/emu.dart';
import 'package:luna_core/utils/types.dart';

/// The PptxParser takes a .pptx file and is capable of making a
/// PptxTree object that represents given PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxParser {
  late PptxLoader _pptxLoader;
  PptxTree _pptxTree = PptxTree();

  PptxParser(String pptxFilePath) {
    _pptxLoader = PptxLoader(pptxFilePath);
  }

  void _updateTitleAndAuthor() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    _pptxTree.title = coreMap['cp:coreProperties']['dc:title'];
    _pptxTree.author = coreMap['cp:coreProperties']['dc:creator'];
  }

  void _updateWidthAndHeight() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");
    _pptxTree.width =
        EMU(int.parse(presentationMap['p:presentation']['p:sldSz']['_cx']));
    _pptxTree.height =
        EMU(int.parse(presentationMap['p:presentation']['p:sldSz']['_cy']));
  }

  PptxTree getPptxTree() {
    _updateTitleAndAuthor();
    _updateWidthAndHeight();

    return _pptxTree;
  }
}
