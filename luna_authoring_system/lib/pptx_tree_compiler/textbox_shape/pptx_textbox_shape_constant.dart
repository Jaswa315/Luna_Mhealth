/// =================================================================================================
/// XML ELEMENTS CONSTANTS FOR TEXTBOX SHAPE BUILDER
/// =================================================================================================
/// This file contains the XML element constants used in the PptxTextboxShapeBuilder class.
///
/// The XML element for the shape properties within a shape.
const String eShapeProperty = 'p:spPr';

/// The XML element for the transform information.
/// http://officeopenxml.com/drwSp-location.php#:~:text=The%20is,specified%20by%20the%20y%20attribute.
const String eTransform = 'a:xfrm';

/// The XML element for the text body.
const String eTextBody = 'p:txBody';

/// The XML element for the paragraph.
const String eP = 'a:p';

/// The XML element for the run.
const String eR = 'a:r';

/// The XML element for the text range.
const String eT = 'a:t';

/// The XML element for the run properties.
const String eRPr = 'a:rPr';

/// The XML attribute for the language of the text.
const String eLang = '_lang';