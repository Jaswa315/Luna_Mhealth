// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert'; // For JSON encoding
import 'dart:io'; // For file operations
import 'presentation_tree.dart'; // Custom module for presentation tree
import 'presentation_parser.dart'; // Custom module for presentation parsing

/// Localization class for managing string mappings and UIDs.
class Localization {
  late Map<int, String> stringMapping; // Map to store string mappings
  late int _nextUID; // Global variable to track the next available UID

  /// Constructor to initialize variables.
  Localization() {
    stringMapping = {}; // Initialize string mapping
    _nextUID = 0; // Initialize next UID
  }

  /// Walks the presentation tree and assigns UIDs to text nodes.
  void walkTreeAndAssignUIDs(PrsNode presentation) {
    // Iterate through each slide in the presentation
    for (SlideNode slide in presentation.children.whereType<SlideNode>()) {
      // Iterate through each text box in the slide
      for (TextBoxNode textBox in slide.children.whereType<TextBoxNode>()) {
        // Parse all text segments
        for (TextBodyNode textBody
            in textBox.children.whereType<TextBodyNode>()) {
          for (TextParagraphNode paragraph
              in textBody.children.whereType<TextParagraphNode>()) {
            for (TextNode textNode
                in paragraph.children.whereType<TextNode>()) {
              textNode.uid = _nextUID++; // Assign UID to text node
              if (textNode.text != null) {
                mapString(textNode.uid, textNode.text!); // Map UID to string
              }
            }
          }
        }
      }
    }
  }

  /// Maps UID to string.
  void mapString(int id, String str) {
    stringMapping[id] = str; // Add mapping to string mapping
  }
}

/// Main function to parse presentation, perform localization, and print tree as JSON.
void main() {
  var filename = "Luna_sample_module.pptx"; // Filename of the PowerPoint presentation

  File pptx = File(filename); // Open presentation file

  PresentationParser parse = PresentationParser(pptx); // Create presentation parser

  PrsNode prsTree = parse.parsePresentation(); // Parse presentation into a tree structure

  Localization localizer = Localization(); // Create localization object

  // Modifying prsTree UID directly (Pass and modify by reference)
  localizer.walkTreeAndAssignUIDs(prsTree); // Assign UIDs to text nodes in the presentation tree

  printTreeAsJSON(prsTree); // Print the updated presentation tree as JSON
}

/// Function to print the presentation tree as JSON to a file.
void printTreeAsJSON(PrsNode prsTree) {
  Map<String, dynamic> astJson = prsTree.toJson(); // Convert presentation tree to JSON
  String jsonOutput = JsonEncoder.withIndent('  ').convert(astJson); // Encode JSON with indentation
  File('module.json').writeAsStringSync(jsonOutput); // Write JSON to file
}
