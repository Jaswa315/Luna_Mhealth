/// PptxElement defines the elements we want to parse from
/// the PowerPoint file. These keys are later used in the
/// pptx parser to identify elements in the PowerPoint shape tree.
/// These Elements are from the MS-PPTX and Office Open XML Documentation
/// The prefix e stands for Element.
class PptxElement {
  /// The XML element for the core properties.
  final String eCoreProperties = 'cp:coreProperties';

  /// The XML element for the title of the PowerPoint.
  final String eTitle = 'dc:title';

  /// The XML element for the author of the PowerPoint.
  final String eAuthor = 'dc:creator';

  /// The XML element for the presentation meta data.
  final String ePresentation = 'p:presentation';

  /// The XML element for the size of the presentation.
  final String eSlideSize = 'p:sldSz';

  /// The XML element for the properties within the application map.
  final String eProperties = 'Properties';

  /// The XML element for the Slides meta data.
  final String eSlides = 'Slides';

  /// The XML element for the slide within a PowerPoint slide.
  final String eSlide = 'p:sld';

  /// The XML element for the common slide data in the slide.
  final String eCommonSlideData = 'p:cSld';

  /// The XML element for the shape tree in the common slide data.
  final String eShapeTree = 'p:spTree';

  /// The XML element for the picture element in a PowerPoint presentation.
  final String ePicture = 'p:pic';

  /// The XML element for the shape element in a PowerPoint presentation.
  final String eShape = 'p:sp';

  /// The XML element for the connection shape element in a PowerPoint presentation.
  final String eConnectionShape = 'p:cxnSp';

  /// The XML element for the shape properties within a shape.
  final String eShapeProperty = 'p:spPr';

  /// The XML element for the transform information.
  /// http://officeopenxml.com/drwSp-location.php#:~:text=The%20is,specified%20by%20the%20y%20attribute.
  final String eTransform = 'a:xfrm';

  /// The XML element for the offset in the bounding box location.
  final String eOffset = 'a:off';

  /// The XML element for the extents which specifies the size
  /// of the bounding box.
  final String eSize = 'a:ext';

  /// The XML element for the coordinate along the x-axis.
  final String eX = '_x';

  /// The XML element for the coordinate along the y-axis.
  final String eY = '_y';

  /// The XML element for the width in EMUs.
  final String eCX = '_cx';

  /// The XML element for the height in EMUs.
  /// The height is applied against the Y axis,
  /// from bottom to top, as compared to y-axis
  /// growing top to bottom.
  /// http://officeopenxml.com/drwSp-size.php
  final String eCY = '_cy';

  /// The XML element for the line element in PowerPoint.
  final String eLine = 'a:ln';

  /// The XML element for the width of connection shape.
  final String eLineWidth = '_w';
}
