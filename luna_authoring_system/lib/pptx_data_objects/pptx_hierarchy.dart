enum PptxHierarchy {
  theme(null, "http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme"),
  slideMaster(theme, "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster"),
  slideLayout(slideMaster, "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout"),
  slide(slideLayout, "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide");

  final PptxHierarchy? parent;
  final String relationshipType;

  const PptxHierarchy(this.parent, this.relationshipType);
}