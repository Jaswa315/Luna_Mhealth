// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';

/// A utility class for scaling calculations.
class ScaleUtilities {
  /// The last scale value used for scaling operations.
  double? lastScale;

  /// The last size value used for scaling operations.
  Size? lastSize;

  /// Calculates the scale factor based on the current size and module width.
  ///
  /// If the current size is the same as the last size and a scale factor has been previously calculated,
  /// the last scale factor will be returned to avoid unnecessary calculations.
  /// Otherwise, a new scale factor will be calculated based on the current size and module width.
  ///
  /// Returns the calculated scale factor.
  double calculateScale(Size currentSize, double moduleWidth) {
    if (lastSize == currentSize && lastScale != null) {
      return lastScale!;
    }
    lastSize = currentSize;
    lastScale = currentSize.width / moduleWidth;
    return lastScale!;
  }
}
