import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';

/// Represents the text body element (p:txbody) of a textbox shape in PowerPoint.
/// There can be multiple paragraphs in a text body.
class Textbody {
  /// text paragraphs
  List<Paragraph> paragraphs;

  Textbody({
    required this.paragraphs,
   });
}