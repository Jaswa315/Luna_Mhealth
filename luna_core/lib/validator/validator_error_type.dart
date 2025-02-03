enum ValidatorErrorType {
  // PPTX Validation error types
  pptxTitleHasNoVisibleCharacters,
  pptxTitleIsTooLong,
  pptxWidthMustBePositive,
  pptxHeightMustBePositive,
  pptxWidthAndHeightMustBothBeInitialized,

  // Mock validator errors for tests
  mockValidatorErrorType,
}