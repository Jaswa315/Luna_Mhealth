import 'dart:convert';
import 'dart:io';
import 'presentation_tree.dart';
import 'presentation_parser.dart';

// map text boxes to their content 
Map<String, Map<String, dynamic>> mapTextBoxes(PresentationNode presentation) {
  Map<String, Map<String, dynamic>> textBoxMap = {};
  // iterate thru each slide in the presentation 
  for (SlideNode slide in presentation.children.whereType<SlideNode>()) {
    // iterate thru each text box in the slide
    for (TextBoxNode textBox in slide.children.whereType<TextBoxNode>()) {
      // generate a unique ID for each text box
      String uid = textBox.uid.toString().padLeft(3, '0');

      // parse all text segments
      List<String> textSegments = [];
      for (TextBodyNode textBody in textBox.children.whereType<TextBodyNode>()) {
        for (TextParagraphNode paragraph in textBody.children.whereType<TextParagraphNode>()) {
          for (TextNode textNode in paragraph.children.whereType<TextNode>()) {
            if (textNode.text != null) {
              textSegments.add(textNode.text!);
            }
          }
        }
      }

      // combine all text segments into a single string (length locale, uid, text content)
      var combinedText = textSegments.join(' ');
      textBoxMap[uid] = {
        'length': combinedText.length,
        'uid': uid,
        'text': combinedText,
      };
    }
  }
  // return map with details of all text boxes
  return textBoxMap;
}

void main() {
  var filename = "Luna_sample_module.pptx";
  // file object to handle the file operations 
  File pptxFile = File(filename);

  // use presentation_parser.dart to parse the pptx file into a tree of parse node
  PresentationParser parser = PresentationParser(pptxFile);
  PresentationNode prsTree = parser.parsePresentation();

  // use the parsed tree to map the text boxes to their content and UID
  var textBoxMap = mapTextBoxes(prsTree);

  // iterate thru textBoxMap to print out the contents and UIDs
  textBoxMap.forEach((uid, value) {
    print('UID: $uid, Length: ${value['length']}, Text: ${value['text']}');
  });

}
