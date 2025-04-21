enum PptxHierarchy {
  theme(
    null,
    "a:theme",
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme",
  ),
  slideMaster(
    theme,
    "p:sldMaster",
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster",
  ),
  slideLayout(
    slideMaster,
    "p:sldLayout",
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout",
  ),
  slide(
    slideLayout,
    "p:sld",
    "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide",
  );

  final PptxHierarchy? parent;
  final String xmlKey;
  final String relationshipType;

  const PptxHierarchy(this.parent, this.xmlKey, this.relationshipType);
}
