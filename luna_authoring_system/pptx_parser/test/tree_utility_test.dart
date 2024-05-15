import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pptx_parser/presentation_parser.dart';
import 'package:pptx_parser/presentation_tree.dart';
import 'package:pptx_parser/presentation_tree_utilities.dart';

const String assetsFolder = 'test/test_assets';

// TODO: We want to make IR in memory for future tests instead of putting PPTX
// TODO: Add Instrumentation later instead of too early, to declutter and make refactoring easier.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tree Utility Class Tests', () {
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
        'Tree Utility Get Text Nodes: Getting List of TextNodes from single textbox powerpoint has return value of one textnode in a list.',
        () async {
      String pptx_name = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      PrsTreeUtilities tree_utilities = PrsTreeUtilities();
      List<TextNode> allTextNodes = tree_utilities.getAllTextNodes(data);
      expect(allTextNodes.length, 1);
      expect(allTextNodes[0].text, "Hello, World!");
    });
    test(
        'Tree Utility UIDAssigner: Assigning unique IDs to a PowerPoint with one text box should result in one text node with the unique ID of 1',
        () async {
      PrsTreeUtilities uniqueIDAssignerObject = PrsTreeUtilities();
      String pptx_name = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      Map<int, String>? result =
          uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      expect(result?[1], "Hello, World!");
    });

    test(
        'Tree Utility UIDAssigner: Assigning unique IDs to the same PrsNode twice should result in no changes the second time.',
        () async {
      PrsTreeUtilities uniqueIDAssignerObject = PrsTreeUtilities();
      String pptx_name = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      Map<int, String>? result1 =
          uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      expect(result1?.isEmpty, false);
      expect(result1.length == 1, true);
      Map<int, String>? result2 =
          uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      expect(result2?.isEmpty, true);
    });

    test(
        'Tree Utility UIDAssigner: Trying to assign UIDs to an empty PowerPoint results in an empty map return value, meaning no UID assignment was done. ',
        () async {
      PrsTreeUtilities uniqueIDAssignerObject = PrsTreeUtilities();
      String pptx_name = "Empty.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      Map<int, String>? result =
          uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      expect(result?.isEmpty, true);
    });
  });
}
