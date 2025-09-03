/// =================================================================================================
/// XML ELEMENTS CONSTANTS FOR PPTX SLIDE MASTER PARSER
/// =================================================================================================
/// 
/// This file contains the XML element constants used in the PptxSlideMasterParser class.
/// 
/// The XML element for an instance of a slide master in the PowerPoint file.
const String eSlideMaster = 'p:sldMaster';

/// The XML element for text styles in the slide master.
const String eTextStyles = 'p:txStyles';

/// The XML element for title styles in the text styles.
const String eTitleStyle = 'p:titleStyle';

/// The XML element for body styles in the text styles.
const String eBodyStyle = 'p:bodyStyle';

/// The XML element for other styles in the text styles.
const String eOtherStyle = 'p:otherStyle';

/// The XML element specifies all paragraph level text properties for
/// all elements that have the attribute <lvl="0">. 
const String eLvl1pPr = 'a:lvl1pPr';

/// The XML element contains all default run level text properties for
/// the text runs within a containing paragraph.
const String eDefRPr = 'a:defRPr';

/// The XML attribute for the font size of the text run.
const String eSz = '_sz';

/// String value representing the body text styles.
const String body = 'body';

/// String value representing other text styles.
const String other = 'other';