// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert'; // For JSON encoding
import 'dart:io'; // For file operations
import 'uid_object.dart';

import 'presentation_tree.dart'; // Custom module for presentation tree
import 'presentation_parser.dart'; // Custom module for presentation parsing

/// Localization class for managing string mappings and UIDs.
class Localization {
  // Map to store unique ID keys to UID Objects. Potentially useful for CSV later.
  late Map<int, UIDObject> _uidMap; 

  // Global variable to track the next available UID
  late int _nextUID; 

  // Have we localized any tree yet? We only support on localization run right now.
  bool initialized = false;

  /// Constructor to initialize variables.
  Localization() {
    _nextUID = 1; // Initialize next UID
    _uidMap = {};
  }

  // Given a Parse Tree, map all the text tokens to a UID.
  // If at least one text token is localized, returns true.
  // Else false. Only one successful localize can ever be run as of now
  bool localize(PrsNode? data) {
    // Our code should only support one localize call as of right now. No null PrsNodes allowed
    if(initialized == true || data == null) return false;
    
    // Given a Tree of data, just get the text tokens that need to be localized
    List<TextNode> tokens = _extractTextNodes(data);

    // There are no tokens to localize in the input
    if(tokens.isEmpty) return false;  

    // There are tokens to localize. Assign UIDs to each. 
    _assignUIDs(tokens);

    // Our code should only support one localize call as of right now.
    initialized = true;       
    return true;
  }

  int size() {
    return _uidMap.length;
  }

  // Walk the data tree and grab references to each Text Token node. 
  // Return the list of text token nodes. 
  List<TextNode> _extractTextNodes(PrsNode presentation) {
    List<TextNode> textNodes = [];
    // Read through the tree. If tree doesn't follow loop structure, an empty list will be returned
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
      // If a TextNode is unmapped to a UID and has text, map it.
      if ((textNode.uid == null || textNode.uid == 0) && textNode.text != null) {
        _mapText(textNode);
      }
    }
  }

  // Maps a new textnode to a unique ID and creates a UIDObject which belongs to the given text node.
  void _mapText(TextNode textNode) {
    // Save text field for CSV. This can be an empty string. 
    String? text = textNode.text;
    
    // Otherwise map the non-null text and assign ID for localization.
    int id = _nextUID++;  

    // Assign the unique ID to the text node. 
    textNode.uid = id; 

    // Create and assign new UIDObject
    UIDObject newUIDObj = UIDObject(id, text);

    // Map the UID -> UIDObject here.
    _uidMap[newUIDObj.getUID()] = newUIDObj;
  }

   // [TEMPORARY!! HELPFUL TO VIEW TOKENS SINCE THEY ARE ENCAPSULATED...KEEP FOR DEVELOPMENT.]
   // Prints the string mapping. 
   // This is useful for debugging and checking tokens that got localized. 
  void printMap() {
    _uidMap.forEach((key, value) {
      print('$value');
    });
  }
}

/// Main function to parse presentation, perform localization.
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
  bool localized =localizer.localize(prsTree); // Assign UIDs to text nodes in the presentation tree

  if(localized==false) print("Didnt localize");

  localizer.printMap();
}
