import 'package:luna_authoring_system/pptx_data_objects/run.dart';

/// Represents the text paragraph element (a:p) of a textbody element in PowerPoint.
/// There can be multiple runs in a paragraph.
class Paragraph {
  /// text runs
  List<Run> runs;

  Paragraph({
    required this.runs,
  });
}