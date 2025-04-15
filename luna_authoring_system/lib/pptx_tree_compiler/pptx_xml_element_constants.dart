/// =================================================================================================
/// XML ELEMENTS CONSTANTS
/// =================================================================================================
/// This file contains the XML element constants used in the PPTX tree compiler.
/// 
/// The XML element for the core properties.
const String eCoreProperties = 'cp:coreProperties';

/// The XML element for the title of the PowerPoint.
const String eTitle = 'dc:title';

/// The XML element for the author of the PowerPoint.
const String eAuthor = 'dc:creator';

/// The XML element for the presentation meta data.
const String ePresentation = 'p:presentation';

/// The XML element for the slide Id list in presentation properties.
const String eSlideIdList = 'p:sldIdLst';

/// The XML element for the slide Id in presentation properties.
const String eSlideId = 'p:sldId';

/// The XML element for the extension list in presentation properties.
const String eExtensionList = 'p:extLst';

/// The XML element for the extension in presentation properties.
const String eExtension = 'p:ext';

/// The XML element for uri under extension tag.
const String eUri = '_uri';

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

/// The XML element for the size of the presentation.
const String eSlideSize = 'p:sldSz';

/// The XML element for the properties within the application map.
const String eProperties = 'Properties';

/// The XML element for the Slides meta data.
const String eSlides = 'Slides';

/// The XML element for the slide within a PowerPoint slide.
const String eSlide = 'p:sld';

/// The XML element for the common slide data in the slide.
const String eCommonSlideData = 'p:cSld';

/// The XML element for the common slide data in the slide.
const String eSlideLayoutData = 'p:sldLayout';

/// The XML element for the shape tree in the common slide data.
const String eShapeTree = 'p:spTree';

/// The XML element for the picture element in a PowerPoint presentation.
const String ePicture = 'p:pic';

/// The XML element for the shape element in a PowerPoint presentation.
const String eShape = 'p:sp';

/// The XML element for the connection shape element in a PowerPoint presentation.
const String eConnectionShape = 'p:cxnSp';

/// The XML element for the shape properties within a shape.
const String eShapeProperty = 'p:spPr';

/// The XML element for the transform information.
/// http://officeopenxml.com/drwSp-location.php#:~:text=The%20is,specified%20by%20the%20y%20attribute.
const String eTransform = 'a:xfrm';

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

/// The XML element for the value of an pptx element.
const String eValue = '_val';

/// The XML element for the slideLayout type for the slide.
const String eSlideLayoutKey =
    'http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout';

/// The XML element for the id for the slide.
const String eSldId = "_id";

/// The XML element for the id for the relationship.
const String eRId = "_r:id";

/// The XML element for the slide type in relationships.
const String eSlideKey = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide";