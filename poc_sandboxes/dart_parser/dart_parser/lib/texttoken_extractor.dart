import 'dart:convert';
import 'dart:io';
import 'presentation_tree.dart';
import 'presentation_parser.dart';

// Map text tokens to their content
Map<int, String> mapTextTokens(PresentationNode presentation) {
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
  PresentationNode prsTree = parser.parsePresentation();

  // Use the parsed tree to map the text tokens to their content and UID
  var textTokenMap = mapTextTokens(prsTree);

  // Iterate through textTokenMap to print out the contents and UIDs
  textTokenMap.forEach((uid, text) {
    print('UID: $uid, Text: $text');
  });
}