enum PptxHierarchy {
  theme(null),
  slideMaster(theme),
  slideLayout(slideMaster),
  slide(slideLayout);

  final PptxHierarchy? parent;
  
  const PptxHierarchy(this.parent);
}