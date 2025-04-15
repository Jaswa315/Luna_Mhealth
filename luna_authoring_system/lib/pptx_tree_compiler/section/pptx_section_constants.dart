/// =================================================================================================
/// XML ELEMENTS CONSTANTS FOR SECTION BUILDER
/// =================================================================================================
/// This file contains the XML element constants used in the PptxSectionBuilder class.
/// 
/// The XML element for the presentation meta data.
const String ePresentation = 'p:presentation';

/// The XML element for uri under extension tag.
const String eUri = '_uri';

/// The XML element for the properties within the application map.
const String eProperties = 'Properties';

/// The XML element for the Slides meta data.
const String eSlides = 'Slides';

/// The XML element for the slide Id list in presentation properties.
const String eSlideIdList = 'p:sldIdLst';

/// The XML element for the slide Id in presentation properties.
const String eSlideId = 'p:sldId';

/// The XML element for the extension list in presentation properties.
const String eExtensionList = 'p:extLst';

/// The XML element for the extension in presentation properties.
const String eExtension = 'p:ext';

/// The XML element for the name of an section.
const String eName = '_name';

/// The section value for extension in presentation properties.
/// See more information in this documentation.
/// https://learn.microsoft.com/en-us/openspecs/office_standards/ms-pptx/1f21a089-944d-410b-bd47-4f5e692c2532
const String eSectionKey = "{521415D9-36F7-43E2-AB2F-B90AF26B5E84}";

/// The XML element for the section list data in presentation under section tag.
const String eP14SectionList = 'p14:sectionLst';

/// The XML element for the section data in presentation under section tag.
const String eP14Section = 'p14:section';

/// The XML element for the list of slide Id in presentation under section tag.
const String eP14SlideIdList = 'p14:sldIdLst';

/// The XML element for the slide Id in presentation under section tag.
const String eP14SlideId = 'p14:sldId';

/// The XML element for the id for the slide.
const String eSldId = "_id";

/// The XML element for the id for the relationship.
const String eRId = "_r:id";

/// The XML element for the slide type in relationships.
const String eSlideKey = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide";

/// The XML element for the Relationships in the slide.
const String eRelationships = 'Relationships';

/// The XML element for the Relationship in the slide.
const String eRelationship = 'Relationship';

/// The XML element for the id of an relationship.
const String eId = '_Id';

/// The XML element for the Type of an relationship.
const String eType = '_Type';

/// The XML element for the Target of an relationships.
const String eTarget = '_Target';