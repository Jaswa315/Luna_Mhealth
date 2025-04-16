/// =================================================================================================
/// XML ELEMENTS CONSTANTS FOR CONNECTION SHAPE BUILDER
/// =================================================================================================
/// This file contains the XML element constants used in the PptxConnectionShapeBuilder class.
///
/// The XML element for the connection shape element in a PowerPoint presentation.
const String eConnectionShape = 'p:cxnSp';

/// The XML element for the offset in the bounding box location.
const String eOffset = 'a:off';

/// The XML element for the extents which specifies the size of the bounding box.
const String eSize = 'a:ext';

/// The XML element for the coordinate along the x-axis.
const String eX = '_x';

/// The XML element for the coordinate along the y-axis.
const String eY = '_y';

/// The XML element for the width in EMUs.
const String eCX = '_cx';

/// The XML element for the height in EMUs.
const String eCY = '_cy';

/// The XML element for the line element in PowerPoint.
const String eLine = 'a:ln';

/// The XML element for the width of connection shape.
const String eLineWidth = '_w';

/// The XML element for the solid fill style in PowerPoint.
/// See more information in this documentation.
/// https://www.datypic.com/sc/ooxml/t-a_CT_FillStyleList.html
const String eSolidFill = 'a:solidFill';

/// The XML element for the srgbColor element in PowerPoint.
const String eSrgbColor = 'a:srgbClr';

/// The XML element for the alpha element in PowerPoint.
const String eAlpha = 'a:alpha';

/// The XML element that indicates the vertical flip of connection shape.
const String flipVertical = '_flipV';

/// The XML element for the value of an pptx element.
const String eValue = '_val';

/// The XML element for the shape properties within a shape.
const String eShapeProperty = 'p:spPr';

/// The XML element for the transform information.
/// http://officeopenxml.com/drwSp-location.php#:~:text=The%20is,specified%20by%20the%20y%20attribute.
const String eTransform = 'a:xfrm';
