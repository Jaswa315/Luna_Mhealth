/// =================================================================================================
/// XML ELEMENTS CONSTANTS FOR CONNECTION SHAPE BUILDER
/// =================================================================================================
/// This file contains the XML element constants used in the PptxConnectionShapeBuilder class.
///
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
