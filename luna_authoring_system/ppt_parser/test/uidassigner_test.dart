import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';
import 'package:ppt_parser/textnode_uniqueid_assigner.dart';

const String assetsFolder = 'test/test_assets';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UIDAssigner Class Tests', () {
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
        'UIDAssigner: Assigning unique IDs to a PowerPoint with one text box should result in one text node with the unique ID of 1',
        () async {
      PrsTreeTextNodeUIDAssigner uniqueIDAssignerObject =
          PrsTreeTextNodeUIDAssigner();
      String pptx_name = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      Map<int, String>? result =
          uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      expect(result?[1], "Hello, World!");
    });

    test(
        'UIDAssigner: Assigning unique IDs to the same PrsNode twice should result in no changes the second time.',
        () async {
      PrsTreeTextNodeUIDAssigner uniqueIDAssignerObject =
          PrsTreeTextNodeUIDAssigner();
      String pptx_name = "TextBox-HelloWorld.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      Map<int, String>? result1 =
          uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      expect(result1?.isEmpty, false);
      Map<int, String>? result2 =
          uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      expect(result2?.isEmpty, true);
    });

    test(
        'UIDAssigner: Trying to assign UIDs to an empty PowerPoint results in an empty map return value, meaning no UID assignment was done. ',
        () async {
      PrsTreeTextNodeUIDAssigner uniqueIDAssignerObject =
          PrsTreeTextNodeUIDAssigner();
      String pptx_name = "Empty.pptx";
      PrsNode data = await getPresentationData(pptx_name);
      Map<int, String>? result =
          uniqueIDAssignerObject.walkPrsTreeAndAssignUIDs(data);
      expect(result?.isEmpty, true);
    });
  });
}
