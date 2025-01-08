// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Validator class with helper functions to for Luna data tree values.
class DataTreeValidator {
  /// Checks if a component is within the specified module boundaries.
  ///
  /// Returns `true` if both component's bottom-right coordinates (`componentBottomRightX`, `componentBottomRightY`)
  /// are within the `modulePageWidth` and `modulePageHeight`.
  static bool isComponentInBounds(double modulePageWidth, double modulePageHeight,
      double componentBottomRightX, double componentBottomRightY) {
    return componentBottomRightX <= modulePageWidth &&
        componentBottomRightY <= modulePageHeight;
  }
}
