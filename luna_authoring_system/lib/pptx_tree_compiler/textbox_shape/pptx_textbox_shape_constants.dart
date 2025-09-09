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

/// The XML element for the non visual properties for a shape.
const String eNvSpPr = 'p:nvSpPr';

/// The XML element for the the non visual properties for objects.
const String eNvPr = 'p:nvPr';

/// The XML element for the placeholder shape.
const String ePlaceholder = 'p:ph';

/// The XML attribute for the placeholder index.
const String eIdx = '_idx';

/// The XML attribute for the placeholder type.
const String eType = '_type';

/// The XML element for the text box shape.
const String eTextboxShape = 'p:sp';

/// The XML element for an instance of a slide layout in the PowerPoint file.
const String eSlideLayout = 'p:sldLayout';

/// The XML element for an instance of a slide master in the PowerPoint file.
const String eSlideMaster = 'p:sldMaster';

/// The XML attribute to specifiy whether the text run is bold.
const String eB = '_b';

/// The XML attribute to specify whether the text run is italicized.
const String eI = '_i';

/// The XML attribute to specify whether the text run is underlined.
const String eU = '_u';

/// The XML attribute to specify the font size of the text run.
const String eSz = '_sz';

/// The XML element specifies the list of styles associated with this body of text.
const String eLstStyle = 'a:lstStyle';

/// The XML element specifies all paragraph level text properties for
/// all elements that have the attribute <lvl="0">. 
const String eLvl1pPr = 'a:lvl1pPr';

/// The XML element contains all default run level text properties for
/// the text runs within a containing paragraph.
const String eDefRPr = 'a:defRPr';

/// Integer value representing the initial placeholder index for text boxes.
/// This is used to determine if the text box is a placeholder shape.
const int initialPLaceholderIndex = -1;

/// String value representing the body placeholder type for text boxes
/// that use body text styles.
const String body = 'body';

/// String value representing other text styles.
const String other = 'other';

/// The XML element for the non-visual canvas properties for a shape.
const String eCNvPr = 'p:cNvPr';

/// The XML atribute specifies the name of a shape.
const String eName = '_name';

/// String value representing the placeholder name for text boxes
const String placeholder = 'Placeholder';