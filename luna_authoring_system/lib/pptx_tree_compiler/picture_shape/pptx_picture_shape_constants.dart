/// =================================================================================================
/// XML ELEMENTS CONSTANTS FOR PICTURE SHAPE BUILDER
/// =================================================================================================
/// This file contains the XML element constants used in the [PptxPictureShapeBuilder] class.
/// The XML element for the shape properties within a shape.
const String eShapeProperty = 'p:spPr';

/// The XML element for the transform information.
/// http://officeopenxml.com/drwSp-location.php#:~:text=The%20is,specified%20by%20the%20y%20attribute.
const String eTransform = 'a:xfrm';

/// The XML element for the fill information of the picture shape.
const String eBlipFill = 'p:blipFill';

/// The XML element for the URL of the picture.
const String eBlip = 'a:blip';

/// The XML element for the URL of the picture.
const String eSourceRectangle = 'a:srcRect';

/// The XML element for the embedded relationship id of the picture.
const String eEmbed = '_r:embed';

/// The XML element for the top of the source rectangle.
const String eSourceRectangleTop = '_t';

/// The XML element for the top of the source rectangle.
const String eSourceRectangleBottom = '_b';

/// The XML element for the top of the source rectangle.
const String eSourceRectangleRight = '_r';

/// The XML element for the top of the source rectangle.
const String eSourceRectangleLeft = '_l';
