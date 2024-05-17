import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pptx_parser/parser/presentation_parser.dart';
import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:pptx_parser/utils/presentation_node_retriever.dart';

const String assetsFolder = 'test/test_assets';

// TODO: We want to make IR in memory for future tests instead of putting PPTX
// TODO: Add Instrumentation later instead of too early, to declutter and make refactoring easier.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Presentation Data Retriever Class Tests', () {
    setUpAll(() async {
      //LogManager.createInstance();
      // Ensure the output directory exists
    });

    Future<PrsNode> getPresentationData(var pptx_name) async {
      File file = File("$assetsFolder/$pptx_name");
      PresentationParser parser = PresentationParser(file);
      PrsNode prsData = await parser.toPrsNode();
      return prsData;
    }

    test(
        'Presentation Node Retriever - Get Text Nodes: Getting List of TextNodes from single textbox powerpoint has return value of one textnode in a list.',
        () async {
      String pptxName = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptxName);
      PrsNodeRetriever treeUtilities = PrsNodeRetriever();
      List<TextNode> allTextNodes = treeUtilities.getAllTextNodes(data);
      expect(allTextNodes.length, 1);
      expect(allTextNodes[0].text, "Hello, World!");
    });
  });
}
