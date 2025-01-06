class DataTreeValidator {
  static bool isComponentInBounds(double moduleMaxWidth, double moduleMaxHeight, double componentBottomRightX, double componentBottomRightY) {
    return componentBottomRightX <= moduleMaxWidth && componentBottomRightY <= moduleMaxHeight;
  }
}