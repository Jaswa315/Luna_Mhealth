import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_parser/Localization.dart';
import 'package:dart_parser/uid_object.dart';
import 'package:dart_parser/presentation_parser.dart';
import 'package:dart_parser/presentation_tree.dart';

void main() {
  final String assetsFolder = 'test/test_assets';

  group('Localization Tests', () {
    var filename =
        "Luna_sample_module.pptx"; // Filename of the PowerPoint presentation
    File pptx = File(filename); // Open presentation file
    PresentationParser parse =
        PresentationParser(pptx); // Create presentation parser

    PrsNode prsTree =
        parse.parsePresentation(); // Parse presentation into a tree structure

    Localization localizer = Localization(); // Create localization object
    // Walk the PrsNode tree and get TextNodes in a list
    List<TextNode> nodes = localizer.extractTextNodes(
        prsTree); // Assign UIDs to text nodes in the presentation tree

    test(
        'Localization: Walk Parse Tree and get Tokens: Correct Amount of Tokens',
        () async {
      expect(nodes.length, 13);
    });

    test('Check that Text Tokens in our list of TextNodes are correct', () async {
      // Define your expected text for each text node
      List<String?> expectedTexts = [
        'LUNA',
        'Health for the whole family',
        'How to use this app',
        'Start learning',
        'Page',
        '', // Text is null for the sixth text node
        '2',
        'TestText',
        'Luna',
        '', // Text is null for the ninth text node
        'Health for the Whole Family',
        'How to use this app',
        'Start learning'
      ];

      // Iterate through each text node and check its text against the expected text
      for (int i = 0; i < nodes.length; i++) {
        expect(nodes[i]?.text, expectedTexts[i]);
      }
    });
    // Iterate through the list of TextNodes and assign UIDs to unnasigned nodes.
    localizer.assignUIDs(nodes);

    test(
        'Localization: All TextNodes grabbed from tree are not null and real TextNodes',
        () async {
      // Check if all elements in the list are not null
      nodes.forEach((node) {
        expect(node, isNotNull);
      });
    });

    test(
        'Localization: Tree UID fields modified by Localization are all not null / 0',
        () async {
      nodes.forEach((node) {
        expect(node.uid, isNotNull);
        expect(node.uid, isNot(0));
      });
    });
    test('Localization: Verify uidMap Integrity and Size', () async {
      // Check if uidMap is not null and has a size of 15
      expect(localizer.uidMap, isNotNull);
      expect(localizer.uidMap.length, 13);

      // Iterate through uidMap and check keys match their object value's getUID int values
      localizer.uidMap.forEach((key, value) {
        expect(key, equals(value.getUID()));
      });
    });
  });
}
