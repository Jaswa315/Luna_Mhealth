/// A relationship represents a relationship found in a .rels file in pptx.
/// Each slide has this file with a list of relationships  
/// to resources, such as images, and other parts of the .pptx
/// http://officeopenxml.com/anatomyofOOXML-pptx.php
/// 
/// Example .rels file:
/// <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
///   <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
/// </Relationships>
/// 
/// Relation class:
/// rID: "rId1"
/// target: "../slideLayouts/slideLayout1.xml"
/// type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout"
/// 
class Relationship {

  /// The relationship ID. This is unique per .rels, but not unique accross the whole pptx
  /// The rIDs are in the .xml files for each slide like so
  /// <a:blip r:embed="rId10"/>
  /// So this relationship is the mapping from rId10 to a particular object
  late String rID;

  /// The target .xml that this relationship points to
  late String target;

  /// The type of the target
  late String type;

  Relationship();
}


