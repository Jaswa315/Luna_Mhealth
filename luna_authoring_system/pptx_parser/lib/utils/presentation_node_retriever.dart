import 'dart:io';
import 'package:pptx_parser/parser/presentation_tree.dart';

/// PrsTreeDataTextRetreiver allows us to retrieve all TextNodes from a tree.
/// We may add functionality in the future to retrieve Audio and Images from a data tree.
class PrsNodeRetriever {
  PrsNodeRetriever();

  /// Helper function to retrieve every TextNode reference from the presentation tree
  List<TextNode> getAllTextNodes(PrsNode data) {
    List<TextNode> textNodes = _walkPrsTreeRecursively(data);
    return textNodes;
  }

  /// Recursive function to walk a presentation tree and retrieve all text node references.
  List<TextNode> _walkPrsTreeRecursively(PrsNode node) {
    List<TextNode> textNodes = [];

    if (node is TextNode) {
      textNodes.add(node);
    }
    for (PrsNode child in node.children) {
      textNodes.addAll(_walkPrsTreeRecursively(child));
    }
    return textNodes;
  }
}
