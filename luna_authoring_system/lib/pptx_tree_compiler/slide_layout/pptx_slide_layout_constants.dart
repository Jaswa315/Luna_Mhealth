/// =================================================================================================
/// XML ELEMENTS CONSTANTS FOR PPTX SLIDE LAYOUT PARSER
/// =================================================================================================
/// This file contains the XML element constants used in the PptxSlideLayoutParser class.
/// 
/// The XML element for an instance of a slide layout in the PowerPoint file.
const String eSlideLayout = 'p:sldLayout';

/// The XML element for the common slide data in the slide.
const String eCommonSlideData = 'p:cSld';

/// The XML element for the shape tree in the common slide data.
const String eShapeTree = 'p:spTree';

/// The XML element for the non visual properties for a shape.
const String eNvSpPr = 'p:nvSpPr';

/// The XML element for the the non visual properties for objects.
const String eNvPr = 'p:nvPr';

/// The XML element for the placeholder shape.
const String ePlaceholder = 'p:ph';

/// The XML attribute for the placeholder index.
const String eIdx = '_idx';