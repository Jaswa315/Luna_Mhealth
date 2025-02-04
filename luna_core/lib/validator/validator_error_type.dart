enum ValidatorErrorType {
  // PPTX Validation error types
  pptxTitleHasNoVisibleCharacters,
  pptxTitleIsTooLong,
  pptxWidthMustBePositive,
  pptxHeightMustBePositive,
  pptxWidthAndHeightMustBothBeInitialized,

  /// Point2DPercentage Validation error types
  point2DXPercentageLessThanZero,
  point2DXPercentageGreaterThanOne,
  point2DYPercentageLessThanZero,
  point2DYPercentageGreaterThanOne,
}
