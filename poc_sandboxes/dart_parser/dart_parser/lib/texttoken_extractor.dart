// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Text Token Extractor
/// Purpose: Given a Presentation Node token data PrsNode, extract just the unique ID and text tokens
/// and store them in a map. This class MAY be turned into an "Extractor" object later
/// which extracts and converts to CSV. this is just the logic to get minimum tokens we need first
import 'dart:convert';
import 'dart:io';
import 'presentation_tree.dart';
import 'presentation_parser.dart';


// Map text tokens to their content
Map<int, String> mapTextTokens(PrsNode presentation) {
  Map<int, String> textTokenMap = {};

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
            if (textNode.text != null) {
              // Use the UID as-is
              int uid = textNode.uid;
              // Map the UID to the text content
              textTokenMap[uid] = textNode.text!;
            }
          }
        }
      }
    }
  }
  // Return map with details of all text tokens
  return textTokenMap;
}

void main() {
  var filename = "Luna_sample_module.pptx";
  // File object to handle the file operations
  File pptxFile = File(filename);

  // Use presentation_parser.dart to parse the pptx file into a tree of parse node
  PresentationParser parser = PresentationParser(pptxFile);
  PrsNode prsTree = parser.parsePresentation();

  // Use the parsed tree to map the text tokens to their content and UID
  var textTokenMap = mapTextTokens(prsTree);

  // Iterate through textTokenMap to print out the contents and UIDs
  textTokenMap.forEach((uid, text) {
    print('UID: $uid, Text: $text');
  });
}