// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert'; // For JSON encoding
import 'dart:io'; // For file operations
import 'package:dart_parser/uid_object.dart';

import 'presentation_tree.dart'; // Custom module for presentation tree
import 'presentation_parser.dart'; // Custom module for presentation parsing

/// Localization class for managing string mappings and UIDs.
class Localization {
  // This could be TextToken instead? Has a lot of potential !!!
  // UIDObject can be renamed later and can potentially store all translation mappings
  // KEEP IT SIMPLE FOR NOW! ONLY STORES UID OBJECT making it simple for CSV READING!

  late Map<int, UIDObject> uidMap; // Map to store unique ID keys to UID Objects

  late int _nextUID; // Global variable to track the next available UID

  /// Constructor to initialize variables.
  Localization() {
    _nextUID = 1; // Initialize next UID
    uidMap = {};
  }


  // Walk the data tree and grab references to each Text Token node. 
  // Return the list of text token nodes. 
  List<TextNode> gatherTextNodes(PrsNode presentation) {
    List<TextNode> textNodes = [];
    for (SlideNode slide in presentation.children.whereType<SlideNode>()) {
      for (TextBoxNode textBox in slide.children.whereType<TextBoxNode>()) {
        for (TextBodyNode textBody
            in textBox.children.whereType<TextBodyNode>()) {
          for (TextParagraphNode paragraph
              in textBody.children.whereType<TextParagraphNode>()) {
            for (TextNode textNode
                in paragraph.children.whereType<TextNode>()) {
              textNodes.add(textNode); // Add TextNode reference to the list
            }
          }
        }
      }
    }
    return textNodes;
  }

  // Assign a UID to any textnode with unassigned UIDs. 
  void _assignUIDs(List<TextNode> textNodes) {
    for (TextNode textNode in textNodes) {
      // If a TextNode is unmapped to a UID, map
      if (textNode.uid == null || textNode.uid == 0) {
        _mapText(textNode);
      }
    }
  }

  // Maps a new textnode to a unique ID and creates a UIDObject which belongs to the given text node.
  void _mapText(TextNode textNode) {
    UIDObject newUIDObj = UIDObject(_nextUID++);
    textNode.uid = newUIDObj.getUID(); // Create and assign new UIDObject
    uidMap[newUIDObj.getUID()] = newUIDObj;
    

    // ** DEBUG. Logs to console what text node string and UID was assigned **
    // Check if textNode.text is not null before printing
    if (textNode.text != null) {
      String textToken = textNode.text!;

      // just to debug and see tokens are separated correctly
      print('Text: [$textToken ] assigned to [ $newUIDObj ]');
    } 
  }

  // Prints the string mapping.
  void printMap() {
    uidMap.forEach((key, value) {
      print('UID: $value, String: We are not storing strings at the moment.');
    });
  }
}

/// Main function to parse presentation, perform localization, and print tree as JSON.
void main() {
  var filename =
      "Luna_sample_module.pptx"; // Filename of the PowerPoint presentation

  File pptx = File(filename); // Open presentation file

  PresentationParser parse =
      PresentationParser(pptx); // Create presentation parser

  PrsNode prsTree =
      parse.parsePresentation(); // Parse presentation into a tree structure

  Localization localizer = Localization(); // Create localization object

  // Walk the PrsNode tree and get TextNodes in a list
  List<TextNode> nodes = localizer.gatherTextNodes(
      prsTree); // Assign UIDs to text nodes in the presentation tree

  // Iterate through the list of TextNodes and assign UIDs to unnasigned nodes.
  localizer._assignUIDs(nodes);
  
  printTreeAsJSON(prsTree); // Print the updated presentation tree as JSON

}

// Function to print the presentation tree as JSON to a file.
void printTreeAsJSON(PrsNode prsTree) {
  Map<String, dynamic> astJson =
      prsTree.toJson(); // Convert presentation tree to JSON
  String jsonOutput = JsonEncoder.withIndent('  ')
      .convert(astJson); // Encode JSON with indentation
  File('module.json').writeAsStringSync(jsonOutput); // Write JSON to file
}
