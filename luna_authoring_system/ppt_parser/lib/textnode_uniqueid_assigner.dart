import 'dart:io';
import 'presentation_tree.dart';

/// PrsNodeUniqueIDAssigner class can take presentation trees and assign unique IDs to the
/// presentation data text nodes in place. 
/// 
/// This class should only be used to update a Presentation Tree for all text nodes to have unique IDs,
/// which is a preprocessing step done before generating translation CSVs to send out to translators
class PrsTreeTextNodeUIDAssigner {
  PrsTreeTextNodeUIDAssigner();

  /// We don't accept PrsNode that has been walked already(meaning any UID in data has a value that other than null)
  /// Given Presentation data, walk the data and assign UID to every text node
  /// If the data was already assigned at all or there are no text nodes, an empty Map is returned
  /// Otherwise, if we traverse the data and assign successfully, all updated textnodes mappings will be returned
  /// [data] is the presentation tree with presentation data.
  Map<int, String>? walkPrsTreeAndAssignUIDs(PrsNode data) {
    List<TextNode> textNodes = _walkPrsTreeAndGetTextNodes(data);
    // If any nodes have UID assigned, this PrsNode tree is not eligible to have their UIDs mapped.
    // Also if there is no text nodes, no UID assignments need to be done.
    if (textNodes.isEmpty || !_validateThatAllTextNodesUIDsAreUnassigned(textNodes)) {
      return {};
    }
    // If we get here, the PrsNode is valid and no uids in it are assigned
    // So lets traverse the textnodes and assign uid values to them.
    Map<int, String> updatedNodes = _assignUIDsToTextNodes(textNodes);
    return updatedNodes;
  }

  /// Helper function to retrieve every TextNode reference from the presentation tree
  List<TextNode> _walkPrsTreeAndGetTextNodes(PrsNode data) {
    List<TextNode> textNodes = [];
    _walkPrsTreeRecursively(textNodes, data);
    return textNodes;
  }

  /// Recursive function to walk a presentation tree and retrieve all text node references. 
  void _walkPrsTreeRecursively(List<TextNode> textNodes, PrsNode node) {
    if (node is TextNode) {
      var textNode = node;
      // We found an assigned UID. This means the whole PrsNode tree is invalid,
      // because we only want to work with unassigned clean PrsNode trees that have no assigned UID
      // textnodes.
      // Return false and empty the text nodes.
      textNodes.add(textNode);
    }
    for (PrsNode child in node.children) {
      _walkPrsTreeRecursively(textNodes, child);
    }
  }

  /// Assign a unique ID to every text node.
  Map<int, String> _assignUIDsToTextNodes(List<TextNode> textNodes) {
    Map<int, String> updatedNodes = {};
    int nextUniqueID = 1;
    for (TextNode node in textNodes) {
      node.uid = nextUniqueID;
      updatedNodes[nextUniqueID] = node.text!;
      nextUniqueID++;
    }
    return updatedNodes;
  }
  
  /// Validates that all text nodes have no assigned UIDs.
  /// Returns false if any UID is not null.
  bool _validateThatAllTextNodesUIDsAreUnassigned(List<TextNode> textNodes) {
    for (TextNode node in textNodes) {
      if (node.uid != null) {
        return false; // As soon as a non-null uid is found, return false
      }
    }
    return true; // Only returns true if no non-null uids are found
  }
}
