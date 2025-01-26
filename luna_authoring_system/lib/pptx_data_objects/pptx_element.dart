/// PptxElement defines the elements we want to parse from
/// the PowerPoint file. These keys are later used in the
/// pptx parser to identify elements in the PowerPoint shape tree.
class PptxElement {
  /// From MS-PPTX Documentation
  /// The XML key for a picture element in a PowerPoint presentation.
  static const String keyPicture = 'p:pic';

  /// The XML key for a shape element in a PowerPoint presentation.
  static const String keyShape = 'p:sp';

  /// The XML key for a connection shape element in a PowerPoint presentation.
  static const String keyConnectionShape = 'p:cxnSp';
}
