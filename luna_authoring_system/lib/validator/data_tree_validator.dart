// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree.dart';

/// The Data Tree Validator class' purpose is to 
/// check if all the values in a pptx data tree are valid to be
/// converted into a Luna module, with the intent to check for
/// corner cases on data variables within the data tree.
class DataTreeValidator { 
  DataTreeValidator();

  /// Checks if entire PptxTree is valid.
  /// 
  /// Returns `true` if the given PptxTree passes all validation checks.
  bool isDataTreeValid(PptxTree pptxTree) {
    if(pptxTree.width == null || pptxTree.height == null) return false;

    return true;
  }

  /// Checks if module width and height are valid values. 
  /// 
  /// Returns `true` if the module's dimensions are valid.
  bool isDataTreeModuleDimensionsValid(double modulePageWidth, double modulePageHeight) {
    if(modulePageWidth <= 0 || modulePageHeight <= 0) {
      return false;
    }
    
    return true;
  }

  /// Checks if a component is within the specified module boundaries.
  ///
  /// Returns `true` if both component's bottom-right coordinates (`componentBottomRightX`, `componentBottomRightY`)
  /// are within the `modulePageWidth` and `modulePageHeight`.
  bool isComponentInBounds(double modulePageWidth, double modulePageHeight,
      double componentBottomRightX, double componentBottomRightY) {
    return componentBottomRightX <= modulePageWidth &&
        componentBottomRightY <= modulePageHeight;
  }
}
